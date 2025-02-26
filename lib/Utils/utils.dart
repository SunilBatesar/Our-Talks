import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';

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
      backgroundColor: isError ? cnstSheet.colors.red : Colors.green,
      colorText: cnstSheet.colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: duration,
      icon: Icon(
        isError ? Icons.error : Icons.check_circle,
        color: cnstSheet.colors.white,
      ),
    );
  }

  static void showPermissionDialog(
      {required String title,
      required String content,
      required String submitButnText,
      required Function onTap,
      bool submitButnTextColorRed = false}) {
    Get.dialog(
      AlertDialog(
        elevation: 0.5,
        backgroundColor: cnstSheet.colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: BorderSide(color: cnstSheet.colors.primary)),
        title: Text(title,
            style: cnstSheet.textTheme.fs16Medium
                .copyWith(color: cnstSheet.colors.white)),
        content: Text(content,
            style: cnstSheet.textTheme.fs15Normal
                .copyWith(color: cnstSheet.colors.white)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              LanguageConst.cancel.tr,
              style: cnstSheet.textTheme.fs14Normal
                  .copyWith(color: cnstSheet.colors.blue),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onTap();
            },
            child: Text(submitButnText,
                style: cnstSheet.textTheme.fs14Normal.copyWith(
                    color: submitButnTextColorRed
                        ? cnstSheet.colors.red
                        : cnstSheet.colors.blue)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
