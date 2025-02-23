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
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_datahendler.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _globalKey = GlobalKey<FormState>();

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
          child: Form(
            key: _globalKey,
            child: Column(
              children: [
                // A MAN IMAGE
                Obx(
                  () => AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.linear,
                    width: _iskeboardValue.value
                        ? 300.h
                        : cnstSheet.services.screenWidth(context),
                    height: _iskeboardValue.value
                        ? 150.h
                        : cnstSheet.services.screenHeight(context) * 0.3,
                    child: Hero(
                        tag: "image_a_boy",
                        // transitionOnUserGestures: true,
                        child: Image.asset(
                          cnstSheet.images.aBoyGirl,
                          color: cnstSheet.colors.primary,
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
                      style: cnstSheet.textTheme.fs35Medium
                          .copyWith(color: cnstSheet.colors.primary),
                    ),
                    Gap(30.sp),
                    // EMAIL TEXT FIELD
                    PrimaryTextfield(
                      validator: EmailValidator(),
                      controller: _emailController,
                      label: LanguageConst.email.tr,
                      keybordtype: TextInputType.emailAddress,
                    ),
                    Gap(18.sp),
                    // PASSWORD TEXT FIELD
                    Obx(
                      () => PrimaryTextfield(
                        validator: PasswordValidator(),
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
                    // PASSWORD FORGET TEXT RICH
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(cnstSheet
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
                    Gap(30.sp),
                    // SIGN IN BUTTON
                    LoadingIndicator(
                        widget: PrimaryButton(
                      title: LanguageConst.signIn.tr,
                      onPressed: () {
                        if (_globalKey.currentState!.validate()) {
                          AuthDataHandler.login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim());
                        }
                      },
                      isExpanded: true,
                      isTransparent: true,
                    )),
                    Gap(55.sp),
                    // TEXT RICH
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(cnstSheet.routesName.signUpScreen);
                      },
                      child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                              text: LanguageConst.heybroyoucgwaccount.tr,
                              style: cnstSheet.textTheme.fs15Normal
                                  .copyWith(color: cnstSheet.colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                    text: LanguageConst.signupquickly.tr,
                                    style:
                                        TextStyle(color: cnstSheet.colors.blue))
                              ])),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
