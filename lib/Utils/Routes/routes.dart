import 'package:get/get.dart';
import 'package:ourtalks/Views/Auth/forget_password_screen.dart';
import 'package:ourtalks/Views/Auth/login_screen.dart';
import 'package:ourtalks/Views/Auth/signup_screen.dart';
import 'package:ourtalks/Views/Auth/verify_email_forget_password_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/Account_Setting/privacy_policy_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/Account_Setting/terms_and_conditions_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/HelpAndSupport/delete_account_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/HelpAndSupport/help_and_support_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/account_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/language_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/theme_screen.dart';
import 'package:ourtalks/Views/NavBar/Account/update_profile_screen.dart';
import 'package:ourtalks/Views/NavBar/Home/home_screen.dart';
import 'package:ourtalks/Views/NavBar/nav_bar.dart';
import 'package:ourtalks/Views/OnBoarding/splash_screen.dart';
import 'package:ourtalks/Views/OnBoarding/welcome_screen.dart';
import 'package:ourtalks/main.dart';

List<GetPage<dynamic>> appRoutes = [
  // FOLDER ON BOARDING ROUTES
  GetPage(name: cnstSheet.routesName.splashScreen, page: () => SplashScreen()),
  GetPage(
      name: cnstSheet.routesName.welcomeScreen,
      page: () => WelcomeScreen(),
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
  // ACCOUNT
  GetPage(name: cnstSheet.routesName.themeScreen, page: () => ThemeScreen()),
  GetPage(
      name: cnstSheet.routesName.languageScreen, page: () => LanguageScreen()),
  GetPage(
      name: cnstSheet.routesName.updateProfileScreen,
      page: () => UpdateProfileScreen()),
  GetPage(
      name: cnstSheet.routesName.helpAndSupportScreen,
      page: () => HelpAndSupportScreen()),
  GetPage(
      name: cnstSheet.routesName.deleteAccountScreen,
      page: () => DeleteAccountScreen()),
  // - ACCOUNT SETTING
  GetPage(
      name: cnstSheet.routesName.termsAndConditionsScreen,
      page: () => TermsAndConditionsScreen()),
  GetPage(
      name: cnstSheet.routesName.privacyPolicyScreen,
      page: () => PrivacyPolicyScreen()),
];
