import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Controllers/language_controller.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Res/i18n/language_translations.dart';
import 'package:ourtalks/main.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Column(
                children: [
                  // TEXT
                  Text(
                    LanguageConst.nowedontAlienlanguagePichuman.tr,
                    style: constantSheet.textTheme.fs15Normal
                        .copyWith(color: constantSheet.colors.primary),
                  ),
                  Gap(20.h),
                  // LANGUAGE CHANGE AND RADIO LIST TILE CALL
                  GetBuilder<LanguageController>(
                    builder: (controller) {
                      return ListView.builder(
                        itemCount: LanguageTranslations.languageList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = LanguageTranslations.languageList[index];
                          return RadioListTile(
                            contentPadding: EdgeInsets.all(0),
                            value: controller.languagedata.countryCode,
                            groupValue: data.countryCode,
                            onChanged: (value) {
                              controller.setLanguage(
                                  data); // CALL UPDATE LANGUAGE FUNCTION
                            },
                            fillColor: WidgetStateColor.resolveWith(
                                (states) => constantSheet.colors.primary),
                            title: Text(
                              data.languageName,
                              style: constantSheet.textTheme.fs18Medium
                                  .copyWith(
                                      color: constantSheet.colors.primary),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Gap(10.h),
                ],
              ),
            ),
            // IMAGE A BOY AND GIRL

            Align(
              alignment: Alignment.center,
              child: Hero(
                  tag: "image_a_boy",
                  transitionOnUserGestures: true,
                  child: Image.asset(
                    height: constantSheet.services.screenHeight(context) * 0.25,
                    width: constantSheet.services.screenWidth(context),
                    constantSheet.images.readBoyGirl,
                    color: constantSheet.colors.primary,
                    fit: BoxFit.cover,
                  )),
            )
          ],
        ),
      ),
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h, left: 15.w, right: 15.w),
        child: Row(
          children: [
            // SIGN IN BUTTON
            Expanded(
              child: PrimaryButton(
                title: LanguageConst.signIn.tr,
                onPressed: () {
                  Get.toNamed(constantSheet.routesName.loginScreen);
                },
                isExpanded: true,
                isTransparent: true,
              ),
            ),
            Gap(10.w),
            // SIGN UP BUTTON
            Expanded(
              child: PrimaryButton(
                title: LanguageConst.signUp.tr,
                onPressed: () {
                  Get.toNamed(constantSheet.routesName.signUpScreen);
                },
                isExpanded: true,
                isTransparent: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
