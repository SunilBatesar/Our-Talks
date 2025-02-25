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
  final bool readOnly;
  final IconData? suffixicon;
  final Function? suffixiconOnTap;
  final FocusNode? focusNode;
  final TextInputType? keybordtype;
  final Function(String)? onChanged;
  final Function(String)? fieldSubmitted;
  const PrimaryTextfield({
    super.key,
    this.label,
    required this.controller,
    this.validator,
    this.isDense = false,
    this.isobscureText = false,
    this.readOnly = false,
    this.suffixicon,
    this.suffixiconOnTap,
    this.focusNode,
    this.keybordtype,
    this.onChanged,
    this.fieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: onChanged,
        controller: controller,
        validator:
            validator != null ? (value) => validator!.validate(value) : null,
        onFieldSubmitted:
            fieldSubmitted != null ? (value) => fieldSubmitted!(value) : null,
        focusNode: focusNode,
        obscureText: isobscureText,
        keyboardType: keybordtype,
        readOnly: readOnly,
        style: cnstSheet.textTheme.fs14Normal
            .copyWith(color: cnstSheet.colors.white),
        cursorColor: cnstSheet.colors.primary,
        decoration: InputDecoration(
            isDense: isDense,
            label: Text(
              label ?? "",
              style: cnstSheet.textTheme.fs14Normal
                  .copyWith(color: cnstSheet.colors.white),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                suffixiconOnTap != null ? suffixiconOnTap!() : null;
              },
              child: Icon(
                suffixicon,
                size: 24.sp,
                color: cnstSheet.colors.primary,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: cnstSheet.colors.primary,
                ),
                borderRadius: BorderRadius.circular(10.r)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: cnstSheet.colors.primary,
                ),
                borderRadius: BorderRadius.circular(10.r)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: cnstSheet.colors.primary,
                ),
                borderRadius: BorderRadius.circular(10.r))));
  }
}
