import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Res/i18n/language_translations.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/language_controller.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: Text(LanguageConst.language.tr)),
      body: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Column(
          children: [
            // TEXT
            Text(
              LanguageConst.nowedontAlienlanguagePichuman.tr,
              style: cnstSheet.textTheme.fs15Normal
                  .copyWith(color: cnstSheet.colors.white),
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
                        controller
                            .setLanguage(data); // CALL UPDATE LANGUAGE FUNCTION
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
          ],
        ),
      ),
    );
  }
}
