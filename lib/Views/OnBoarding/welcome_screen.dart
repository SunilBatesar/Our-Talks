import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Res/i18n/language_translations.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/language_controller.dart';
import 'package:ourtalks/view_model/Controllers/theme_controller.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(15.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CALL HEADING TEXT 2
                    HeadingText2(
                        text: LanguageConst.nowedontAlienlanguagePichuman.tr),
                    Gap(20.h),
                    // LANGUAGE CHANGE AND RADIO LIST TILE CALL
                    GetBuilder<LanguageController>(
                      builder: (controller) {
                        return ListView.builder(
                          itemCount: LanguageTranslations.languageList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data =
                                LanguageTranslations.languageList[index];
                            return RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              value: controller.languagedata.countryCode,
                              groupValue: data.countryCode,
                              onChanged: (value) {
                                controller.setLanguage(
                                    data); // CALL UPDATE LANGUAGE FUNCTION
                              },
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => cnstSheet.colors.primary),
                              title: Text(
                                data.languageName,
                                style: cnstSheet.textTheme.fs18Medium
                                    .copyWith(color: cnstSheet.colors.white),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Gap(20.h),
                    // CALL HEADING TEXT 2
                    HeadingText2(
                        text: LanguageConst.colorchangedupgradedfun.tr),
                    Gap(10.h),
                    // THEME COLORS LIST AND UPDATE
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 15.w,
                        runSpacing: 10.h,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(
                          themeController.themeColorsList.length < 5
                              ? themeController.themeColorsList.length
                              : 5,
                          (index) {
                            final data = themeController.themeColorsList[index];
                            return GestureDetector(
                              onTap: () {
                                themeController.updateTemeColor(data);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.sp),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: data ==
                                          themeController.selectThemeColor.value
                                      ? Border.all(color: data)
                                      : null,
                                ),
                                child: Container(
                                  width: 40.sp,
                                  height: 40.sp,
                                  decoration: BoxDecoration(
                                      color: data, shape: BoxShape.circle),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // IMAGE A BOY AND GIRL

              Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                        tag: "image_a_boy",
                        transitionOnUserGestures: true,
                        child: Image.asset(
                          height:
                              cnstSheet.services.screenHeight(context) * 0.25,
                          width: cnstSheet.services.screenWidth(context),
                          cnstSheet.images.readBoyGirl,
                          color: cnstSheet.colors.primary,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Row(
                    children: [
                      // SIGN IN BUTTON
                      Expanded(
                        child: PrimaryButton(
                          title: LanguageConst.signIn.tr,
                          onPressed: () {
                            Get.toNamed(cnstSheet.routesName.loginScreen);
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
                            Get.toNamed(cnstSheet.routesName.signUpScreen);
                          },
                          isExpanded: true,
                          isTransparent: true,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
