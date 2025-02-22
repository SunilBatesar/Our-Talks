import 'dart:ui';

import 'package:get/get.dart';
import 'package:ourtalks/main.dart';

class ThemeController extends GetxController {
  Color selectThemeColor = Color(0xffFFFFFF);

  // THEME COLORS
  final List<Color> themeColorsList = [
    // 🟠 Dark Oranges
    Color(0xffFF6F00), // Deep Orange

    // 🟡 Dark Yellows/Gold
    Color(0xffFFB22C), // YELLOW

    // 🟠 Dark Red
    Color(0xff8E1616), // Deep Red
  ];

  void updateTemeColor(Color color) {
    selectThemeColor = color;
    constantSheet.colors.primaryColorUpdate(color);
    update();
  }
}
