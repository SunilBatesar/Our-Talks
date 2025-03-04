import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRomModel {
  String? roomId;
  String? toUser;
  String? fromUser;
  bool? isTyping;
  List<types.Message>? messages;

  ChatRomModel({
    this.roomId,
    this.toUser,
    this.fromUser,
    this.isTyping = false,
    this.messages,
  });

  ChatRomModel.fromJson(Map<Object?, Object?> json, this.roomId)
      : toUser = json['toUser'] as String?,
        fromUser = json['fromUser'] as String?,
        isTyping = json['isTyping'] as bool? ?? false,
        messages = json['messages'] != null
            ? (json['messages'] as List)
                .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
                .toList()
            : [];

  Map<String, dynamic> toJson() {
    return {
      "roomId": roomId ?? "",
      "toUser": toUser ?? "",
      "fromUser": fromUser ?? "",
      "isTyping": isTyping,
      "messages":
          messages != null ? messages!.map((e) => e.toJson()).toList() : [],
    };
  }

  ChatRomModel copyWith({
    String? roomId,
    String? toUser,
    String? fromUser,
    bool? isTyping,
    List<types.Message>? messages,
  }) {
    return ChatRomModel(
      roomId: roomId ?? this.roomId,
      toUser: toUser ?? this.toUser,
      fromUser: fromUser ?? this.fromUser,
      isTyping: isTyping ?? this.isTyping,
      messages: messages ?? this.messages,
    );
  }
}
