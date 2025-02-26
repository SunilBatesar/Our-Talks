import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/theme_controller.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  final Rx<Color> _themeColor = cnstSheet.colors.primary.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: PrimaryAppBar(
          title: Text(LanguageConst.theme.tr),
        ),
        body: Padding(
          padding: EdgeInsets.all(15.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CALL HEADING TEXT 2
              HeadingText2(text: LanguageConst.colorchangedupgradedfun.tr),
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
                    themeController.themeColorsList.length,
                    (index) {
                      final data = themeController.themeColorsList[index];
                      return GestureDetector(
                        onTap: () {
                          _themeColor.value = data;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.sp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: data == _themeColor.value
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
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: PrimaryButton(
              title: LanguageConst.save.tr,
              onPressed: () {
                themeController.updateTemeColor(_themeColor.value);
                Get.offAllNamed(cnstSheet.routesName.navBar);
              },
              isTransparent: true,
            ),
          ),
        ),
      ),
    );
  }
}
