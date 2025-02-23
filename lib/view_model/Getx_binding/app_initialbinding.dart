import 'package:get/get.dart';
import 'package:ourtalks/view_model/Controllers/language_controller.dart';
import 'package:ourtalks/view_model/Controllers/loading_controller.dart';
import 'package:ourtalks/view_model/Controllers/theme_controller.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';

class AppInitialbinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoadingController());
    Get.put(LanguageController());
    Get.put(ThemeController());
    Get.put(UserController());
  }
}
