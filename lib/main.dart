import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Classes/constant_sheet.dart';
import 'package:ourtalks/Controllers/app_initialbinding.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Res/i18n/language_translations.dart';
import 'package:ourtalks/Utils/Routes/routes.dart';

late ConstantSheet constantSheet;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Lock to portrait
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        constantSheet = ConstantSheet.instance;
        return GetMaterialApp(
          locale: LanguageTranslations.localeLanguage,
          fallbackLocale: LanguageTranslations.localeLanguage,
          translations: LanguageTranslations(),
          initialBinding: AppInitialbinding(),
          getPages: appRoutes,
          initialRoute: constantSheet.routesName.splashScreen,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: constantSheet.colors.black),
        );
      },
      designSize: Size(AppConfig.appScreenWidth, AppConfig.appScreenHeight),
    );
  }
}
