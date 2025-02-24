import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Views/NavBar/Home/Widgets/user_message_tile.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR AND SHOW APP NAME
      appBar: AppBar(
        title: Text(
          AppConfig.appName,
          style: cnstSheet.textTheme.appNameStyle15
              .copyWith(color: cnstSheet.colors.primary),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => UserMessageTile(
                  model: UserModel(
                      userName: "batesar_sunil",
                      image:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqU4vLfw1UL-mlkkZSzi3q441eQwhFjW8A9g&s",
                      about: "Ram Ram Tau",
                      name: "Sunil",
                      createdAt: "createdAt",
                      lastActive: "Last seen 12:30 pm",
                      email: "sunil@gmail.com",
                      pushToken: "pushToken"),
                ).marginOnly(bottom: 15.h),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
