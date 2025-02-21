import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final RxBool _isPasswordobscure = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantSheet.colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // A MAN IMAGE
              Image.asset(
                width: constantSheet.services.screenWidth(context),
                height: constantSheet.services.screenHeight(context) * 0.3,
                constantSheet.images.aBoyGirl,
                color: constantSheet.colors.primary,
                fit: BoxFit.cover,
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
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
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
                  Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                          text: LanguageConst.heybroyoucgwaccount.tr,
                          style: constantSheet.textTheme.fs15Normal
                              .copyWith(color: constantSheet.colors.white),
                          children: <TextSpan>[
                            TextSpan(
                                text: LanguageConst.signupquickly.tr,
                                style:
                                    TextStyle(color: constantSheet.colors.blue))
                          ]))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
