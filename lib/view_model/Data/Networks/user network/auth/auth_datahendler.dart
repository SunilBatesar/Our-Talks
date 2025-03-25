import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/loading_controller.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/auth/auth_repository.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class AuthDataHandler {
  static final _repo = AuthRepository();
  static final _userController = Get.find<UserController>();
  static final _loadingController = Get.find<LoadingController>();

  // SIGN UP
  static Future<void> signUp(
      {required UserModel user, required String password}) async {
    await _handleAuthOperation(
        operation: () => _repo.signup(user: user, password: password),
        onSuccess: (userSnapshot) async {
          _userController.setUser(userSnapshot);
          await Prefs.setUserIdPref(userSnapshot.userID!);
          Get.offAllNamed(cnstSheet.routesName.navBar);
          debugPrint("User signed up successfully: ${userSnapshot.toJson()}");
          return;
        },
        successMessage: 'User signed up successfully',
        errorMessage: 'Error during sign up');
  }

  // LOGIN FUNCTION
  static Future<void> login(
      {required String email, required String password}) async {
    await _handleAuthOperation(
        operation: () => _repo.login(email: email, password: password),
        onSuccess: (userSnapshot) async {
          _userController.setUser(userSnapshot);
          await Prefs.setUserIdPref(userSnapshot.userID!);
          Get.offAllNamed(cnstSheet.routesName.navBar);
          debugPrint("User logged in successfully: ${userSnapshot.toJson()}");
          return;
        },
        successMessage: 'User logged in successfully',
        errorMessage: 'Error during login');
  }

  // PASSWORD RESET FUNCTION
  static Future<void> resetPassword({required String email}) async {
    await _handleAuthOperation(
        operation: () => _repo.resetPassword(email: email),
        onSuccess: (_) async {
          Get.back();
          debugPrint("Password reset email sent to $email");
          return;
        },
        successMessage: 'Password reset email sent successfully',
        errorMessage: 'Error sending password reset email');
  }

  // LOGOUT FUNCTION
  static Future<void> logout() async {
    await _handleAuthOperation(
        operation: () async {
          await _repo.logout();
          _userController.clearUser();
          await Prefs.clearPrefsData();
          // await DatabaseHelper()
          //     .clearFriendsTable(); // CLEAR FRIENDS LIST IN LOCAL DATA
        },
        onSuccess: (_) async {
          Get.offAllNamed(cnstSheet.routesName.welcomeScreen);
          debugPrint("User logged out successfully");
          return;
        },
        successMessage: 'User logged out successfully',
        errorMessage: 'Error during logout');
  }

  // DELETE USER FUNCTION
  static Future<void> deleteUserPermanent(String userPassword) async {
    final uid = Prefs.getUserIdPref();
    await _handleAuthOperation(
        operation: () => _repo.deleteUser(uid, userPassword),
        onSuccess: (_) async {
          _userController.clearUser();
          await Prefs.clearPrefsData();
          Get.offAllNamed(cnstSheet.routesName.welcomeScreen);
          debugPrint("User account deleted permanently");
          return;
        },
        successMessage: 'User account deleted permanently',
        errorMessage: 'Error during account deletion');
  }

  static Future<void> changeUserPassword(
      String currentPassword, String newPassword) async {
    final uid = Prefs.getUserIdPref();
    await _handleAuthOperation(
      operation: () =>
          _repo.changeUserPassword(uid, currentPassword, newPassword),
      onSuccess: (_) async {
        debugPrint("User password changed successfully");
        return;
      },
      successMessage: 'User password changed successfully',
      errorMessage: 'Error during password change',
    );
  }

  // GENERIC OPERATION HANDLER
  static Future<void> _handleAuthOperation<T>(
      {required Future<T> Function() operation,
      required Future<void> Function(T) onSuccess,
      required String successMessage,
      required String errorMessage}) async {
    try {
      _loadingController.showLoading();
      final result = await operation();
      await onSuccess(result);
      _loadingController.hideLoading();
      AppUtils.showSnackBar(title: 'Success', message: successMessage);
    } catch (e) {
      _loadingController.hideLoading();
      // Show snackbar only if it's NOT a FirebaseAuthException
      if (e is! FirebaseAuthException) {
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
