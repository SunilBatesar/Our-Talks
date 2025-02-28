import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Views/NavBar/Account/Widgets/menu_tile.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/LocalData/local_data.dart';
import 'package:ourtalks/view_model/Models/account_menu_model.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text(LanguageConst.settings.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Column(
          children: [
            HeadingText2(
                text: LanguageConst
                    .noteChangingsettingslifedefinitelychangeapp.tr),
            Gap(10.h),
            ...List.generate(
              LocalData.settingsDataList.length,
              (index) {
                final data = LocalData.settingsDataList[index];
                return MenuTile(
                  model: data,
                  onTap: () async {
                    await tileTapFunction(data);
                  },
                ).marginOnly(bottom: 10.h);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> tileTapFunction(AccountMenuModel model) async {
    switch (model.id) {
      case LanguageConst.theme:
        Get.toNamed(cnstSheet.routesName.themeScreen); // THEME SCREEN
      case LanguageConst.language:
        Get.toNamed(cnstSheet.routesName.languageScreen); // LANGUAGE SCREEN
      case LanguageConst.changepassword:
        Get.toNamed(cnstSheet
            .routesName.changePasswordScreen); // CHANGE PASSWORD SCREEN
      default:
        null;
    }
  }
}
