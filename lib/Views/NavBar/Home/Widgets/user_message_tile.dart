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
import 'package:ourtalks/view_model/Models/user_model.dart';

class UserMessageTile extends StatefulWidget {
  final UserModel model;
  final VoidCallback? onTap;
  final IconData? tralingicon;
  const UserMessageTile(
      {super.key, required this.model, this.onTap, this.tralingicon});

  @override
  State<UserMessageTile> createState() => _UserMessageTileState();
}

class _UserMessageTileState extends State<UserMessageTile> {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  StreamSubscription<DatabaseEvent>? _userStatusSubscription;
  RealTimeUserModel? _isOnlineData;
  @override
  void initState() {
    super.initState();
    _data();
  }

  _data() async {
    final userData = _firebaseDatabase.ref("user_data");
    _userStatusSubscription =
        userData.child(widget.model.userID!).onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
          final response =
              AppFunctions.convertFirebaseData(event.snapshot.value);
          setState(() {
            _isOnlineData = RealTimeUserModel.fromJson(response);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _userStatusSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap ??
          () {
            Get.to(() => ChatScreen(usermodel: widget.model));
          },
      contentPadding: EdgeInsets.all(0),
      leading: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000.sp),
              child: GestureDetector(
                onTap: () => Get.to(
                    UserProfileImageShowScreen(image: widget.model.userDP)),
                child: CachedNetworkImage(
                  scale: 1,
                  imageUrl: widget.model.userDP!.isNotEmpty
                      ? widget.model.userDP!
                      : AppConfig.defaultDP,
                  height: 50.sp,
                  width: 50.sp,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                        height: 12.sp,
                        width: 12.sp,
                        child: CircularProgressIndicator(
                          color: cnstSheet.colors.white,
                          strokeWidth: 3,
                        )),
                  ),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            _isOnlineData != null && _isOnlineData!.isOnline == true
                ? Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  )
                : SizedBox()
          ]),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.model.name,
            style: cnstSheet.textTheme.fs20Medium
                .copyWith(color: cnstSheet.colors.white),
          ),
          Text(
            widget.model.userName,
            style: cnstSheet.textTheme.fs14Normal
                .copyWith(color: cnstSheet.colors.white.withAlpha(150)),
          ),
        ],
      ),
      trailing: widget.tralingicon != null
          ? IconButton(
              onPressed: () =>
                  Get.to(() => ChatScreen(usermodel: widget.model)),
              icon: Icon(
                widget.tralingicon,
                color: cnstSheet.colors.white,
              ))
          : Container(
              padding: EdgeInsets.all(3.sp),
              decoration: BoxDecoration(
                  border: Border.all(color: cnstSheet.colors.primary),
                  shape: BoxShape.circle),
              child: Text(
                "5",
                style: cnstSheet.textTheme.fs12Normal
                    .copyWith(color: cnstSheet.colors.white),
              ),
            ),
    );
  }
}
