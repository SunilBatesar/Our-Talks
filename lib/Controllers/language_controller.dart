import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/view_model/Models/language_model.dart';
import 'package:ourtalks/Res/i18n/language_translations.dart';

class LanguageController extends GetxController {
  final Rx<LanguageModel> _languagedata = LanguageTranslations.englishUS.obs;
  LanguageModel get languagedata => _languagedata.value;

  // SET LANGUAGE
  setLanguage(LanguageModel model) {
    Locale localeValue = Locale(
        model.languageCode, model.countryCode); // SET NEW LOCALE LANGUAGE
    Get.updateLocale(localeValue); // UPDATE LOCALE
    _languagedata(model); // SET NEW LANGUAGE DATA
  }
}
