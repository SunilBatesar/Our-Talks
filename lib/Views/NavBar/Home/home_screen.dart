import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
import 'package:ourtalks/Views/NavBar/Home/Widgets/user_message_tile.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Networks/realtime%20database/chat_respository.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  static final _userData = _firebaseDatabase.ref("user_data");
  @override
  void initState() {
    super.initState();
    data();
  }

  // USER ONLINE SET FUNCTION
  data() async {
    SystemChannels.lifecycle.setMessageHandler(
      (message) async {
        if (auth.currentUser != null) {
          final db = _userData.child(auth.currentUser!.uid);
          final time = DateTime.now().microsecondsSinceEpoch.toString();
          if (message.toString().contains('resume')) {
            // User comes online
            await ChatRespository.userOnlineValueUpdate(
                userId: Prefs.getUserIdPref(), value: true);

            // Set onDisconnect() to handle unexpected disconnects
            await db.onDisconnect().update(
                RealTimeUserModel(isOnline: false, lastSeen: time).toJson());
          }
          if (message.toString().contains('pause')) {
            // Update last seen when app is in the background
            await ChatRespository.userOnlineValueUpdate(
                userId: Prefs.getUserIdPref(), value: false);
          }
        }
        return Future.value(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR AND SHOW APP NAME
      appBar: AppBar(
        title: Text(
          AppConfig.appName,
          style: cnstSheet.textTheme.appNameStyle15
              .copyWith(color: cnstSheet.colors.primary),
        ),
      ),
      body: SafeArea(
          child: FutureBuilder<List<DocumentSnapshot>>(
        future: ChatRespository.getMyChatroomUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading users"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          final users = snapshot.data!
              .map((doc) => UserModel.fromJson(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          return ListView.builder(
            padding: EdgeInsets.all(15.0.sp),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserMessageTile(
                model: user,
              ).marginOnly(bottom: 15.h);
            },
          );
        },
      )),
    );
  }
}
