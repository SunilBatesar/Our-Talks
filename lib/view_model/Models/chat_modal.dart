// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// class ChatRomModel {
//   String? roomId;
//   String? toUser;
//   String? fromUser;
//   bool? isTyping;
//   List<types.Message>? messages;

//   ChatRomModel({
//     this.roomId,
//     this.toUser,
//     this.fromUser,
//     this.isTyping = false,
//     this.messages,
//   });

//   ChatRomModel.fromJson(Map<dynamic, dynamic> json, this.roomId)
//       : toUser = json['toUser'] as String?,
//         fromUser = json['fromUser'] as String?,
//         isTyping = json['isTyping'] as bool? ?? false,
//         messages = json['messages'] != null
//             ? (json['messages'] as List).map((e) {
//                 final messageMap =
//                     (e as Map<dynamic, dynamic>).cast<String, dynamic>();
//                 // Check if the message is of type "text"
//                 if (messageMap['type'] == 'text') {
//                   return types.TextMessage.fromJson(messageMap);
//                 }
//                 // Handle other message types here (e.g., image, file)
//                 return types.Message.fromJson(messageMap);
//               }).toList()
//             : [];

//   Map<String, dynamic> toJson() {
//     return {
//       "roomId": roomId ?? "",
//       "toUser": toUser ?? "",
//       "fromUser": fromUser ?? "",
//       "isTyping": isTyping,
//       "messages":
//           messages != null ? messages!.map((e) => e.toJson()).toList() : [],
//     };
//   }

//   ChatRomModel copyWith({
//     String? roomId,
//     String? toUser,
//     String? fromUser,
//     bool? isTyping,
//     List<types.Message>? messages,
//   }) {
//     return ChatRomModel(
//       roomId: roomId ?? this.roomId,
//       toUser: toUser ?? this.toUser,
//       fromUser: fromUser ?? this.fromUser,
//       isTyping: isTyping ?? this.isTyping,
//       messages: messages ?? this.messages,
//     );
//   }
// }
class ChatRoomModel {
  final String roomId;
  final String user1;
  final String user2;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String?
      roomStatus; // Optional: For room status like 'active', 'inactive'
  final String? lastMessage; // Optional: Last message sent in the room

  ChatRoomModel({
    required this.roomId,
    required this.user1,
    required this.user2,
    required this.createdAt,
    required this.updatedAt,
    this.roomStatus,
    this.lastMessage,
  });

  // Factory constructor to create an instance from a map (e.g., for parsing JSON)
  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      roomId: map['roomId'],
      user1: map['user1'],
      user2: map['user2'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      roomStatus: map['roomStatus'],
      lastMessage: map['lastMessage'],
    );
  }

  // Method to convert the instance to a map (e.g., for sending data to a server or database)
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'user1': user1,
      'user2': user2,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'roomStatus': roomStatus,
      'lastMessage': lastMessage,
    };
  }
}
