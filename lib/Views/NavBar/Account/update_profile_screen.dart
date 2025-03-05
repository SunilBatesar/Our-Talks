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
import 'package:ourtalks/view_model/Data/Functions/app_buttonhit_function.dart';
import 'package:ourtalks/view_model/Data/Networks/cloudinary/cloudinary_function.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/Cloud%20firestore/user_datahendler.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _userdata = Get.find<UserController>().user!;
  // USER DP
  File? imageFile;
  late String userDp;
  // BANNER
  File? bannerFile;
  late String bannerUrl;

  // GLOBAL KEY
  final _globalKey = GlobalKey<FormState>();

  // TEXT FIELD CONTROLLER
  late TextEditingController _nameController;
  late TextEditingController _userNameController;
  late TextEditingController _aboutController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    userDp = _userdata.userDP ?? '';
    bannerUrl = _userdata.banner ?? '';

    _nameController = TextEditingController(text: _userdata.name);
    _userNameController = TextEditingController(text: _userdata.userName);
    _aboutController = TextEditingController(text: _userdata.about);
    _emailController = TextEditingController(text: _userdata.email);
    _checkuserNameController.value = _userdata.userName;
    _isUserNameAvailable.value = true;
  }

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
                      file: (value) {
                        if (value.path.isNotEmpty) {
                          setState(() {
                            imageFile = value;
                          });
                        }
                      },
                      // DELETE USER DP FUNCTION
                      deleteBtnOnTap: () async {
                        await UserDataHandler.updatesingleKey(
                                userId: _userdata.userID ?? "",
                                key: "userDP",
                                value: "",
                                successMessage: "Delete user dp")
                            .then(
                          (value) {
                            setState(() {
                              _userdata.userDP = "";
                              userDp = "";
                            });
                          },
                        );
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
                    await imagePickBottomSheetFunction(file: (value) {
                      if (value.path.isNotEmpty) {
                        setState(() {
                          bannerFile = value;
                        });
                      }
                    },
                        // DELETE USER DP FUNCTION
                        deleteBtnOnTap: () async {
                      String publicId =
                          AppButtonhitFunction.extractPublicIdFromUrl(
                                  bannerUrl) ??
                              "";
                      bool iscloudDelete = await CloudinaryFunctions()
                          .deleteImageFromCloudinary(publicId);
                      if (iscloudDelete) {
                        await UserDataHandler.updatesingleKey(
                                userId: _userdata.userID ?? "",
                                key: "banner",
                                value: "",
                                successMessage: "Delete banner")
                            .then(
                          (value) {
                            setState(() {
                              _userdata.banner = "";
                              bannerUrl = "";
                            });
                          },
                        );
                      }
                    });
                  },
                ),
                Gap(25.h),
                // USER NAME TEXT FIELD
                PrimaryTextfield(
                  validator: TextValidator(),
                  controller: _nameController,
                  label: LanguageConst.name.tr,
                ),
                Gap(20.h),
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

                Obx(
                  () => UsernameChecker(
                    originalUsername: _userdata.userName,
                    username: _checkuserNameController.value,
                    isUserNameAvailable: _isUserNameAvailable,
                  ),
                ),
                Gap(20.h),
                // USER ABOUT TEXT FIELD
                PrimaryTextfield(
                  validator: TextValidator(),
                  controller: _aboutController,
                  label: LanguageConst.about.tr,
                ),
                Gap(20.h),
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
            onPressed: _isUserNameAvailable.value ||
                    _userNameController.text.trim() == _userdata.userName
                ? () => AppButtonhitFunction.updateProfile(
                      formKey: _globalKey,
                      imageFile: imageFile,
                      bannerImageFile: bannerFile,
                      userData: _userdata,
                      nameController: _nameController,
                      userNameController: _userNameController,
                      aboutController: _aboutController,
                    )
                : () {},
            isTransparent: true,
          )),
        ),
      ),
    );
  }
}
