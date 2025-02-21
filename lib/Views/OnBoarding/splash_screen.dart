import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Utils/Routes/routes_name.dart';
import 'package:ourtalks/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    nextScreenPushFunction();
  }

  nextScreenPushFunction() {
    Future.delayed(Duration(seconds: 1), () {
      Get.toNamed(RoutesName.loginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: constantSheet.services.screenWidth(context),
          height: constantSheet.services.screenHeight(context),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              constantSheet.colors.secondary,
              constantSheet.colors.secondary,
              constantSheet.colors.primary,
              constantSheet.colors.primary,
            ],
            stops: [0.0, 0.50, 0.50, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.rotate(
                  angle: 4.5.sp / 5,
                  origin: Offset(-75.sp,
                      constantSheet.services.screenWidth(context) * 0.2),
                  alignment: Alignment.centerLeft,
                  transformHitTests: false,
                  filterQuality: FilterQuality.high,
                  child: Text(
                    AppConfig.appName,
                    style: constantSheet.textTheme.appNameStyle50
                        .copyWith(color: constantSheet.colors.primary),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Lottie.asset(
                      constantSheet.animations.walking,
                      // animate: false,
                    )),
              ),
            ],
          )),
    );
  }
}
