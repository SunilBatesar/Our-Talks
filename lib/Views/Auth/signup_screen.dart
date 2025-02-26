import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Components/loader%20animation/loading_indicator.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/app_validators.dart';
import 'package:ourtalks/Views/Auth/widget/username_checker.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_datahendler.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _globalKey = GlobalKey<FormState>();
  // TEXT FIELD CONTROLLERS
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // BOOL VALUE
  final RxBool _isPasswordobscure = true.obs;
  final RxBool _iskeboardValue = false.obs;

  // check user name
  final RxString _checkuserNameController = ''.obs;
  final RxBool _isUserNameAvailable = false.obs;

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
                        transitionOnUserGestures: true,
                        child: Image.asset(
                          cnstSheet.images.boySeeGirl,
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
                      "${LanguageConst.withoutAccountEverythingquickly.tr}\n${LanguageConst.signupquickly.tr}",
                      style: cnstSheet.textTheme.fs29Medium
                          .copyWith(color: cnstSheet.colors.primary),
                    ),
                    Gap(25.sp),
                    // Name TEXT FIELD
                    PrimaryTextfield(
                      validator: TextValidator(),
                      controller: _nameController,
                      label: LanguageConst.name.tr,
                      keybordtype: TextInputType.emailAddress,
                    ),
                    Gap(15.sp),
                    // User Name TEXT FIELD
                    PrimaryTextfield(
                      validator: UserNameValidator(),
                      controller: _userNameController,
                      label: LanguageConst.userName.tr,
                      keybordtype: TextInputType.emailAddress,
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

                    Gap(15.sp),
                    // EMAIL TEXT FIELD
                    PrimaryTextfield(
                      validator: EmailValidator(),
                      controller: _emailController,
                      label: LanguageConst.email.tr,
                      keybordtype: TextInputType.emailAddress,
                    ),
                    Gap(15.sp),
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

                    Gap(30.sp),
                    // SIGN UP BUTTON

                    LoadingIndicator(
                      widget: PrimaryButton(
                        title: LanguageConst.signUp.tr,
                        onPressed: _isUserNameAvailable.value
                            ? () {
                                if (_globalKey.currentState!.validate()) {
                                  final userdata = UserModel(
                                    userName: _userNameController.text.trim(),
                                    about:
                                        "I am using our-talks app to connect and share thoughts!",
                                    name: _nameController.text.trim(),
                                    createdAt: DateTime.now().toIso8601String(),
                                    lastActive:
                                        DateTime.now().toIso8601String(),
                                    email: _emailController.text.trim(),
                                  );

                                  AuthDataHandler.signUp(
                                    user: userdata,
                                    password: _passwordController.text.trim(),
                                  );
                                }
                              }
                            : () {
                                if (_globalKey.currentState!.validate()) {}
                              },
                        isExpanded: true,
                        isTransparent: true,
                      ),
                    ),

                    Gap(55.sp),
                    // TEXT RICH
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(cnstSheet.routesName.loginScreen);
                      },
                      child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                              text: LanguageConst.signedupalreadyforgetting.tr,
                              style: cnstSheet.textTheme.fs15Normal
                                  .copyWith(color: cnstSheet.colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                    text: LanguageConst.signInEmoji.tr,
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
