import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Views/NavBar/Account/Widgets/menu_tile.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Data/LocalData/local_data.dart';
import 'package:ourtalks/view_model/Models/account_menu_model.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text(LanguageConst.helpSupport.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Column(
          children: [
            HeadingText2(text: LanguageConst.ourhelpline24x7sleepnight.tr),
            Gap(10.h),
            ...List.generate(
              LocalData.helpAndSupportDataList.length,
              (index) {
                final data = LocalData.helpAndSupportDataList[index];
                return MenuTile(
                  model: data,
                  onTap: () async {
                    await tileTapFunction(data);
                  },
                ).marginOnly(bottom: 10.h);
              },
            ),
            Gap(50.h),
            TextButton(
                onPressed: () {
                  Get.toNamed(cnstSheet.routesName.deleteAccountScreen);
                },
                child: Text(
                  LanguageConst.deleteAccount.tr,
                  style: cnstSheet.textTheme.fs15Normal
                      .copyWith(color: cnstSheet.colors.red),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> tileTapFunction(AccountMenuModel model) async {
    switch (model.id) {
      case LanguageConst.whatsApp:
        await AppFunctions.userOpenWhatsApp(); // USER OPEN WHATSAPP
      case LanguageConst.feedback:
        await AppFunctions.sendFeedBackToEmail(); // USER SEND FEEDBACK TO EMAIL

      default:
        null;
    }
  }
}
