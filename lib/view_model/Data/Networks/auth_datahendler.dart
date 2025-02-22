import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_function.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class AuthDataHandler {
  static final _repo = AuthRepository();
  static final _userController = Get.find<UserController>();
  static Future<void> signUp(
      {required UserModel user, required String password}) async {
    try {
      final userSnapshot = await _repo.signup(user: user, password: password);
      _userController.setUser(userSnapshot);
      await Prefs.setuserUID(userSnapshot.userID)
          .then((_) => Get.offAllNamed(constantSheet.routesName.homeScreen));

      debugPrint("User signed up successfully: ${userSnapshot.toJson()}");
    } catch (e) {
      debugPrint("Error during sign up: $e");
    }
  }

  static Future<void> login(
      {required String email, required String password}) async {
    try {
      final userSnapshot = await _repo.login(email: email, password: password);
      _userController.setUser(userSnapshot);
      await Prefs.setuserUID(userSnapshot.userID)
          .then((_) => Get.offAllNamed(constantSheet.routesName.homeScreen));
      debugPrint("User logged in successfully: ${userSnapshot.toJson()}");
    } catch (e) {
      debugPrint("Error during login: $e");
    }
  }
}
