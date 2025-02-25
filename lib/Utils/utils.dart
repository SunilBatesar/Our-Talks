import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';

class AppUtils {
  static fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void showSnackBar({
    required String title,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 4),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: duration,
      icon: Icon(
        isError ? Icons.error : Icons.check_circle,
        color: Colors.white,
      ),
    );
  }

  static void showPermissionDialog(
      {required String title,required String content,required Function onTap}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(LanguageConst.cancel.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onTap();
            },
            child: Text(LanguageConst.openSettings.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
