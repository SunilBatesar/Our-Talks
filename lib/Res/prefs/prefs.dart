import 'package:flutter/material.dart';
import 'package:ourtalks/view_model/Models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? _preferences; // Use nullable type

  static Future<void> getPref() async {
    try {
      _preferences = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('SharedPreferences initialization failed: $e');
    }
  }

  static final String useridKey = "userid"; // USER ID(KEY)
  static final String themeColorKey = "ThemeColorKey"; // THEME COLOR KEY
  static final String _languageKey = "languageKey"; // THEME COLOR KEY

  // SET STRING PREF DATA
  static Future<void> setStringPrefData(String value, String key) async {
    await _preferences?.setString(key, value); // Safe access
  }

  // GET STRING PREF DATA
  static getStringPrefData(String key) => _preferences?.getString(key);

  // SET INT PREF DATA
  static Future<void> setIntPrefData(String key, int value) async {
    await _preferences?.setInt(key, value); // Safe access
  }

  // GET INT PREF DATA
  static getIntPrefData(String key) => _preferences?.getInt(key);

  // LANGUAGE SET AND GET IN PREF
  // SET
  static Future<void> setLanguagePref({required LanguageModel model}) async {
    await _preferences?.setString(_languageKey, model.toJson());
  }

  // GET
  static LanguageModel getLanguagePref() {
    return LanguageModel.fromJson(json: getStringPrefData(_languageKey) ?? "");
  }
}
