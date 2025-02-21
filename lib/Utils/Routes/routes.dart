import 'package:get/get.dart';
import 'package:ourtalks/Views/Auth/login_screen.dart';
import 'package:ourtalks/Views/Auth/signup_screen.dart';
import 'package:ourtalks/Views/Home/home_screen.dart';
import 'package:ourtalks/Views/OnBoarding/language_screen.dart';
import 'package:ourtalks/Views/OnBoarding/splash_screen.dart';
import 'package:ourtalks/main.dart';

List<GetPage<dynamic>> appRoutes = [
  // FOLDER ON BOARDING ROUTES
  GetPage(
      name: constantSheet.routesName.splashScreen, page: () => SplashScreen()),
  GetPage(
      name: constantSheet.routesName.languageScreen,
      page: () => LanguageScreen()),

  // FOLDER AUTH ROUTES
  GetPage(
      name: constantSheet.routesName.loginScreen, page: () => LoginScreen()),
  GetPage(
      name: constantSheet.routesName.signUpScreen, page: () => SignUpScreen()),
  GetPage(
      name: constantSheet.routesName.languageScreen,
      page: () => LanguageScreen()),

  // FOLDER HOME ROUTES
  GetPage(name: constantSheet.routesName.homeScreen, page: () => HomeScreen()),
];
