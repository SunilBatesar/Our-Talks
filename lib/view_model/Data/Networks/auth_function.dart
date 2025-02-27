import 'package:flutter/material.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ourtalks/view_model/Apis/firebase_apis.dart';

abstract class Authentication {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup({required UserModel user, required String password});
  Future<void> resetPassword({required String email});
  Future<void> logout();
  Future<UserModel> getUserById(String userId);
  Future<void> updateUser(String userId, UserModel user);
  Future<void> deleteUser(String userId, String userpassword);
}

class AuthRepository extends Authentication {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user =
          await FirebaseApis.userDocumentRef(credential.user!.uid).get();
      if (user.exists) {
        final usermodel =
            UserModel.fromJson(user.data() as Map<String, dynamic>, user.id);
        debugPrint("User already exists on Firebase: \${usermodel.toString()}");
        return usermodel;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      _handleAuthError(e, 'Error during login');
      rethrow;
    }
  }

  @override
  Future<UserModel> signup(
      {required UserModel user, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      final userData = user.copyWith(userID: credential.user!.uid);
      await FirebaseApis.userDocumentRef(credential.user!.uid)
          .set(userData.toJson());
      debugPrint("User data added to Firebase: \${userData.toString()}");
      return userData;
    } catch (e) {
      _handleAuthError(e, 'Error during signup');
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      debugPrint("Password reset email sent to $email");
    } catch (e) {
      _handleAuthError(e, 'Error sending password reset email');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      debugPrint("User successfully logged out");
    } catch (e) {
      _handleAuthError(e, 'Error logging out');
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final userDoc = await FirebaseApis.userDocumentRef(userId).get();
      if (userDoc.exists) {
        return UserModel.fromJson(
            userDoc.data() as Map<String, dynamic>, userDoc.id);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      _handleAuthError(e, 'Error fetching user data');
      rethrow;
    }
  }

  @override
  Future<void> updateUser(String userId, UserModel model) async {
    try {
      await FirebaseApis.userDocumentRef(userId).update(model.toJson());
    } catch (e) {
      _handleAuthError(e, 'Error updating user data');
    }
  }

  @override
  Future<void> deleteUser(String userId, String userpassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && user.uid == userId) {
        final credential = EmailAuthProvider.credential(
            email: user.email!, password: userpassword);
        await user.reauthenticateWithCredential(credential);
        await FirebaseApis.userDocumentRef(userId).delete();
        await user.delete();
        debugPrint("User permanently deleted: $userId");
      }
    } catch (e) {
      _handleAuthError(e, 'Error during account deletion');
      rethrow;
    }
  }

  void _handleAuthError(dynamic e, String contextMessage) {
    String errorMessage;
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email address is already in use.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'weak-password':
          errorMessage = 'The provided password is too weak.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage =
              'An unexpected error occurred. Please try again later.';
      }
    } else {
      errorMessage = 'An unexpected error occurred. Please try again later.';
    }
    AppUtils.showSnackBar(title: 'Error', message: errorMessage, isError: true);
  }
}
