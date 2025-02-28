import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
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
              child: Column(
                children: [
                  // TEXT
                  HeadingText2(
                      text: LanguageConst
                          .theoptionchangepasswordsetting1234not.tr),
                  Gap(30.sp),
                  // Current password TEXT FIELD
                  PrimaryTextfield(
                    controller: _currentpasswordController,
                    label: LanguageConst.currentpassword.tr,
                    keybordtype: TextInputType.visiblePassword,
                    isobscureText: true,
                  ),
                  Gap(15.sp),
                  // Current password TEXT FIELD
                  PrimaryTextfield(
                    controller: _passwordController,
                    label: LanguageConst.newPassword.tr,
                    keybordtype: TextInputType.visiblePassword,
                    isobscureText: true,
                  ),
                  Gap(15.sp),
                  PrimaryTextfield(
                    controller: _confirmpasswordController,
                    label: LanguageConst.confirmNewPassword.tr,
                    keybordtype: TextInputType.visiblePassword,
                  ),
                  Gap(40.sp),
                ],
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // SAVE BUTTON
          child: PrimaryButton(
            title: LanguageConst.save.tr,
            onPressed: () {
              Get.offNamed(cnstSheet.routesName.loginScreen);
            },
            isExpanded: true,
            isTransparent: true,
          ),
        ),
      ),
    );
  }
}
