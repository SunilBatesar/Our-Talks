import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Classes/constant_sheet.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Res/i18n/language_translations.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
import 'package:ourtalks/Utils/Routes/routes.dart';
import 'package:ourtalks/firebase_options.dart';
import 'package:ourtalks/view_model/Getx_binding/app_initialbinding.dart';

// Global instance of ConstantSheet
late ConstantSheet constantSheet;

// Main entry point of the application
Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter bindings are initialized

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize shared preferences
  await Prefs.getPref();

  // Lock device orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp()); // Start the app
  });
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // ScreenUtil helps with responsive UI across different screen sizes
      builder: (context, child) {
        constantSheet = ConstantSheet.instance; // Access global instance

        return GetMaterialApp(
          locale: LanguageTranslations.localeLanguage, // App language locale
          fallbackLocale:
              LanguageTranslations.localeLanguage, // Fallback language
          translations: LanguageTranslations(), // Internationalization support
          initialBinding: AppInitialbinding(), // GetX initial bindings
          getPages: appRoutes, // Application routes
          initialRoute: constantSheet.routesName.splashScreen, // Initial screen
          debugShowCheckedModeBanner: false, // Hide debug banner
          theme: ThemeData(
            scaffoldBackgroundColor:
                constantSheet.colors.black, // App theme color
          ),
        );
      },
      designSize: Size(AppConfig.appScreenWidth,
          AppConfig.appScreenHeight), // Screen design size
    );
  }
}
