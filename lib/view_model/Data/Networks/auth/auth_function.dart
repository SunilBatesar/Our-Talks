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
  Future<void> changeUserPassword(
      String userId, String currentPassword, String newPassword);
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

  @override
  Future<void> changeUserPassword(
      String userId, String currentPassword, String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && user.uid == userId) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        debugPrint("Password successfully changed for user: $userId");
      }
    } catch (e) {
      _handleAuthError(e, 'Error during password change');
      rethrow;
    }
  }

  void _handleAuthError(dynamic e, String contextMessage) {
    String errorMessage;

    if (e is FirebaseAuthException) {
      switch (e.code) {
        // Authentication Errors
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'weak-password':
          errorMessage = 'Password must be at least 6 characters.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Try again later.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;

        // Password Reset
        case 'expired-action-code':
          errorMessage = 'Password reset link has expired.';
          break;
        case 'invalid-action-code':
          errorMessage = 'Invalid password reset link.';
          break;

        // Reauthentication
        case 'requires-recent-login':
          errorMessage = 'Please log in again to perform this action.';
          break;

        // Custom Errors
        case 'user-data-not-found':
          errorMessage = 'Account data missing. Please contact support.';
          break;
        case 'same-password':
          errorMessage = 'New password must be different.';
          break;

        // General
        default:
          errorMessage =
              'Authentication error: ${e.message ?? 'Unknown error'}';
      }
    } else {
      errorMessage = 'An unexpected error occurred. Please try again.';
    }

    AppUtils.showSnackBar(
      title: 'Error',
      message: errorMessage,
      isError: true,
    );

    // Log detailed error for debugging
    debugPrint('$contextMessage: ${e.toString()}');
  }
}
