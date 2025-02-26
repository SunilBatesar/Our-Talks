import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ourtalks/main.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Color? color;
  final Color? bordercolor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final BoxShape? boxShape;
  const PrimaryContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.color,
    this.bordercolor,
    this.padding,
    this.margin,
    this.alignment,
    this.boxShape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      height: height,
      width: width ?? cnstSheet.services.screenWidth(context),
      padding: padding ?? EdgeInsets.all(10.sp),
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        shape: boxShape ?? BoxShape.rectangle,
        border: Border.all(
            color:
                bordercolor != null ? bordercolor! : cnstSheet.colors.primary),
        borderRadius: boxShape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius ?? 10.r),
      ),
      child: child,
    );
  }
}
