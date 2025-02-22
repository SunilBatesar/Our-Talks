import 'dart:ui';

import 'package:get/get.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
import 'package:ourtalks/main.dart';

class ThemeController extends GetxController {
  Rx<Color> selectThemeColor =
      Color(Prefs.getIntPrefData(Prefs.themeColorKey)).obs;

  // THEME COLORS
  final List<Color> themeColorsList = [
    // DEFAULT COLOR
    Color(0xffFFFFFF),

    Color(0xffFFCFEF), //
    Color(0xffFF6F00), // Deep Orange
    Color(0xffFFB22C), // YELLOW
    Color(0xffFF0000), // RED
    Color(0xff1B5E20), // DARK GREEN
    Color(0xff008000), // GREEN
    Color(0xffF72798), //
    Color(0xff800080), // PURPLE
    Color(0xff6A1B9A),
  ];

  void updateTemeColor(Color color) async {
    selectThemeColor.value = color;
    cnstSheet.colors.primaryColorUpdate(color);
    await Prefs.setIntPrefData(Prefs.themeColorKey, color.toARGB32());
    update();
  }
}
