import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourtalks/Components/Container/primary_container.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/main.dart';
import 'package:permission_handler/permission_handler.dart';

// IMAGE PICK BOTTOM SHEET CALL FUNCTION AND PERMISSEN FUNCTION

Future<void> imagePickBottomSheetFunction(Function(File) file) async {
  bool hasPermission = await requestPermissions();
  if (hasPermission) {
    Get.bottomSheet(ImagePickBottomSheet(file: file));
  }
}

// IMAGE  PICK BOTTOM SHEET
class ImagePickBottomSheet extends StatelessWidget {
  final Function(File) file;
  const ImagePickBottomSheet({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0.sp),
      decoration: BoxDecoration(
          color: cnstSheet.colors.black,
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
          // CAMERA IMAGE PICK
          GestureDetector(
            onTap: () async {
              final imagePath = await pickImage(ImageSource.camera);
              if (imagePath.isNotEmpty) {
                final cropImage = await _cropImage(File(imagePath));
                file(File(cropImage));
              }
              Get.back();
            },
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
                  LanguageConst.camera.tr,
                  style: cnstSheet.textTheme.fs18Medium
                      .copyWith(color: cnstSheet.colors.white),
                )
              ],
            )),
          ),
          Gap(15.h),
          GestureDetector(
            onTap: () async {
              final imagePath = await pickImage(ImageSource.gallery);
              if (imagePath.isNotEmpty) {
                final cropImage = await _cropImage(File(imagePath));
                file(File(cropImage));
              }

              Get.back();
            },
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
                  LanguageConst.gallery.tr,
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

bool _isRequesting = false; // Flag to prevent multiple requests
// GET CAMERA AND GALLERY PERMISSION
Future<bool> requestPermissions() async {
  if (_isRequesting) return false;
  _isRequesting = true; // REQUEST START
  try {
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        await Permission.photos.isGranted) {
      return true;
    }
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    final camera = status[Permission.camera];
    final storage = status[Permission.storage];
    final photos = status[Permission.photos];
    _isRequesting = false; // REQUEST END
    if (camera!.isGranted && storage!.isGranted || photos!.isGranted) {
      return true;
    } else if (camera.isDenied ||
        camera.isPermanentlyDenied ||
        storage!.isDenied ||
        storage.isPermanentlyDenied ||
        photos.isDenied ||
        photos.isPermanentlyDenied) {
      AppUtils.showPermissionDialog(
          title: LanguageConst.permissionRequired.tr,
          content: LanguageConst.pleaseenablecameragallerypermissions.tr,
          onTap: () async {
            await openAppSettings();
          });
      return false;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    _isRequesting = false; // REQUEST END
  }
  return false;
}

// IMAGE PICK
Future<String> pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);
  if (image != null) {
    return image.path;
  }
  return "";
}

Future<String> _cropImage(File imageFile) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: LanguageConst.cropImage.tr,
        toolbarColor: cnstSheet.colors.black,
        toolbarWidgetColor: cnstSheet.colors.primary,
        backgroundColor: cnstSheet.colors.black,
        dimmedLayerColor: cnstSheet.colors.black,
        statusBarColor: cnstSheet.colors.black,
        hideBottomControls: true,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        lockAspectRatio: false,
      ),
      IOSUiSettings(
          title: LanguageConst.cropImage.tr,
          doneButtonTitle: LanguageConst.done.tr,
          cancelButtonTitle: LanguageConst.cancel.tr,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          aspectRatioLockEnabled: false),
    ],
  );
  if (croppedFile != null) {
    return croppedFile.path;
  }
  return "";
}
