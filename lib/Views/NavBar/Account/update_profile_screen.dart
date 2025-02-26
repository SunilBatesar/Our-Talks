import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/BottomSheets/image_pick_bottom_sheet.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Components/loader%20animation/loading_indicator.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/app_validators.dart';
import 'package:ourtalks/Views/Auth/widget/username_checker.dart';
import 'package:ourtalks/Views/NavBar/Account/Widgets/user_profile_pick_widget.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_datahendler.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

final _userdata = Get.find<UserController>().user;

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // USER DP
  // File
  File? imageFile;
  String userDp = '';
  // BANNER
  File? bannerFile;
  String bannerUrl = '';

  // globle key
  final _globalKey = GlobalKey<FormState>();

  // TEXT FIELD CONTROLLER

  final _nameController = TextEditingController(text: _userdata!.name);
  final _userNameController = TextEditingController(text: _userdata!.userName);
  final _aboutController = TextEditingController(text: _userdata!.about);
  final _emailController = TextEditingController(text: _userdata!.email);

  // check user name
  final RxString _checkuserNameController = ''.obs;
  final RxBool _isUserNameAvailable = false.obs;

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
          child: Form(
            key: _globalKey,
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
                  validator: TextValidator(),
                  controller: _nameController,
                  label: LanguageConst.name.tr,
                ),
                Gap(10.h),
                // USER NAME TEXT FIELD
                PrimaryTextfield(
                  validator: UserNameValidator(),
                  controller: _userNameController,
                  label: LanguageConst.userName.tr,
                  onChanged: (v) {
                    final error = UserNameValidator().validate(v);
                    if (error == null) {
                      _checkuserNameController.value = v;
                    } else {
                      _checkuserNameController.value = "";
                    }
                  },
                ),
                UsernameChecker(
                    username: _checkuserNameController.value,
                    isUserNameAvailable: _isUserNameAvailable),
                Gap(10.h),
                // USER ABOUT TEXT FIELD
                PrimaryTextfield(
                  validator: TextValidator(),
                  controller: _aboutController,
                  label: LanguageConst.about.tr,
                ),
                Gap(10.h),
                // USER EMAIL TEXT FIELD
                PrimaryTextfield(
                  suffixicon: Icons.lock,
                  controller: _emailController,
                  label: LanguageConst.email.tr,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.sp).copyWith(bottom: 0),
          // SAVE BUTTON
          child: LoadingIndicator(
              widget: PrimaryButton(
            title: LanguageConst.save.tr,
            onPressed: _isUserNameAvailable.value
                ? () {
                    if (_globalKey.currentState!.validate()) {
                      AuthDataHandler.updateUser(
                          userId: _userdata!.userID!,
                          model: _userdata!.copyWith(
                              name: _nameController.text.trim(),
                              userName: _userNameController.text.trim(),
                              about: _aboutController.text.trim()));
                    }
                  }
                : () {
                    if (_globalKey.currentState!.validate()) {}
                  },
            isTransparent: true,
          )),
        ),
      ),
    );
  }
}
