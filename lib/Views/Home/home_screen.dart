import 'package:flutter/material.dart';
import 'package:ourtalks/Components/loader%20animation/loading_indicator.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_datahendler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // final color = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LoadingIndicator(
            widget: IconButton(
                onPressed: () {
                  AuthDataHandler.logout();
                },
                icon: Icon(Icons.exit_to_app))),
      ),
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
