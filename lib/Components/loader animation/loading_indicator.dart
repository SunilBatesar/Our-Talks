import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/loading_controller.dart';

class LoadingIndicator extends StatelessWidget {
  final Widget widget;
  LoadingIndicator({super.key, required this.widget});

  final _loadingController = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _loadingController.isLoading.value
          ? Center(
              child: Lottie.asset(
                height: 50.h,
                cnstSheet.animations.loading,
              ),
            )
          : widget;
    });
  }
}
