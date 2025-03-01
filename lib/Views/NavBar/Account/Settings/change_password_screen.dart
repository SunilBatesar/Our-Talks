import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Components/loader%20animation/loading_indicator.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/app_validators.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/auth/auth_datahendler.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final _globalKey = GlobalKey<FormState>();
  final _currentpasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text(LanguageConst.changepassword.tr),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    // TEXT
                    HeadingText2(
                        text: LanguageConst
                            .theoptionchangepasswordsetting1234not.tr),
                    Gap(30.sp),
                    // Current password TEXT FIELD
                    PrimaryTextfield(
                      validator: PasswordValidator(),
                      controller: _currentpasswordController,
                      label: LanguageConst.currentpassword.tr,
                      keybordtype: TextInputType.visiblePassword,
                      isobscureText: true,
                    ),
                    Gap(15.sp),
                    // Current password TEXT FIELD
                    PrimaryTextfield(
                      validator: PasswordValidator(),
                      controller: _passwordController,
                      label: LanguageConst.newPassword.tr,
                      keybordtype: TextInputType.visiblePassword,
                      isobscureText: true,
                    ),
                    Gap(15.sp),
                    PrimaryTextfield(
                      validator:
                          ConfirmPasswordValidator(_passwordController.text),
                      controller: _confirmpasswordController,
                      label: LanguageConst.confirmNewPassword.tr,
                      keybordtype: TextInputType.visiblePassword,
                      isobscureText: true,
                    ),
                    Gap(15.sp),
                    // PASSWORD FORGET TEXT RICH
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(cnstSheet
                            .routesName.verifyEmailForgetPasswordScreen);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                                text:
                                    LanguageConst.didyourpasswordleavelikeEx.tr,
                                style: cnstSheet.textTheme.fs15Normal
                                    .copyWith(color: cnstSheet.colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: LanguageConst.resetit.tr,
                                      style: TextStyle(
                                          color: cnstSheet.colors.blue))
                                ])),
                      ),
                    ),
                    Gap(40.sp),
                  ],
                ),
              ),
            ),
            // HANDS IMAGE
            Center(
              child: Image.asset(
                cnstSheet.images.heartHand,
                fit: BoxFit.cover,
                color: cnstSheet.colors.primary,
                width: cnstSheet.services.screenWidth(context),
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: LoadingIndicator(
          widget: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // SAVE BUTTON
          child: PrimaryButton(
            title: LanguageConst.save.tr,
            onPressed: () {
              if (_globalKey.currentState!.validate()) {
                AuthDataHandler.changeUserPassword(
                    _currentpasswordController.text.trim(),
                    _confirmpasswordController.text.trim());
                _currentpasswordController.clear();
                _passwordController.clear();
                _confirmpasswordController.clear();
              }
            },
            isExpanded: true,
            isTransparent: true,
          ),
        ),
      )),
    );
  }
}
