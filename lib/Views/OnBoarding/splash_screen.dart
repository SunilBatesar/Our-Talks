import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
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

  void nextScreenPushFunction() async {
    Future.delayed(Duration(seconds: 3), () async {
      final praf = Prefs.getuserUID;

      if (praf == null) {
        Get.toNamed(constantSheet.routesName.languageScreen);
      } else {
        Get.offNamed(constantSheet.routesName.homeScreen);
      }
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
                    style: constantSheet.textTheme.appNameStyle45
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
