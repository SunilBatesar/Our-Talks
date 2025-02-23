import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Components/loader%20animation/loading_indicator.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/app_validators.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_datahendler.dart';

class VerifyEmailForgetPasswordScreen extends StatelessWidget {
  VerifyEmailForgetPasswordScreen({super.key});
  final _globalKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0.sp),
          child: Column(
            children: [
              Hero(
                  tag: "image_a_boy",
                  // transitionOnUserGestures: true,
                  child: Image.asset(
                    height: cnstSheet.services.screenHeight(context) * 0.3,
                    width: cnstSheet.services.screenWidth(context),
                    cnstSheet.images.boy,
                    color: cnstSheet.colors.primary,
                    fit: BoxFit.contain,
                  )),
              Gap(35.sp),
              // TEXT
              Text(
                LanguageConst.dontlazyemailrelative.tr,
                style: cnstSheet.textTheme.fs20Medium
                    .copyWith(color: cnstSheet.colors.primary),
              ),
              Gap(30.sp),
              // EMAIL TEXT FIELD
              Form(
                key: _globalKey,
                child: PrimaryTextfield(
                  validator: EmailValidator(),
                  controller: _emailController,
                  label: LanguageConst.email.tr,
                  keybordtype: TextInputType.emailAddress,
                ),
              ),
              // SIGN IN BUTTON
              Gap(60.sp),
              LoadingIndicator(
                widget: PrimaryButton(
                  title: LanguageConst.continues.tr,
                  onPressed: () {
                    if (_globalKey.currentState!.validate()) {
                      AuthDataHandler.resetPassword(
                          email: _emailController.text.trim());
                    }
                    // Get.offNamed(cnstSheet.routesName.forgetPasswordScreen);
                  },
                  isExpanded: true,
                  isTransparent: true,
                ),
              )
            ],
          ),
        ),
      )),
      bottomNavigationBar: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5.w,
        children: List.generate(
          4,
          (index) => Container(
            height: 10.sp,
            width: 10.sp,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: cnstSheet.colors.primary),
          ),
        ),
      ),
    );
  }
}
