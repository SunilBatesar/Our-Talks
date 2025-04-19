import 'package:ourtalks/Utils/Enums/app_enums.dart';

class ChatRoomInfoModel {
  String roomId;
  ChatRoomType chatRoomType;
  List<ChatRoomUserModel> users;
  String? roomName;
  String? about;
  String? createdAt;
  String? updatedAt;

  ChatRoomInfoModel({
    required this.roomId,
    required this.users,
    required this.chatRoomType,
    this.roomName,
    this.about,
    this.createdAt,
    this.updatedAt,
  });

  ChatRoomInfoModel.fromMap(Map<String, dynamic> json)
      : roomId = json["roomId"] ?? "",
        users = ((json["users"] ?? {}) as List)
            .map((e) => ChatRoomUserModel.fromJson(e))
            .toList(),
        chatRoomType = ChatRoomType.values.firstWhere(
            (e) => e == (json["chatRoomType"] ?? ChatRoomType.SINGLECHAT),
            orElse: () => ChatRoomType.SINGLECHAT),
        roomName = json["roomName"] ?? "",
        about = json["about"] ?? "",
        createdAt = json["createdAt"] ?? "",
        updatedAt = json["updatedAt"] ?? "";

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'users': users.map((e) => e.toMap()),
      'chatRoomType': (chatRoomType ?? ChatRoomType.SINGLECHAT).name,
      'roomName': roomName,
      'about': about,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

// CHAT ROOM USER MODEL
class ChatRoomUserModel {
  String? id;
  String? name;
  bool isTyping;
  bool isUserOnScreen;
  ChatRoomUserModel({
    this.id,
    this.name,
    this.isTyping = false,
    this.isUserOnScreen = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "isTyping": isTyping,
      "isUserOnScreen": isUserOnScreen,
    };
  }

  ChatRoomUserModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] ?? "",
        name = json["name"] ?? "",
        isTyping = json["isTyping"] ?? false,
        isUserOnScreen = json["isUserOnScreen"] ?? false;

  ChatRoomUserModel copyWith({
    String? id,
    String? name,
    bool? isTyping,
    bool? isUserOnScreen,
  }) {
    return ChatRoomUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isTyping: isTyping ?? this.isTyping,
      isUserOnScreen: isUserOnScreen ?? this.isUserOnScreen,
    );
  }
}
