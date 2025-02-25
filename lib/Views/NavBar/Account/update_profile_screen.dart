import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/BottomSheets/image_pick_bottom_sheet.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Views/NavBar/Account/Widgets/user_profile_pick_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // USER DP
  // File
  File? imageFile;
  String userDp = "";
  // BANNER
  File? bannerFile;
  String bannerUrl = "";

  // TEXT FIELD CONTROLLER

  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _userNameController.dispose();
    _aboutController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text(LanguageConst.updateProfile.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0.sp).copyWith(top: 0),
          child: Column(
            children: [
              // SET USER DP
              // CALL USER PROFILE PICK WIDGET
              UserProfilePickWidget(
                userDp: userDp,
                imageFile: imageFile,
                onTap: () async {
                  // CALL IMAGE PICK BOTTOM SHEET
                  await imagePickBottomSheetFunction(
                    (value) {
                      if (value.path.isNotEmpty) {
                        setState(() {
                          imageFile = value;
                        });
                      }
                    },
                  );
                },
              ),
              Gap(15.h),
              // SET BANNER
              // CALL USER PROFILE PICK WIDGET
              UserBannerPickWidget(
                bannerUrl: bannerUrl,
                bannerFile: bannerFile,
                onTap: () async {
                  // CALL IMAGE PICK BOTTOM SHEET
                  await imagePickBottomSheetFunction(
                    (value) {
                      if (value.path.isNotEmpty) {
                        setState(() {
                          bannerFile = value;
                        });
                      }
                    },
                  );
                },
              ),
              Gap(25.h),
              // USER NAME TEXT FIELD
              PrimaryTextfield(
                controller: _nameController,
                label: LanguageConst.name.tr,
              ),
              Gap(10.h),
              // USER NAME TEXT FIELD
              PrimaryTextfield(
                controller: _userNameController,
                label: LanguageConst.userName.tr,
              ),
              Gap(10.h),
              // USER ABOUT TEXT FIELD
              PrimaryTextfield(
                controller: _aboutController,
                label: LanguageConst.about.tr,
              ),
              Gap(10.h),
              // USER EMAIL TEXT FIELD
              PrimaryTextfield(
                controller: _emailController,
                label: LanguageConst.email.tr,
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.sp).copyWith(bottom: 0),
          // SAVE BUTTON
          child: PrimaryButton(
            title: LanguageConst.save.tr,
            onPressed: () {},
            isTransparent: true,
          ),
        ),
      ),
    );
  }
}
