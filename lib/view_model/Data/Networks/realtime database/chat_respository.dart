import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ourtalks/view_model/Models/chat_modal.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class ChatRespository {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final User _currentUser = _auth.currentUser!;

  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  static final _event = _firebaseDatabase.ref("chats");

  // *******************
  static DatabaseReference getConversationID(String id, String folder) =>
      _currentUser.uid.hashCode <= id.hashCode
          ? _event.child("${_currentUser.uid}_$id/$folder")
          : _event.child("${id}_${_currentUser.uid}/$folder");

  static Future<void> sendMessage(
      ChatRomModel chatModel, UserModel userModel) async {
    try {
      final ref = getConversationID(userModel.userID!, "messages");
      debugPrint("Writing to path: ${ref.path}");
      await ref.set(chatModel.toJson());
      debugPrint("Message sent successfully!");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static getAllMessages(UserModel user) {
    try {
      final data = getConversationID(user.userID!, "messages");
      debugPrint("Reading from path: ${data.ref.path}");

      data.onValue.listen((event) {
        if (event.snapshot.exists) {
          debugPrint("Raw message data: ${event.snapshot.value}");
          debugPrint("Data type: ${event.snapshot.value.runtimeType}");
        } else {
          debugPrint("No messages found!");
        }
      });

      return data;
    } catch (e) {
      debugPrint("Error getting messages query: $e");
      rethrow;
    }
  }
}
