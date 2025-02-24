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
        id: LanguageConst.termsConditions,
        title: LanguageConst.termsConditions,
        icon: Icons.assignment_outlined),
    AccountMenuModel(
        id: LanguageConst.helpSupport,
        title: LanguageConst.helpSupport,
        icon: Icons.question_answer_outlined),
    AccountMenuModel(
        id: LanguageConst.logout,
        title: LanguageConst.logout,
        icon: Icons.logout_outlined),
  ];
}
