import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourtalks/Components/Container/primary_container.dart';
import 'package:ourtalks/main.dart';

class ImagePickBottomSheet extends StatelessWidget {
  final Function(File) file;
  const ImagePickBottomSheet({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0.sp),
      decoration: BoxDecoration(
          border: Border.all(
            color: cnstSheet.colors.primary,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {},
            child: PrimaryContainer(
                child: Column(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 24.sp,
                  color: cnstSheet.colors.white,
                ),
                Gap(3.h),
                Text(
                  "Camera",
                  style: cnstSheet.textTheme.fs18Medium
                      .copyWith(color: cnstSheet.colors.white),
                )
              ],
            )),
          ),
          Gap(15.h),
          GestureDetector(
            onTap: () {},
            child: PrimaryContainer(
                child: Column(
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 24.sp,
                  color: cnstSheet.colors.white,
                ),
                Gap(3.h),
                Text(
                  "Gallery",
                  style: cnstSheet.textTheme.fs18Medium
                      .copyWith(color: cnstSheet.colors.white),
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}

// IMAGE PICK

Future<String?> pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);
  return image?.path;
}
