import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {
  RxBool isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
    debugPrint("Loading शुरू हुआ=============: ${isLoading.value}");
    update();
  }

  void hideLoading() {
    isLoading.value = false;
    debugPrint("Loading खत्म हुआ-------------: ${isLoading.value}");
    update();
  }
}
