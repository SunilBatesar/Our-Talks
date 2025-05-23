import 'dart:ui';

import 'package:get/get.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
import 'package:ourtalks/main.dart';

class ThemeController extends GetxController {
  Rx<Color> selectThemeColor = Color(Prefs.getColorPrefData()).obs;

  // THEME COLORS
  final List<Color> themeColorsList = [
    // DEFAULT COLOR
    Color(0xffFFFFFF),
    Color(0xff808080),
    Color(0xffFFCFEF),
    Color(0xffFFC0CB),
    Color(0xffFFD700),
    Color(0xffFFB22C),
    Color(0xffFF6F00),
    Color(0xffFF0000),
    Color(0xff00FF00),
    Color(0xff008080),
    Color(0xff008000),
    Color(0xff1B5E20),
    Color(0xff800080),
    Color(0xffF72798),
    Color(0xff6A1B9A),
    Color(0xff00FFFF),
  ];

  void updateTemeColor(Color color) async {
    selectThemeColor.value = color;
    cnstSheet.colors.primaryColorUpdate(color);
    await Prefs.setColorPrefData(color.toARGB32());
    update();
  }
}
