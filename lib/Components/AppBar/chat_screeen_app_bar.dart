import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Res/Services/date_time_pars.dart';
import 'package:ourtalks/Views/NavBar/Home/profile_view_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/friend_model.dart';

AppBar chatScreenAppBar(
    {required FriendModel model, required BuildContext context}) {
  String time = "";
  if (model.isOnlineData != null && model.isOnlineData!.lastSeen!.isNotEmpty) {
    final value = model.isOnlineData!.lastSeen ?? "";
    time = DatetimePars.getLastActiveTime(context, value);
  }
  return AppBar(
    leadingWidth: 30.w,
    leading: IconButton(
      onPressed: Get.back,
      icon: Icon(
        Icons.arrow_back_rounded,
        size: 24.sp,
        color: cnstSheet.colors.primary,
      ),
    ),
    title: GestureDetector(
      onTap: () => Get.to(() => ProfileViewScreen(model: model.user)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(1000.sp),
            child: CachedNetworkImage(
              scale: 1,
              imageUrl: model.user.userDP!.isNotEmpty
                  ? model.user.userDP!
                  : AppConfig.defaultDP,
              height: 35.sp,
              width: 35.sp,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  height: 12.sp,
                  width: 12.sp,
                  child: CircularProgressIndicator(
                    color: cnstSheet.colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Gap(10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.user.name,
                style: cnstSheet.textTheme.fs18Medium
                    .copyWith(color: cnstSheet.colors.white),
              ),
              Gap(5.h),
              Text(
                model.isOnlineData != null
                    ? model.isOnlineData!.isOnline
                        ? "Online"
                        : time
                    : model.user.userName,
                style: cnstSheet.textTheme.fs12Normal
                    .copyWith(color: cnstSheet.colors.primary.withAlpha(180)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
