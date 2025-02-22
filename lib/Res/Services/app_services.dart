import 'package:flutter/material.dart';

class AppServices {
  // APP SCREEN HEIGHT AND WIDTH
  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  // Space Size Box
  addheight(double height) => SizedBox(height: height);
  addwidth(double width) => SizedBox(width: width);
}
