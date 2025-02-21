import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ourtalks/main.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isTransparent;
  final bool isExpanded;
  final bool isLoding;
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isTransparent = false,
    this.isExpanded = false,
    this.isLoding = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      onPressed: () {
        isLoding ? null : onPressed();
      },
      style: TextButton.styleFrom(
          minimumSize: Size(100.w, 50.h),
          backgroundColor:
              isTransparent ? Colors.transparent : constantSheet.colors.primary,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: isTransparent
                      ? constantSheet.colors.primary
                      : constantSheet.colors.secondary),
              borderRadius: BorderRadius.circular(10.r))),
      child: Text(
        title,
        style: constantSheet.textTheme.fs16Medium.copyWith(
            color: isTransparent
                ? constantSheet.colors.primary
                : constantSheet.colors.secondary),
      ),
    );
    return isExpanded ? Row(children: [Expanded(child: button)]) : button;
  }
}
