import 'package:get/get.dart';
import 'package:ourtalks/Controllers/language_controller.dart';

class AppInitialbinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LanguageController());
  }
}
