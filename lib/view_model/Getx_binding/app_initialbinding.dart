import 'package:get/get.dart';
import 'package:ourtalks/view_model/Controllers/language_controller.dart';
import 'package:ourtalks/view_model/Controllers/theme_controller.dart';

class AppInitialbinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LanguageController());
    Get.put(ThemeController());
  }
}
