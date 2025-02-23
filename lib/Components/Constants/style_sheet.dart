import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';

class AppColors {
  late Color primary;
  Color secondary = const Color(0xff000000);
  Color black = Colors.black;
  Color white = Colors.white;
  Color red = Colors.red;
  Color blue = Colors.blue;

  AppColors() {
    final value = Prefs.getColorPrefData();
    primary = Color(value ?? 0xffFFFFFF);
  }
  // UPDATE PRIMARY COLOR
  void primaryColorUpdate(Color color) {
    primary = color;
  }
}

class AppTextTheme {
  AppTextTheme();

  // APP NAME STYLE
  TextStyle appNameStyle15 = GoogleFonts.montserratAlternates(
      fontSize: 25.sp, fontWeight: FontWeight.w600);
  TextStyle appNameStyle45 = GoogleFonts.montserratAlternates(
      fontSize: 45.sp, fontWeight: FontWeight.w600);

  //NORMAL
  TextStyle fs12Normal =
      GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w400);
  TextStyle fs14Normal =
      GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400);
  TextStyle fs15Normal =
      GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w400);

  // MEDIUM
  TextStyle fs16Medium =
      GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500);
  TextStyle fs18Medium =
      GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w500);
  TextStyle fs20Medium =
      GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w500);
  TextStyle fs24Medium =
      GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.w500);
  TextStyle fs29Medium =
      GoogleFonts.poppins(fontSize: 29.sp, fontWeight: FontWeight.w500);
  TextStyle fs35Medium =
      GoogleFonts.poppins(fontSize: 35.sp, fontWeight: FontWeight.w500);

  // BOLD
  TextStyle fs14Bold =
      GoogleFonts.outfit(fontSize: 14.sp, fontWeight: FontWeight.w700);
  TextStyle fs16Bold =
      GoogleFonts.outfit(fontSize: 16.sp, fontWeight: FontWeight.w700);
  TextStyle fs18Bold =
      GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w700);
  TextStyle fs24Bold =
      GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.w700);
}
