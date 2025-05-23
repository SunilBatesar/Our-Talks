import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:ourtalks/view_model/Apis/firebase_apis.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatRespository {
  // static final FirebaseAuth _auth = FirebaseAuth.instance

  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  static final _event = _firebaseDatabase.ref("chats");
  static final _userData = _firebaseDatabase.ref("user_data");

  static setUserData(
      {required String userId, required RealTimeUserModel model}) async {
    try {
      await _userData.child(userId).set(model.toJson());
    } catch (e) {
      debugPrint("Error Add User Data to Realtime: $e");
      rethrow;
    }
  }

  //CHAKE UPDATE USER ISONLINE VALUE
  static Future<void> userOnlineValueUpdate(
      {required String userId, required bool value}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) return;
    final db = _userData.child(userId);
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      if (value) {
        await db
            .update(RealTimeUserModel(isOnline: value).toJsonOnlyOnlineValue());
      } else {
        await db.update(
            RealTimeUserModel(isOnline: value, lastSeen: time).toJson());
      }
    } catch (e) {
      debugPrint("Error Update User Online Value Realtime: $e");
      rethrow;
    }
  }

  static Future<RealTimeUserModel?> getUserOnlineData(
      {required String userId}) async {
    RealTimeUserModel? data;
    try {
      _userData.child(userId).onValue.listen(
        (event) {
          if (event.snapshot.value != null) {
            final response =
                AppFunctions.convertFirebaseData(event.snapshot.value);
            data = RealTimeUserModel.fromJson(response);
          }
        },
      );
    } catch (e) {
      debugPrint("Error Get User Online Data Realtime: $e");
    }
    return data;
  }
  // ------------------------------------------------------------

  // ------------------------------------------------------------

  // *******************

  static DatabaseReference getConversationID(
      String otherUserId, String folder) {
    final usercontroller = Get.find<UserController>();
    final String currentUser = usercontroller.user!.userID!;
    // Sort user IDs lexicographically for consistent room IDs
    final sortedIds = [currentUser, otherUserId]..sort();
    return _event.child("${sortedIds[0]}_${sortedIds[1]}/$folder");
  }

// ********
  static Future<void> sendMessage({
    required String text,
    required String receiverId,
    required Map<String, dynamic> metadata,
  }) async {
    final usercontroller = Get.find<UserController>();
    final String currentUser = usercontroller.user!.userID!;
    try {
      // Create proper message reference
      final messagesRef = getConversationID(receiverId, "messages");
      final messageId = const Uuid().v4();
      // Create new message
      final newMessage = types.TextMessage(
        author: types.User(id: currentUser),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: messageId,
        text: text,
        metadata: metadata,
        // type: "text",
      ).toJson();

      // Push to new child node
      await messagesRef.child(messageId).set(newMessage);

      debugPrint("Message sent successfully!");
    } catch (e) {
      debugPrint("Error sending message: $e");
      rethrow;
    }
  }

  static Future<List<DocumentSnapshot>> getMyChatroomUser() async {
    final usercontroller = Get.find<UserController>();
    final String currentUser = usercontroller.user!.userID!;
    try {
      final chatroomSnapshot = await FirebaseApis.userDocumentRef(currentUser)
          .collection("my_chatroom")
          .get();

      final usersIDs = chatroomSnapshot.docs.map((doc) => doc.id).toList();

      if (usersIDs.isEmpty) return [];

      final usersSnapshot = await FirebaseApis.userCollectionRef
          .where(FieldPath.documentId, whereIn: usersIDs)
          .get();

      return usersSnapshot.docs;
    } catch (e) {
      debugPrint("Error fetching chatroom users: $e");
      return [];
    }
  }

  // *****************FIRST MESSAGE
  static Future<void> sendFirstMessage({
    required String text,
    required String receiverId,
    required Map<String, dynamic> metadata,
  }) async {
    final usercontroller = Get.find<UserController>();
    final String currentUser = usercontroller.user!.userID!;
    try {
      final userDoc = await FirebaseApis.userDocumentRef(currentUser)
          .collection("my_chatroom")
          .doc(receiverId)
          .get();

      if (!userDoc.exists) {
        // Add receiver to the current user's "my_chatroom"
        FirebaseApis.userDocumentRef(currentUser)
            .collection("my_chatroom")
            .doc(receiverId)
            .set({});

        // Also add current user to receiver's "my_chatroom"
        FirebaseApis.userDocumentRef(receiverId)
            .collection("my_chatroom")
            .doc(currentUser)
            .set({});
      }

      // Now send the message
      await sendMessage(text: text, receiverId: receiverId, metadata: metadata);
    } catch (e) {
      debugPrint("Error sending first message: $e");
      rethrow;
    }
  }

  static Future<void> updateMessageStatus({
    required String receiverId,
    required String messageId,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final messageRef = getConversationID(receiverId, 'messages')
          .child(messageId)
          .child('metadata');

      await messageRef.update(metadata);
    } catch (e) {
      debugPrint('Error updating message status: $e');
      rethrow;
    }
  }

  // **************************
  static Future<void> sendImageMessage({
    required String imageUrl,
    required String receiverId,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final usercontroller = Get.find<UserController>();
      final String currentUser = usercontroller.user!.userID!;
      final messagesRef = getConversationID(receiverId, "messages");
      final messageId = const Uuid().v4();

      final newMessage = types.ImageMessage(
        author: types.User(id: currentUser),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: messageId,
        name: 'image',
        size: 0,
        uri: imageUrl,
        metadata: metadata,
      ).toJson();

      await messagesRef.child(messageId).set(newMessage);
    } catch (e) {
      debugPrint("Error sending image message: $e");
      rethrow;
    }
  }

  // SEND FIRST IMAGE
  static Future<void> sendFirstImageMessage({
    required String imageUrl,
    required String receiverId,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final usercontroller = Get.find<UserController>();
      final String currentUser = usercontroller.user!.userID!;
      final userDoc = await FirebaseApis.userDocumentRef(currentUser)
          .collection("my_chatroom")
          .doc(receiverId)
          .get();

      if (!userDoc.exists) {
        await FirebaseApis.userDocumentRef(currentUser)
            .collection("my_chatroom")
            .doc(receiverId)
            .set({});

        await FirebaseApis.userDocumentRef(receiverId)
            .collection("my_chatroom")
            .doc(currentUser)
            .set({});
      }

      await sendImageMessage(
        imageUrl: imageUrl,
        receiverId: receiverId,
        metadata: metadata,
      );
    } catch (e) {
      debugPrint("Error sending first image message: $e");
      rethrow;
    }
  }

  static Future<void> updateMessage({
    required String receiverId,
    required String messageId,
    required String newText,
  }) async {
    final ref = getConversationID(receiverId, "messages").child(messageId);
    await ref.update({'text': newText});
  }

  static Future<void> deleteMessage({
    required String receiverId,
    required String messageId,
  }) async {
    final ref = getConversationID(receiverId, "messages").child(messageId);
    await ref.remove();
  }

  //  GET LAST MESSAGE
  static Stream<DatabaseEvent> getLastMsg(String userID) {
    final userData = getConversationID(userID, "messages");
    return userData.orderByChild("createdAt").limitToLast(1).onValue;
  }
}
