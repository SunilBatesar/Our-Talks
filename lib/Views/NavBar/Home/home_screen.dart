import 'dart:async';

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
import 'package:ourtalks/view_model/Controllers/friend_controller.dart';
import 'package:ourtalks/view_model/Data/Networks/realtime%20database/chat_respository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  static final _userData = _firebaseDatabase.ref("user_data");
  final friendController = Get.put(FriendController());
  @override
  void initState() {
    super.initState();
    _handleUserOnlineStatus();
  }

  // Handle user online/offline status
  void _handleUserOnlineStatus() async {
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (auth.currentUser != null) {
        final db = _userData.child(auth.currentUser!.uid);
        final time = DateTime.now().microsecondsSinceEpoch.toString();
        if (message.toString().contains('resume')) {
          await ChatRespository.userOnlineValueUpdate(
              userId: Prefs.getUserIdPref(), value: true);
          await db.onDisconnect().update({
            'isOnline': false,
            'lastSeen': time,
          });
        }
        if (message.toString().contains('pause')) {
          await ChatRespository.userOnlineValueUpdate(
              userId: Prefs.getUserIdPref(), value: false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConfig.appName,
          style: cnstSheet.textTheme.appNameStyle15
              .copyWith(color: cnstSheet.colors.primary),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () {
            final data = friendController.sortedUsers;
            if (friendController.isUpdateUsersStatus.value && data.isNotEmpty) {
              friendController.getUserStatus();
              friendController.updateisUpdateUsersStatus(false);
            }
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0.sp),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return UserMessageTile(
                  model: user,
                ).marginOnly(bottom: 15.h);
              },
            );
          },
        ),
      ),
    );
  }
}
