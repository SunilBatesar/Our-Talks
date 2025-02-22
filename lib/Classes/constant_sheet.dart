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

  // LANGUAGE CONSTS
  // final LanguageConst _languageConst = LanguageConst();
  // LanguageConst get languageConst => _languageConst;

  // APP SERVICES
  final AppServices _services = AppServices();
  AppServices get services => _services;

  // APP ANIMATIONS
  final AppAnimations _animations = AppAnimations();
  AppAnimations get animations => _animations;

  // APP IMAGES
  final AppImages _images = AppImages();
  AppImages get images => _images;

  // APP TEXT THEME
  final AppTextTheme _textTheme = AppTextTheme();
  AppTextTheme get textTheme => _textTheme;

  // APP COLORS
  final AppColors _colors = AppColors();
  AppColors get colors => _colors;

  // APP ROUTES NAME
  final RoutesName _routesName = RoutesName();
  RoutesName get routesName => _routesName;
}
