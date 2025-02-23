import 'package:flutter/material.dart';
import 'package:ourtalks/view_model/Models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? _preferences;

  static Future<void> getPref() async {
    try {
      _preferences = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('SharedPreferences initialization failed: $e');
    }
  }

  static final String _useridKey = "userid"; // USER ID(KEY)
  static final String _themeColorKey = "ThemeColorKey"; // THEME COLOR KEY
  static final String _languageKey = "languageKey"; // THEME COLOR KEY

  // SET USER DATA PREF
  static Future<void> setUserIdPref(String value) async {
    await _preferences?.setString(_useridKey, value); // Safe access
  }

  static getUserIdPref() =>
      _preferences?.getString(_useridKey); // GET USER DATA PREF

  // COLOR SET AND GET IN PREF
  // SET COLOR PREF DATA
  static Future<void> setColorPrefData(int value) async {
    await _preferences?.setInt(_themeColorKey, value); // Safe access
  }

  static getColorPrefData() =>
      _preferences?.getInt(_themeColorKey) ?? 0xffFFFFFF; // GET COLOR PREF DATA

  // LANGUAGE SET AND GET IN PREF
  // SET LANGUAGE PREF DATA
  static Future<void> setLanguagePref({required LanguageModel model}) async {
    await _preferences?.setString(_languageKey, model.toJson());
  }

  // GET LANGUAGE PREF DATA
  static LanguageModel getLanguagePref() {
    return LanguageModel.fromJson(
        json: _preferences?.getString(_languageKey) ?? "");
  }

  // CLEAR ALL PREF DATA
  static Future<void> clearPrefsData() async {
    await _preferences?.clear();
  }
}
