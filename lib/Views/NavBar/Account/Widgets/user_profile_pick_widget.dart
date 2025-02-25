import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/Container/primary_container.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Views/NavBar/Account/user_profile_image_show_screen.dart';
import 'package:ourtalks/main.dart';

class UserProfilePickWidget extends StatefulWidget {
  final String userDp;
  final File? imageFile;
  final Function onTap;
  const UserProfilePickWidget(
      {super.key,
      required this.userDp,
      required this.imageFile,
      required this.onTap});

  @override
  State<UserProfilePickWidget> createState() => _UserProfilePickWidgetState();
}

class _UserProfilePickWidgetState extends State<UserProfilePickWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      GestureDetector(
        onTap: () {
          if (widget.imageFile != null || widget.userDp.isNotEmpty) {
            Get.to(() => UserProfileImageShowScreen(
                  image: widget.imageFile ?? widget.userDp,
                ));
          }
        },
        child: PrimaryContainer(
          height: 100.sp,
          width: 100.sp,
          boxShape: BoxShape.circle,
          padding: EdgeInsets.all(5.sp),
          child: ClipOval(
            child: _buildProfileImage(), // CALL BUILD PROFILE IMAGE FUNCTION
          ),
        ),
      ),
      Positioned(
        bottom: 5,
        right: 5,
        child: GestureDetector(
          onTap: () async {
            widget.onTap();
          },
          child: Container(
            padding: EdgeInsets.all(3.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cnstSheet.colors.white.withAlpha(130),
            ),
            child: Icon(
              Icons.edit,
              size: 24.sp,
              color: cnstSheet.colors.black,
            ),
          ),
        ),
      )
    ]);
  }

  // Function to handle image display logic
  Widget _buildProfileImage() {
    if (widget.imageFile != null) {
      return Image.file(
        height: 100.sp,
        width: 100.sp,
        widget.imageFile!,
        fit: BoxFit.cover,
      );
    } else if (widget.userDp.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSCl66MbhXC8vY3H5WCmunsEFcUj6HcpNjgA&s",
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
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      );
    } else {
      return Image.asset(
        height: 100.sp,
        width: 100.sp,
        cnstSheet.images.boy,
        fit: BoxFit.cover,
      );
    }
  }
}

// SHOW AND ADD NEW BANNER WIDGET
class UserBannerPickWidget extends StatefulWidget {
  final String bannerUrl;
  final File? bannerFile;
  final Function onTap;
  const UserBannerPickWidget(
      {super.key,
      required this.bannerUrl,
      required this.bannerFile,
      required this.onTap});

  @override
  State<UserBannerPickWidget> createState() => _UserBannerPickWidgetState();
}

class _UserBannerPickWidgetState extends State<UserBannerPickWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: PrimaryContainer(
        height: 150.sp,
        padding: EdgeInsets.all(5.sp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _buildBannerImage(), // CALL BUILD BANNER IMAGE FUNCTION
        ),
      ),
    );
  }

  // Function to handle image display logic
  Widget _buildBannerImage() {
    if (widget.bannerFile != null) {
      return Image.file(
        height: 150.sp,
        width: cnstSheet.services.screenWidth(context),
        widget.bannerFile!,
        fit: BoxFit.cover,
      );
    } else if (widget.bannerUrl.isNotEmpty) {
      return CachedNetworkImage(
        height: 150.sp,
        width: cnstSheet.services.screenWidth(context),
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSCl66MbhXC8vY3H5WCmunsEFcUj6HcpNjgA&s",
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
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 50.sp,
            color: cnstSheet.colors.primary.withAlpha(150),
          ),
          Text(
            LanguageConst.banner.tr,
            style: cnstSheet.textTheme.fs18Bold
                .copyWith(color: cnstSheet.colors.white.withAlpha(150)),
          )
        ],
      );
    }
  }
}
