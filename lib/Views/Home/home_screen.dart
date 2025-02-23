import 'package:flutter/material.dart';
import 'package:ourtalks/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // final color = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        spacing: 10,
        children: [
          Container(
            height: 100,
            width: 100,
            color: cnstSheet.colors.blue,
          ),
          Container(
            height: 100,
            width: 100,
            color: cnstSheet.colors.blue,
          ),
          Container(
            height: 100,
            width: 100,
            color: cnstSheet.colors.blue,
          ),
          Container(
            height: 100,
            width: 100,
            color: cnstSheet.colors.blue,
          ),
          Container(
            height: 100,
            width: 100,
            color: cnstSheet.colors.blue,
          ),
          // Container(
          //   height: 100,
          //   width: 100,
          //   color: constantSheet.colors.blue,
          // ),
        ],
      )),
    );
  }
}
