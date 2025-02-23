import 'package:flutter/material.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ourtalks/view_model/Apis/firebase_apis.dart';

abstract class Authentication {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup({required UserModel user, required String password});
  Future<void> resetPassword({required String email});
  Future<void> logout();
}

class AuthRepository extends Authentication {
  final _firebaseAuth = FirebaseAuth.instance;

  // loginFunction
  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final credintal = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user =
          await FirebaseApis.userDocumentRef(credintal.user!.uid).get();
      if (user.exists) {
        final usermodel =
            UserModel.fromJson(user.data() as Map<String, dynamic>, user.id);
        debugPrint("User already exists on Firebase: ${usermodel.toString()}");
        return usermodel;
      } else {
        throw Exception("user not found");
      }
    } catch (e) {
      debugPrint("Error adding user to Firebase: $e");
      rethrow;
    }
  }

  @override
  Future<UserModel> signup(
      {required UserModel user, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      final userData = user.copyWith(userID: credential.user!.uid);
      await FirebaseApis.userDocumentRef(credential.user!.uid)
          .set(userData.toJson());

      debugPrint("User data added to Firebase: ${userData.toString()}");
      return userData;
    } catch (e) {
      debugPrint("Error adding user data to Firebase: $e");
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      debugPrint("Password reset email sent to $email");
    } catch (e) {
      debugPrint("Error sending password reset email: $e");
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      debugPrint("User successfully logged out");
    } catch (e) {
      debugPrint("Error logging out: $e");
      rethrow;
    }
  }
}
