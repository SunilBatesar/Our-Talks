import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourtalks/Components/Container/primary_container.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/LocalData/local_data.dart';
import 'package:ourtalks/view_model/Models/account_menu_model.dart';
import 'package:permission_handler/permission_handler.dart';

// IMAGE PICK BOTTOM SHEET CALL FUNCTION AND PERMISSION FUNCTION

Future<void> imagePickBottomSheetFunction(
    {required Function(File) file,required Function deleteBtnOnTap}) async {
  bool hasPermission = await requestPermissions();
  if (hasPermission) {
    Get.bottomSheet(ImagePickBottomSheet(
      file: file,
      deleteBtnOnTap: deleteBtnOnTap,
    ));
  }
}

// IMAGE  PICK BOTTOM SHEET
class ImagePickBottomSheet extends StatelessWidget {
  final Function(File) file;
  final Function deleteBtnOnTap;
  const ImagePickBottomSheet(
      {super.key, required this.file, required this.deleteBtnOnTap});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      padding: EdgeInsets.all(15.0.sp),
      color: cnstSheet.colors.black,
      child: GridView.builder(
        itemCount: LocalData.imagePickBottomSheetLocalData.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.6,
            crossAxisSpacing: 5.w,
            mainAxisSpacing: 5.w),
        itemBuilder: (context, index) {
          final data = LocalData.imagePickBottomSheetLocalData[index];
          return TextButton.icon(
            onPressed: () {
              _onTapFunction(data);
            },
            label: Text(
              data.title.tr,
              style: cnstSheet.textTheme.fs18Medium
                  .copyWith(color: cnstSheet.colors.white),
            ),
            icon: Icon(
              data.icon,
              size: 24.sp,
              color: cnstSheet.colors.white,
            ),
          );
        },
      ),
    );
  }

  Future _onTapFunction(AccountMenuModel model) async {
    switch (model.id) {
      case LanguageConst.camera:
        // IMAGE PICK TO CAMERA
        final imagePath = await pickImage(ImageSource.camera);
        if (imagePath.isNotEmpty) {
          final cropImage = await _cropImage(File(imagePath));
          file(File(cropImage));
        }
        Get.back();
      case LanguageConst.gallery:
        // IMAGE PICK TO GALLERY
        final imagePath = await pickImage(ImageSource.gallery);
        if (imagePath.isNotEmpty) {
          final cropImage = await _cropImage(File(imagePath));
          file(File(cropImage));
        }
        Get.back();
      case LanguageConst.delete:
        // DELETE ON TAP FUNCTIONS
        deleteBtnOnTap();
        Get.back();
      case LanguageConst.cancel:
        // CANCEL BUTTON
        Get.back();

      default:
        null;
    }
  }
}

bool _isRequesting = false; // Flag to prevent multiple requests
// GET CAMERA AND GALLERY PERMISSION
Future<bool> requestPermissions() async {
  if (_isRequesting) return false;
  _isRequesting = true; // REQUEST START
  try {
    // CHECK PERMISSION
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        await Permission.photos.isGranted) {
      return true;
    }
    // PERMISSION REQUEST
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    final camera = status[Permission.camera];
    final storage = status[Permission.storage];
    final photos = status[Permission.photos];
    _isRequesting = false; // REQUEST END
    // CHECK PERMISSION
    if (camera!.isGranted && storage!.isGranted || photos!.isGranted) {
      return true;
    } else if (camera.isDenied ||
        camera.isPermanentlyDenied ||
        storage!.isDenied ||
        storage.isPermanentlyDenied ||
        photos.isDenied ||
        photos.isPermanentlyDenied) {
      // OPEN TO PHONE SETTING
      AppUtils.showPermissionDialog(
          title: LanguageConst.permissionRequired.tr,
          content: LanguageConst.pleaseenablecameragallerypermissions.tr,
          submitButnText: LanguageConst.openSettings.tr,
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

// IMAGE PICK FUNCTION
Future<String> pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);
  if (image != null) {
    return image.path;
  }
  return "";
}

//
// IMAGE CROP FUNCTION
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
