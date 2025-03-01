import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/Cloud%20firestore/user_datahendler.dart';
import 'package:ourtalks/view_model/Data/Networks/cloudinary/cloudinary_function.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class AppButtonhitFunction {
  static Future<void> updateProfile({
    required GlobalKey<FormState> formKey,
    required File? imageFile,
    required File? bannerImageFile,
    required UserModel userData,
    required TextEditingController nameController,
    required TextEditingController userNameController,
    required TextEditingController aboutController,
  }) async {
    try {
      if (!formKey.currentState!.validate()) return;

      String? newUserDpUrl;
      String? newBannerUrl;

      // Handle UserDP Image
      if (imageFile != null) {
        if (userData.userDP?.isEmpty ?? true) {
          newUserDpUrl = await CloudinaryFunctions()
              .uploadImageToCloudinary(imageFile, folder: "userdp");
          if (newUserDpUrl == null) throw Exception('UserDP upload failed');
        } else {
          final dpPublicId = extractPublicIdFromUrl(userData.userDP!);
          newUserDpUrl = await CloudinaryFunctions().replaceImageInCloudinary(
            imageFile,
            folder: "userdp",
            publicId: dpPublicId ??
                'user_${userData.userID}_${DateTime.now().millisecondsSinceEpoch}',
          );
          if (newUserDpUrl == null) throw Exception('UserDP update failed');
        }
      }

      // Handle Banner Image
      if (bannerImageFile != null) {
        if (userData.banner?.isEmpty ?? true) {
          newBannerUrl = await CloudinaryFunctions()
              .uploadImageToCloudinary(bannerImageFile, folder: "userbanner");
          if (newBannerUrl == null) throw Exception('Banner upload failed');
        } else {
          final bannerPublicId = extractPublicIdFromUrl(userData.banner!);
          newBannerUrl = await CloudinaryFunctions().replaceImageInCloudinary(
            bannerImageFile,
            folder: "userbanner",
            publicId: bannerPublicId ??
                'banner_${userData.userID}_${DateTime.now().millisecondsSinceEpoch}',
          );
          if (newBannerUrl == null) throw Exception('Banner update failed');
        }
      }

      // Update user data with both images
      await UserDataHandler.updateUser(
        userId: userData.userID!,
        model: userData.copyWith(
          userDP: newUserDpUrl ?? userData.userDP,
          banner: newBannerUrl ?? userData.banner,
          name: nameController.text.trim(),
          userName: userNameController.text.trim(),
          about: aboutController.text.trim(),
        ),
      );
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to update profile: ${e.toString()}'.tr);
      rethrow;
    }
  }

  // static String? extractPublicIdFromUrl(String url) {
  //   try {
  //     final uri = Uri.parse(url);
  //     final pathParts = uri.path.split('/');
  //     final uploadIndex = pathParts.indexWhere((part) => part == 'upload');

  //     if (uploadIndex == -1 || uploadIndex + 2 >= pathParts.length) {
  //       return null;
  //     }

  //     // Extract parts after 'upload/v...' which includes folder and filename
  //     final publicIdWithExtension =
  //         pathParts.sublist(uploadIndex + 2).join('/');
  //     return publicIdWithExtension.split('.').first;
  //   } catch (e) {
  //     return null;
  //   }
  // }
  static String? extractPublicIdFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      final uploadIndex = pathSegments.indexOf('upload');

      if (uploadIndex == -1 || uploadIndex >= pathSegments.length - 2) {
        return null;
      }

      final publicIdWithExtension =
          pathSegments.sublist(uploadIndex + 2).join('/');
      return publicIdWithExtension.split('.').first;
    } catch (e) {
      debugPrint('Public ID extraction error: $e');
      return null;
    }
  }
}
