import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {
  bool isLoading = false;

  void showLoading() {
    isLoading = true;
    debugPrint("Loading शुरू हुआ=============: $isLoading");
    update();
  }

  void hideLoading() {
    isLoading = false;
    debugPrint("Loading खत्म हुआ-------------: $isLoading");
    update();
  }
}
