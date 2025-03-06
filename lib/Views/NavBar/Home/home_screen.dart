import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Views/NavBar/Home/Widgets/user_message_tile.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Networks/realtime%20database/chat_respository.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/Cloud%20firestore/user_datahendler.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _data();
  }

  _data() {
    final auth = FirebaseAuth.instance;

    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          await UserDataHandler.updatesingleKey(
              userId: auth.currentUser!.uid, key: "isOnline", value: true);
        }
        if (message.toString().contains('pause')) {
          await UserDataHandler.updatesingleKey(
              userId: auth.currentUser!.uid, key: "isOnline", value: false);
        }
      }
      return Future.value(message);
    });
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
