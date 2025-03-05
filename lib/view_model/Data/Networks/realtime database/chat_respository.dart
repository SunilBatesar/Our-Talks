import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ourtalks/view_model/Models/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatRespository {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final User _currentUser = _auth.currentUser!;

  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  static final _event = _firebaseDatabase.ref("chats");

  // *******************
//   static DatabaseReference getConversationID(String id, String folder) =>
//       _currentUser.uid.hashCode <= id.hashCode
//           ? _event.child("${_currentUser.uid}_$id/$folder")
//           : _event.child("${id}_${_currentUser.uid}/$folder");

//   static Future<void> sendMessage(
//       ChatRomModel chatModel, UserModel userModel) async {
//     try {
//       final ref = getConversationID(userModel.userID!, "messages");
//       debugPrint("Writing to path: ${ref.path}");
//       await ref.set(chatModel.toJson());
//       debugPrint("Message sent successfully!");
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   static getAllMessages(UserModel user) {
//     try {
//       final data = getConversationID(user.userID!, "messages");
//       debugPrint("Reading from path: ${data.ref.path}");

//       data.onValue.listen((event) {
//         if (event.snapshot.exists) {
//           debugPrint("Raw message data: ${event.snapshot.value}");
//           debugPrint("Data type: ${event.snapshot.value.runtimeType}");
//         } else {
//           debugPrint("No messages found!");
//         }
//       });

//       return data;
//     } catch (e) {
//       debugPrint("Error getting messages query: $e");
//       rethrow;
//     }
//   }
// }

  static DatabaseReference getConversationID(
      String otherUserId, String folder) {
    // Sort user IDs lexicographically for consistent room IDs
    final sortedIds = [_currentUser.uid, otherUserId]..sort();
    return _event.child("${sortedIds[0]}_${sortedIds[1]}/$folder");
  }

  static Future<void> sendMessage({
    required String text,
    required String receiverId,
    required UserModel userModel,
  }) async {
    try {
      // Create proper message reference
      final messagesRef = getConversationID(receiverId, "messages");

      // Create new message
      final newMessage = types.TextMessage(
        author: types.User(id: _currentUser.uid),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: text,
        // type: "text",
      );

      // Push to new child node
      await messagesRef.push().set(newMessage.toJson());

      debugPrint("Message sent successfully!");
    } catch (e) {
      debugPrint("Error sending message: $e");
      rethrow;
    }
  }
}
