import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Buttons/primary_button.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Components/TextFields/primary_textfield.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/app_validators.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/main.dart';

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});
  final _passwordController = TextEditingController();
  final RxBool _isPasswordobscure = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text(
          LanguageConst.deleteAccount.tr,
          style: cnstSheet.textTheme.fs18Medium
              .copyWith(color: cnstSheet.colors.red),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0.sp).copyWith(bottom: 0),
            child: Column(
              children: [
                // TEXT
                HeadingText2(
                    text: LanguageConst.deleteAccountContentLines.tr,
                    style: cnstSheet.textTheme.fs15Normal
                        .copyWith(color: cnstSheet.colors.red)),
                Gap(30.h),
                // PASSWORD TEXT FIELD
                Obx(
                  () => PrimaryTextfield(
                    validator: PasswordValidator(),
                    controller: _passwordController,
                    label: LanguageConst.pleaseEnterPassword.tr,
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
              ],
            ),
          ),
          // IMAGE
          Expanded(
            child: Center(
              child: Image.asset(
                cnstSheet.images.hands,
                fit: BoxFit.cover,
                color: cnstSheet.colors.primary,
                width: cnstSheet.services.screenWidth(context),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.sp).copyWith(bottom: 0),
          // DELETE ACCOUNT BUTTON
          child: PrimaryButton(
            title: LanguageConst.deleteAccount.tr,
            onPressed: () {
              // DELETE ACCOUNT DIALOG
              AppUtils.showPermissionDialog(
                  title: LanguageConst.deleteAccount.tr,
                  content: LanguageConst.deleteAccountContentLines.tr,
                  submitButnText: LanguageConst.deleteAccount.tr,
                  submitButnTextColorRed: true,
                  onTap: () {});
            },
            isTransparent: true,
          ),
        ),
      ),
    );
  }
}
