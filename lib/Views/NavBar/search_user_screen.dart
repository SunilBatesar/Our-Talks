import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Components/TextFields/search_textfield.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';

class SearchUserScreen extends StatelessWidget {
  SearchUserScreen({super.key});
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                child: Image.asset(
                  cnstSheet.images.talk,
                  fit: BoxFit.cover,
                  color: cnstSheet.colors.primary.withAlpha(150),
                  width: cnstSheet.services.screenWidth(context),
                )),
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Column(
                children: [
                  SearchTextField(
                    controller: _searchController,
                    iconOnTap: () {},
                  ),
                  Gap(10.h),
                  HeadingText2(
                    text: LanguageConst.bettertypeUserNotFound.tr,
                    textColor: cnstSheet.colors.white.withAlpha(150),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
