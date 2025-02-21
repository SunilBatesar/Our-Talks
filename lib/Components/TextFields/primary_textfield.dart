import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ourtalks/Utils/app_validators.dart';
import 'package:ourtalks/main.dart';

class PrimaryTextfield extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final AppValidator? validator;
  final bool? isDense;
  final bool isobscureText;
  final IconData? suffixicon;
  final Function? suffixiconOnTap;
  final FocusNode? focusNode;
  final TextInputType? keybordtype;
  const PrimaryTextfield({
    super.key,
    this.label,
    required this.controller,
    this.validator,
    this.isDense = false,
    this.isobscureText = false,
    this.suffixicon,
    this.suffixiconOnTap,
    this.focusNode,
    this.keybordtype,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator:
            validator != null ? (value) => validator!.validator(value) : null,
        focusNode: focusNode,
        obscureText: isobscureText,
        keyboardType: keybordtype,
        style: constantSheet.textTheme.fs14Normal
            .copyWith(color: constantSheet.colors.primary),
        decoration: InputDecoration(
            isDense: isDense,
            label: Text(
              label ?? "",
              style: constantSheet.textTheme.fs14Normal
                  .copyWith(color: constantSheet.colors.primary),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                suffixiconOnTap != null ? suffixiconOnTap!() : null;
              },
              child: Icon(
                suffixicon,
                size: 24.sp,
                color: constantSheet.colors.primary,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: constantSheet.colors.primary,
                ),
                borderRadius: BorderRadius.circular(10.r)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: constantSheet.colors.primary,
                ),
                borderRadius: BorderRadius.circular(10.r)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: constantSheet.colors.primary,
                ),
                borderRadius: BorderRadius.circular(10.r))));
  }
}
