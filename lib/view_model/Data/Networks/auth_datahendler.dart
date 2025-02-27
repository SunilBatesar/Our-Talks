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
          Get.offNamed(cnstSheet.routesName.welcomeScreen);
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
        },
        onSuccess: (_) async {
          Get.offAllNamed(cnstSheet.routesName.welcomeScreen);
          debugPrint("User logged out successfully");
          return;
        },
        successMessage: 'User logged out successfully',
        errorMessage: 'Error during logout');
  }

  // GET USER BY ID FUNCTION
  static Future<void> getUserById(String userId) async {
    await _handleAuthOperation(
        operation: () => _repo.getUserById(userId),
        onSuccess: (user) async {
          _userController.setUser(user);
          return;
        },
        successMessage: 'User data fetched successfully',
        errorMessage: 'Error fetching user data');
  }

  // UPDATE USER FUNCTION
  static Future<void> updateUser(
      {required String userId, required UserModel model}) async {
    await _handleAuthOperation(
        operation: () async => await _repo.updateUser(userId, model),
        onSuccess: (_) async {
          _userController.updateUser(model);
          Get.offAllNamed(cnstSheet.routesName.navBar);
          debugPrint("User updated successfully: ${model.toJson()}");
          return;
        },
        successMessage: 'User updated successfully',
        errorMessage: 'Error updating user');
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
      AppUtils.showSnackBar(
          title: 'Error', message: '$errorMessage: $e', isError: true);
      debugPrint("$errorMessage: $e");
    } finally {
      _loadingController.hideLoading();
    }
  }
}
