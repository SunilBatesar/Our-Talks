import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/main.dart';

class PrimaryAppBar extends AppBar {
  PrimaryAppBar({super.key, super.title});

  @override
  Widget? get leading => IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Icon(
        Icons.arrow_back_rounded,
        size: 24.sp,
        color: cnstSheet.colors.primary,
      ));
  @override
  Color? get backgroundColor => Colors.transparent;

  @override
  double? get elevation => 0;
  @override
  TextStyle? get titleTextStyle =>
      cnstSheet.textTheme.fs18Medium.copyWith(color: cnstSheet.colors.white);
}
