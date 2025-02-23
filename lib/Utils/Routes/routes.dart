import 'package:get/get.dart';
import 'package:ourtalks/Views/Auth/forget_password_screen.dart';
import 'package:ourtalks/Views/Auth/login_screen.dart';
import 'package:ourtalks/Views/Auth/signup_screen.dart';
import 'package:ourtalks/Views/Auth/verify_email_forget_password_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/account_screen.dart';
import 'package:ourtalks/Views/NavBar/Home/home_screen.dart';
import 'package:ourtalks/Views/NavBar/nav_bar.dart';
import 'package:ourtalks/Views/OnBoarding/language_screen.dart';
import 'package:ourtalks/Views/OnBoarding/splash_screen.dart';
import 'package:ourtalks/main.dart';

List<GetPage<dynamic>> appRoutes = [
  // FOLDER ON BOARDING ROUTES
  GetPage(name: cnstSheet.routesName.splashScreen, page: () => SplashScreen()),
  GetPage(
      name: cnstSheet.routesName.languageScreen,
      page: () => LanguageScreen(),
      transition: Transition.upToDown),

  // FOLDER AUTH ROUTES
  GetPage(
      name: cnstSheet.routesName.loginScreen,
      page: () => LoginScreen(),
      transition: Transition.upToDown),
  GetPage(
      name: cnstSheet.routesName.verifyEmailForgetPasswordScreen,
      page: () => VerifyEmailForgetPasswordScreen(),
      transition: Transition.upToDown),
  GetPage(
      name: cnstSheet.routesName.forgetPasswordScreen,
      page: () => ForgetPasswordScreen(),
      transition: Transition.upToDown),

  GetPage(
      name: cnstSheet.routesName.signUpScreen,
      page: () => SignUpScreen(),
      transition: Transition.upToDown),

  // FOLDER NAV BAR ROUTES
  GetPage(name: cnstSheet.routesName.navBar, page: () => NavBar()),
  GetPage(name: cnstSheet.routesName.homeScreen, page: () => HomeScreen()),
  GetPage(
      name: cnstSheet.routesName.accountScreen, page: () => AccountScreen()),
];
