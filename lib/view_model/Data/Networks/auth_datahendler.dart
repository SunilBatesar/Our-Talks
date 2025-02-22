import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_function.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class AuthDataHandler {
  static Future<void> signUp(
      {required UserModel user, required String password}) async {
    final repo = AuthRepository();
    final userController = Get.find<UserController>();

    try {
      final userSnapshot = await repo.signup(user: user, password: password);
      userController.setUser(userSnapshot);
      debugPrint("User signed up successfully: ${userSnapshot.toJson()}");
    } catch (e) {
      debugPrint("Error during sign up: $e");
    }
  }

  static Future<void> login(
      {required String email, required String password}) async {
    final repo = AuthRepository();
    final userController = Get.find<UserController>();

    try {
      final userSnapshot = await repo.login(email: email, password: password);
      userController.setUser(userSnapshot);
      debugPrint("User logged in successfully: ${userSnapshot.toJson()}");
    } catch (e) {
      debugPrint("Error during login: $e");
    }
  }
}
