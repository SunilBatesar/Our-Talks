import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/app_validators.dart';
import 'package:ourtalks/main.dart';

// ignore: must_be_immutable
class SearchTextField extends StatelessWidget {
  TextEditingController controller;
  AppValidator? validator;
  Function(String)? onchanged;
  Function(String) onFieldSubmitted;
  Function iconOnTap;
  SearchTextField({
    super.key,
    required this.controller,
    required this.iconOnTap,
    required this.onFieldSubmitted,
    this.validator,
    this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:
          validator == null ? null : (value) => validator!.validate(value),
      onChanged: onchanged == null ? null : (v) => onchanged!(v),
      onFieldSubmitted: onFieldSubmitted ,
      controller: controller,
      cursorColor: cnstSheet.colors.primary,
      style: cnstSheet.textTheme.fs14Normal
          .copyWith(color: cnstSheet.colors.white),
      decoration: InputDecoration(
          isDense: false,
          suffixIcon: GestureDetector(
            onTap: () {
              iconOnTap();
            },
            child: Icon(
              Icons.search_outlined,
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
              borderRadius: BorderRadius.circular(10.r)),
          hintText: LanguageConst.searchUserName.tr,
          hintStyle: cnstSheet.textTheme.fs15Normal
              .copyWith(color: cnstSheet.colors.primary)),
    );
  }
}
