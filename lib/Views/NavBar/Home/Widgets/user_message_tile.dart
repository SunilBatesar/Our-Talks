import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Views/NavBar/Account/user_profile_image_show_screen.dart';
import 'package:ourtalks/Views/NavBar/Home/Chats/chat_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Data/Networks/realtime%20database/chat_respository.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class UserMessageTile extends StatefulWidget {
  final UserModel model;
  final VoidCallback? onTap;
  final IconData? trailingIcon;

  const UserMessageTile({
    super.key,
    required this.model,
    this.onTap,
    this.trailingIcon,
  });

  @override
  State<UserMessageTile> createState() => _UserMessageTileState();
}

class _UserMessageTileState extends State<UserMessageTile> {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  StreamSubscription<DatabaseEvent>? _userStatusSubscription;
  StreamSubscription<DatabaseEvent>? _lastMsgSubscription;
  RealTimeUserModel? _isOnlineData;
  String? lastMessage;
  int? lastMessageTime;
  // int unreadCount = 0; // Track unread messages
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _getUserStatus();
    _listenToLastMsg();
  }

  /// Listen to user online/offline status
  _getUserStatus() {
    final userData = _firebaseDatabase.ref("user_data");
    _userStatusSubscription =
        userData.child(widget.model.userID!).onValue.listen((event) {
      if (_isDisposed || !mounted) return;
      if (event.snapshot.value != null) {
        final response = AppFunctions.convertFirebaseData(event.snapshot.value);
        setState(() {
          _isOnlineData = RealTimeUserModel.fromJson(response);
        });
      }
    });
  }

  /// Listen to the last message in the chat
  _listenToLastMsg() {
    _lastMsgSubscription =
        ChatRespository.getLastMsg(widget.model.userID!).listen((event) {
      if (_isDisposed || !mounted) return;
      if (event.snapshot.value != null) {
        final response = AppFunctions.convertFirebaseData(event.snapshot.value);
        final lastMsgData = response.values.first;

        setState(() {
          lastMessage = lastMsgData['text'] ?? 'Media message';
          lastMessageTime = lastMsgData['createdAt'];
          // unreadCount = lastMsgData['unreadCount'] ?? 0; // Fetch unread count
        });
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _userStatusSubscription?.cancel();
    _lastMsgSubscription?.cancel();
    super.dispose();
  }

  String _formatTime(int? timestamp) {
    if (timestamp == null) return "10/02/2003"; // Default date if no message
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap ??
          () {
            Get.to(() => ChatScreen(usermodel: widget.model));
          },
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          GestureDetector(
            onTap: () =>
                Get.to(UserProfileImageShowScreen(image: widget.model.userDP)),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget.model.userDP!.isNotEmpty
                    ? widget.model.userDP!
                    : AppConfig.defaultDP,
              ),
              radius: 25.sp,
            ),
          ),
          if (_isOnlineData?.isOnline == true)
            const CircleAvatar(
              backgroundColor: Colors.green,
              radius: 5,
            ),
        ],
      ),
      title: Text(
        widget.model.name,
        style: cnstSheet.textTheme.fs20Medium
            .copyWith(color: cnstSheet.colors.white),
      ),
      subtitle: Text(
        lastMessage ?? 'No messages yet',
        style: cnstSheet.textTheme.fs14Normal
            .copyWith(color: cnstSheet.colors.white.withAlpha(150)),
      ),
      trailing: widget.trailingIcon != null
          ? IconButton(
              onPressed: () =>
                  Get.to(() => ChatScreen(usermodel: widget.model)),
              icon: Icon(
                widget.trailingIcon,
                color: cnstSheet.colors.white,
              ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // if (unreadCount > 0)
                //   Container(
                //     padding: EdgeInsets.all(3.sp),
                //     decoration: BoxDecoration(
                //         border: Border.all(color: cnstSheet.colors.primary),
                //         shape: BoxShape.circle),
                //     child: Text(
                //       unreadCount.toString(), // Show actual unread count
                //       style: cnstSheet.textTheme.fs12Normal
                //           .copyWith(color: cnstSheet.colors.white),
                //     ),
                //   ),
                Text(
                  _formatTime(lastMessageTime),
                  style: cnstSheet.textTheme.fs12Normal
                      .copyWith(color: cnstSheet.colors.white),
                ),
              ],
            ),
    );
  }
}
