import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/BottomSheets/image_pick_bottom_sheet.dart';
import 'package:ourtalks/Components/Container/primary_container.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Views/NavBar/Account/user_profile_image_show_screen.dart';
import 'package:ourtalks/main.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});
  // File
  File? imageFile;
  String userDp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text(LanguageConst.updateProfile.tr),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Stack(clipBehavior: Clip.none, children: [
              GestureDetector(
                onTap: () {
                  if (imageFile != null || userDp.isNotEmpty) {
                    Get.to(() => UserProfileImageShowScreen());
                  }
                },
                child: PrimaryContainer(
                  height: 100.sp,
                  width: 100.sp,
                  boxShape: BoxShape.circle,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: imageFile == null
                        ? (userDp.isNotEmpty
                            ? CachedNetworkImage(
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
                                errorWidget: (context, url, error) =>
                                    Center(child: Icon(Icons.error)),
                              )
                            : Image.asset(
                                cnstSheet.images.boy,
                                fit: BoxFit.cover,
                              ))
                        : Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: -3,
                child: GestureDetector(
                  onTap: () async {
                    await Get.bottomSheet(ImagePickBottomSheet(
                      file: (file) {
                        if (file.path.isNotEmpty) {}
                      },
                    ));
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
            ]),
          ),
        ],
      ),
    );
  }
}
