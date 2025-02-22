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
              isTransparent ? Colors.transparent : cnstSheet.colors.primary,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: isTransparent
                      ? cnstSheet.colors.primary
                      : cnstSheet.colors.secondary),
              borderRadius: BorderRadius.circular(10.r))),
      child: Text(
        title,
        style: cnstSheet.textTheme.fs16Medium
            .copyWith(color: cnstSheet.colors.white),
      ),
    );
    return isExpanded ? Row(children: [Expanded(child: button)]) : button;
  }
}
