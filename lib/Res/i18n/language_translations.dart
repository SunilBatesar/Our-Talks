import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/view_model/Models/language_model.dart';
import 'package:ourtalks/Res/i18n/language_type.dart';

class LanguageTranslations extends Translations {
  //  LANGUAGE NAME,CODE AND COUNTRY CODE SET
  static LanguageModel englishUS = LanguageModel(
      languageName: "English", languageCode: "en", countryCode: "US");
  static LanguageModel hindi = LanguageModel(
      languageName: "Hindi", languageCode: "hi", countryCode: "IN");

  // ALL LANGUAGE LIST
  static List<LanguageModel> languageList = [englishUS, hindi];

  //OVERRIDE TRANSLATIONS KEYS METHOD  AND ADD LANGUAGE TYPES
  @override
  Map<String, Map<String, String>> get keys => {
        englishUS.toString(): LanguageType.englishUSType,
        hindi.toString(): LanguageType.hindiType
      };

  // SET LOCALE LANGUAGE
  static Locale localeLanguage =
      Locale(englishUS.languageCode, englishUS.countryCode);
}
