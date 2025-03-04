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
  Future<List<String>?> addserchlist(String userid, String userName);
  Future<List<UserModel>> fetchsearchListId(List<String> userIds);
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
  Future<void> updateUserKeyData(
      String userId, String key, dynamic value) async {
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

  @override
  Future<List<String>> addserchlist(String userId, String searchQuery) async {
    try {
      // Check if friend exists with exact username match
      final friendQuery = await FirebaseApis.userCollectionRef
          .where(Filter.or(
              Filter('userName', isEqualTo: searchQuery.trim().toLowerCase()),
              Filter('email', isEqualTo: searchQuery.trim().toLowerCase())))
          .limit(1)
          .get();

      if (friendQuery.docs.isEmpty) {
        throw FirebaseException(
            plugin: 'user-not-found', message: 'Requested user does not exist');
      }

      final friendDoc = friendQuery.docs.first;
      final friendId = friendDoc.id;

      if (friendId == userId) {
        throw FirebaseException(
            plugin: 'invalid-operation',
            message: 'Cannot add yourself as a friend');
      }

      // Atomically add to chatroom list using arrayUnion
      await FirebaseApis.userDocumentRef(userId).update({
        'serachuserlist': FieldValue.arrayUnion([friendId])
      });

      // Return updated list by fetching fresh data
      final updatedDoc = await FirebaseApis.userDocumentRef(userId).get();
      return List<String>.from(updatedDoc.get('serachuserlist') ?? []);
    } on FirebaseException catch (e) {
      _handleFirestoreError(e, 'Friend addition failed');
      rethrow;
    } catch (e) {
      debugPrint("Error in addChatUserPersonal: ${e.runtimeType}");
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> fetchsearchListId(List<String> userIds) async {
    List<UserModel> users = [];
    try {
      for (var userId in userIds) {
        var userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          users.add(UserModel.fromJson(userDoc.data()!, userDoc.id));
        }
      }
      return users;
    } on FirebaseException catch (e) {
      _handleFirestoreError(e, 'Friend addition failed');
      // return [];
      rethrow;
    } catch (e) {
      debugPrint("Error in addChatUserPersonal: ${e.runtimeType}");
      // return [];
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
