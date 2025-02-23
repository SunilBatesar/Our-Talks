import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
    update();
  }

  void hideLoading() {
    isLoading.value = false;
    update();
  }
}
