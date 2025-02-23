import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/loading_controller.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_function.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class AuthDataHandler {
  static final _repo = AuthRepository();
  static final _userController = Get.find<UserController>();
  static final _loadingController = Get.find<LoadingController>();

  static Future<void> signUp(
      {required UserModel user, required String password}) async {
    try {
      _loadingController.showLoading();
      final userSnapshot = await _repo.signup(user: user, password: password);
      _userController.setUser(userSnapshot);
      await Prefs.setStringPrefData(userSnapshot.userID!, Prefs.useridKey)
          .then((_) => Get.offAllNamed(cnstSheet.routesName.homeScreen));
      AppUtils.showSnackBar(
          title: 'Success', message: 'User signed up successfully');

      debugPrint("User signed up successfully: ${userSnapshot.toJson()}");
    } catch (e) {
      AppUtils.showSnackBar(
          title: 'Error', message: 'Error during sign up: $e', isError: true);
      debugPrint("Error during sign up: $e");
    } finally {
      _loadingController.hideLoading();
    }
  }

  static Future<void> login(
      {required String email, required String password}) async {
    try {
      _loadingController.showLoading();
      final userSnapshot = await _repo.login(email: email, password: password);
      _userController.setUser(userSnapshot);
      await Prefs.setStringPrefData(userSnapshot.userID!, Prefs.useridKey)
          .then((_) => Get.offAllNamed(cnstSheet.routesName.homeScreen));
      AppUtils.showSnackBar(
          title: 'Success', message: 'User logged in successfully');

      debugPrint("User logged in successfully: ${userSnapshot.toJson()}");
    } catch (e) {
      AppUtils.showSnackBar(
          title: 'Error', message: 'Error during login:  $e', isError: true);
      debugPrint("Error during login: $e");
    } finally {
      _loadingController.hideLoading();
    }
  }

  // password reset
  static Future<void> resetPassword({required String email}) async {
    try {
      _loadingController.showLoading();
      await _repo.resetPassword(email: email).then(
            (_) => Get.offNamed(cnstSheet.routesName.loginScreen),
          );
      AppUtils.showSnackBar(
          title: 'Success', message: 'Password reset email sent successfully');
      debugPrint("Password reset email sent to $email");
    } catch (e) {
      AppUtils.showSnackBar(
          title: 'Error',
          message: 'Error sending password reset email: $e',
          isError: true);
      debugPrint("Error sending password reset email: $e");
    } finally {
      _loadingController.hideLoading();
    }
  }

  // logout
  static Future<void> logout() async {
    try {
      _loadingController.showLoading();
      await _repo.logout();
      await Prefs.clearPrefsData();
      _userController.clearUser();
      Get.offAllNamed(cnstSheet.routesName.languageScreen);
      AppUtils.showSnackBar(
          title: 'Success', message: 'User logged out successfully');
      debugPrint("User logged out successfully");
    } catch (e) {
      AppUtils.showSnackBar(
          title: 'Error', message: 'Error during logout: $e', isError: true);
      debugPrint("Error during logout: $e");
    } finally {
      _loadingController.hideLoading();
    }
  }
}
