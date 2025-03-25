import 'package:ourtalks/view_model/Models/user_model.dart';

class FriendModel {
  String? id;
  String? messagetime;
  String? message;
  UserModel users;
  RealTimeUserModel? isOnlineData;
  FriendModel(
      {this.id,
      this.messagetime,
      this.message,
      required this.users,
      this.isOnlineData});

  FriendModel copyWith({
    String? id,
    String? messagetime,
    String? message,
    String? messagetype,
    UserModel? users,
    RealTimeUserModel? isOnlineData,
  }) {
    return FriendModel(
      id: id ?? this.id,
      messagetime: messagetime ?? this.messagetime,
      message: message ?? this.message,
      users: users ?? this.users,
      isOnlineData: isOnlineData ?? this.isOnlineData,
    );
  }
}
