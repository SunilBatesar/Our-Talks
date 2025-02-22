import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final RxBool _isPasswordobscure = true.obs;
  final RxBool _iskeboardValue = false.obs;

  @override
  Widget build(BuildContext context) {
    _iskeboardValue.value = AppFunctions.isKeyboardOpen(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // A MAN IMAGE
              Obx(
                () => AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.linear,
                  width: _iskeboardValue.value
                      ? 300.h
                      : constantSheet.services.screenWidth(context),
                  height: _iskeboardValue.value
                      ? 150.h
                      : constantSheet.services.screenHeight(context) * 0.3,
                  child: Hero(
                      tag: "image_a_boy",
                      // transitionOnUserGestures: true,
                      child: Image.asset(
                        constantSheet.images.aBoyGirl,
                        color: constantSheet.colors.primary,
                        fit: _iskeboardValue.value
                            ? BoxFit.contain
                            : BoxFit.cover,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0.sp),
                child: Column(children: [
                  // TEXT
                  Text(
                    LanguageConst.heytRdi.tr,
                    style: constantSheet.textTheme.fs35Medium
                        .copyWith(color: constantSheet.colors.primary),
                  ),
                  Gap(30.sp),
                  // EMAIL TEXT FIELD
                  PrimaryTextfield(
                    controller: _emailController,
                    label: LanguageConst.email.tr,
                    keybordtype: TextInputType.emailAddress,
                  ),
                  Gap(18.sp),
                  // PASSWORD TEXT FIELD
                  Obx(
                    () => PrimaryTextfield( 
                      controller: _passwordController,
                      label: LanguageConst.password.tr,
                      keybordtype: TextInputType.visiblePassword,
                      isobscureText: _isPasswordobscure.value,
                      suffixicon: _isPasswordobscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      suffixiconOnTap: () {
                        _isPasswordobscure.value = !_isPasswordobscure.value;
                      },
                    ),
                  ),
                  Gap(15.sp),
                  // TEXT RICH
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                            text: LanguageConst.didyourpasswordleavelikeEx.tr,
                            style: constantSheet.textTheme.fs15Normal
                                .copyWith(color: constantSheet.colors.white),
                            children: <TextSpan>[
                              TextSpan(
                                  text: LanguageConst.resetit.tr,
                                  style: TextStyle(
                                      color: constantSheet.colors.blue))
                            ])),
                  ),
                  Gap(30.sp),
                  // SIGN IN BUTTON
                  PrimaryButton(
                    title: LanguageConst.signIn.tr,
                    onPressed: () {},
                    isExpanded: true,
                    isTransparent: true,
                  ),
                  Gap(55.sp),
                  // TEXT RICH
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(constantSheet.routesName.signUpScreen);
                    },
                    child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                            text: LanguageConst.heybroyoucgwaccount.tr,
                            style: constantSheet.textTheme.fs15Normal
                                .copyWith(color: constantSheet.colors.white),
                            children: <TextSpan>[
                              TextSpan(
                                  text: LanguageConst.signupquickly.tr,
                                  style: TextStyle(
                                      color: constantSheet.colors.blue))
                            ])),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
