import 'package:flutter/material.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/view_model/Models/account_menu_model.dart';

class LocalData {
  static List<AccountMenuModel> accountMenuDataList = [
    AccountMenuModel(
        id: LanguageConst.updateProfile,
        title: LanguageConst.updateProfile,
        icon: Icons.person_2_outlined),
    AccountMenuModel(
        id: LanguageConst.theme,
        title: LanguageConst.theme,
        icon: Icons.color_lens_outlined),
    AccountMenuModel(
        id: LanguageConst.language,
        title: LanguageConst.language,
        icon: Icons.language_outlined),
    AccountMenuModel(
        id: LanguageConst.notificationsSettings,
        title: LanguageConst.notificationsSettings,
        icon: Icons.notifications_none_outlined),
    AccountMenuModel(
        id: LanguageConst.shareApp,
        title: LanguageConst.shareApp,
        icon: Icons.share),
    AccountMenuModel(
        id: LanguageConst.termsConditions,
        title: LanguageConst.termsConditions,
        icon: Icons.assignment_outlined),
    AccountMenuModel(
        id: LanguageConst.privacyPolicy,
        title: LanguageConst.privacyPolicy,
        icon: Icons.policy_outlined),
    AccountMenuModel(
        id: LanguageConst.helpSupport,
        title: LanguageConst.helpSupport,
        icon: Icons.question_answer_outlined),
    AccountMenuModel(
        id: LanguageConst.logout,
        title: LanguageConst.logout,
        icon: Icons.logout_outlined),
  ];
  static List<AccountMenuModel> helpAndSupportDataList = [
    AccountMenuModel(
        id: LanguageConst.help,
        title: LanguageConst.help,
        icon: Icons.person_2_outlined),
    AccountMenuModel(
        id: LanguageConst.whatsApp,
        title: LanguageConst.whatsApp,
        icon: Icons.chat),
    AccountMenuModel(
        id: LanguageConst.feedback,
        title: LanguageConst.feedback,
        icon: Icons.feed_outlined),
  ];

  // IMAGE PICK BOTTOM SHET LOCAL DATA
  static List<AccountMenuModel> imagePickBottomSheetLocalData = [
    AccountMenuModel(
        id: LanguageConst.camera,
        title: LanguageConst.camera,
        icon: Icons.camera_alt_outlined),
    AccountMenuModel(
        id: LanguageConst.gallery,
        title: LanguageConst.gallery,
        icon: Icons.photo_library_outlined),
    AccountMenuModel(
        id: LanguageConst.delete,
        title: LanguageConst.delete,
        icon: Icons.delete_outline_outlined),
    AccountMenuModel(
        id: LanguageConst.cancel,
        title: LanguageConst.cancel,
        icon: Icons.cancel_outlined),
  ];

   
}
