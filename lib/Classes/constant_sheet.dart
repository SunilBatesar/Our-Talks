import 'package:ourtalks/Components/Constants/app_assets.dart';
import 'package:ourtalks/Components/Constants/style_sheet.dart';
import 'package:ourtalks/Res/Services/app_services.dart';
import 'package:ourtalks/Utils/Routes/routes_name.dart';

class ConstantSheet {
  ConstantSheet._constantSheet();

  static final ConstantSheet instance = ConstantSheet._constantSheet();
  factory ConstantSheet() {
    return instance;
  }

  // APP SERVICES
  AppServices get services => AppServices();

  // APP ANIMATIONS
  final AppAnimations animations = AppAnimations();

  // APP IMAGES
  final AppImages images = AppImages();

  // APP TEXT THEME
  AppTextTheme get textTheme => AppTextTheme();

  // APP COLORS
  AppColors get colors => AppColors();

  // APP ROUTES NAME
  final RoutesName routesName = RoutesName();
}
