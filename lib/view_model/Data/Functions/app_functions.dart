import 'package:flutter/material.dart';

class AppFunctions {
  static bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }
}