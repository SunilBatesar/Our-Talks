import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Views/NavBar/Account/user_profile_image_show_screen.dart';
import 'package:ourtalks/Views/NavBar/Home/Chats/chat_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class UserMessageTile extends StatelessWidget {
  final UserModel model;
  final VoidCallback? onTap;
  final IconData? tralingicon;
  const UserMessageTile(
      {super.key, required this.model, this.onTap, this.tralingicon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap ??
          () {
            Get.to(() => ChatScreen(usermodel: model));
          },
      contentPadding: EdgeInsets.all(0),
      leading: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000.sp),
              child: GestureDetector(
                onTap: () =>
                    Get.to(UserProfileImageShowScreen(image: model.userDP)),
                child: CachedNetworkImage(
                  imageUrl: model.userDP!,
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
            model.isOnline
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
            model.name,
            style: cnstSheet.textTheme.fs20Medium
                .copyWith(color: cnstSheet.colors.white),
          ),
          Text(
            model.userName,
            style: cnstSheet.textTheme.fs14Normal
                .copyWith(color: cnstSheet.colors.white.withAlpha(150)),
          ),
        ],
      ),
      trailing: tralingicon != null
          ? IconButton(
              onPressed: () => Get.to(() => ChatScreen(usermodel: model)),
              icon: Icon(
                tralingicon,
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
