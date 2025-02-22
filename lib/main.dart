import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Classes/constant_sheet.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Res/i18n/language_translations.dart';
import 'package:ourtalks/Utils/Routes/routes.dart';
import 'package:ourtalks/firebase_options.dart';
import 'package:ourtalks/view_model/Getx_binding/app_initialbinding.dart';

late ConstantSheet constantSheet;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
