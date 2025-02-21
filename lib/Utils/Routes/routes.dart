import 'package:get/get.dart';
import 'package:ourtalks/Utils/Routes/routes_name.dart';
import 'package:ourtalks/Views/Auth/login_screen.dart';
import 'package:ourtalks/Views/OnBoarding/splash_screen.dart';

List<GetPage<dynamic>> appRoutes = [
  GetPage(name: RoutesName.splashScreen, page: () => SplashScreen()),
  GetPage(name: RoutesName.loginScreen, page: () => LoginScreen())
];
