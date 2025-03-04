// user_data_handler.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/loading_controller.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/Cloud%20firestore/user_repository.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class UserDataHandler {
  static final _userRepo = UserRepository();
  static final _userController = Get.find<UserController>();
  static final _loadingController = Get.find<LoadingController>();

  // GET USER BY ID
  static Future<void> getUserById(String userId) async {
    await _handleUserOperation(
        operation: () => _userRepo.getUserById(userId),
        onSuccess: (user) async {
          _userController.setUser(user);
          return;
        },
        successMessage: 'User data fetched successfully',
        errorMessage: 'Error fetching user data',
        showSuccess: false);
  }

  // UPDATE USER DATA
  static Future<void> updateUser({
    required String userId,
    required UserModel model,
  }) async {
    await _handleUserOperation(
      operation: () async => await _userRepo.updateUser(userId, model),
      onSuccess: (_) async {
        _userController.updateUser(model);
        Get.offAllNamed(cnstSheet.routesName.navBar);
        debugPrint("User updated successfully: ${model.toJson()}");
        return;
      },
      successMessage: 'Profile updated successfully',
      errorMessage: 'Error updating profile',
    );
  }

  // DELETE USER DATA USE KEY

  Future<void> updatesingleKey(
      {required String userId,
      required String key,
      required dynamic value,
      required String successMessage}) async {
    await _handleUserOperation(
      operation: () async =>
          await _userRepo.updateUserKeyData(userId, key, value),
      onSuccess: (_) async {
        // _userController.updateUser(model);

        debugPrint("User Delete key value successfully: $key :$value");
        return;
      },
      successMessage: successMessage,
      errorMessage: 'Error updating profile',
    );
  }

  static Future<void> addserchlist(String userId, String searchQuery) async {
    await _handleUserOperation(
        operation: () => _userRepo.addserchlist(userId, searchQuery),
        onSuccess: (serachuserlist) async {
          _userController.updateSingleKey("serachuserlist", serachuserlist);
        },
        successMessage: "User added successfully",
        errorMessage: "Failed to add user");
  }

  // GENERIC OPERATION HANDLER FOR USER DATA
  static Future<void> _handleUserOperation<T>({
    required Future<T> Function() operation,
    required Future<void> Function(T) onSuccess,
    required String successMessage,
    required String errorMessage,
    bool showSuccess = true,
  }) async {
    try {
      _loadingController.showLoading();
      final result = await operation();
      await onSuccess(result);
      _loadingController.hideLoading();
      if (showSuccess) {
        AppUtils.showSnackBar(title: 'Success', message: successMessage);
      }
    } catch (e) {
      _loadingController.hideLoading();

      // Only show generic errors here (Firestore errors already handled in repository)
      if (e is! FirebaseException) {
        AppUtils.showSnackBar(
          title: 'Error',
          message: '$errorMessage: ${e.toString()}',
          isError: true,
        );
      }

      debugPrint("$errorMessage: ${e.toString()}");
    } finally {
      _loadingController.hideLoading();
    }
  }
}
