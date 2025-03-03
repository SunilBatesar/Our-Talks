// user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/view_model/Apis/firebase_apis.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

abstract class UserData {
  Future<UserModel> getUserById(String userId);
  Future<void> updateUser(String userId, UserModel user);
  Future<void> updateUserKeyData(String userId, String key, dynamic value);
}

class UserRepository implements UserData {
  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final userDoc = await FirebaseApis.userDocumentRef(userId).get();
      if (userDoc.exists) {
        return UserModel.fromJson(
            userDoc.data() as Map<String, dynamic>, userDoc.id);
      } else {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'not-found',
          message: 'User document not found',
        );
      }
    } on FirebaseException catch (e) {
      _handleFirestoreError(e, 'Error fetching user data');
      rethrow;
    } catch (e) {
      debugPrint("Generic error: $e");
      rethrow;
    }
  }

  @override
  Future<void> updateUser(String userId, UserModel model) async {
    try {
      await FirebaseApis.userDocumentRef(userId).update(model.toJson());
    } on FirebaseException catch (e) {
      _handleFirestoreError(e, 'Error updating user data');
      rethrow;
    } catch (e) {
      debugPrint("Generic error: $e");
      rethrow;
    }
  }

  @override
  Future<void> updateUserKeyData(String userId, String key, value) async {
    try {
      await FirebaseApis.userDocumentRef(userId).update({key: value});
    } on FirebaseException catch (e) {
      _handleFirestoreError(e, 'Error updating user data');
      rethrow;
    } catch (e) {
      debugPrint("Generic error: $e");
      rethrow;
    }
  }

  void _handleFirestoreError(FirebaseException e, String contextMessage) {
    String errorMessage;

    switch (e.code) {
      case 'permission-denied':
        errorMessage = 'You don\'t have permission to perform this action';
        break;
      case 'not-found':
        errorMessage = 'Requested document not found';
        break;
      case 'unavailable':
        errorMessage = 'Network unavailable. Please check your connection';
        break;
      case 'aborted':
        errorMessage = 'Operation aborted';
        break;
      case 'already-exists':
        errorMessage = 'Document already exists';
        break;
      case 'data-loss':
        errorMessage = 'Data loss error';
        break;
      case 'deadline-exceeded':
        errorMessage = 'Operation timed out';
        break;
      default:
        errorMessage = 'Database error: ${e.message ?? 'Unknown error'}';
    }

    AppUtils.showSnackBar(
      title: 'Database Error',
      message: errorMessage,
      isError: true,
    );

    debugPrint('$contextMessage: ${e.toString()}');
  }
}
