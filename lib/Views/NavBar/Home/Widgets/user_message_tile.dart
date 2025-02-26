import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Views/NavBar/Home/Chats/chat_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class UserMessageTile extends StatelessWidget {
  final UserModel model;
  const UserMessageTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => ChatScreen(model: model));
      },
      contentPadding: EdgeInsets.all(0),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(1000.sp),
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
      trailing: Container(
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
