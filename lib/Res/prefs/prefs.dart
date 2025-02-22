import 'package:flutter/material.dart';
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

  static final String _useridKey = "userid";

  static Future<void> setuserUID(String value) async {
    await _preferences?.setString(_useridKey, value); // Safe access
  }

  static get getuserUID => _preferences?.getString(_useridKey);
}
