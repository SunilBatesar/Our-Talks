import 'package:ourtalks/view_model/Models/user_model.dart';

class FriendModel {
  String? id;
  String? messagetime;
  String? message;
  UserModel user;
  RealTimeUserModel? isOnlineData;
  FriendModel(
      {this.id,
      this.messagetime,
      this.message,
      required this.user,
      this.isOnlineData});

  FriendModel copyWith({
    String? id,
    String? messagetime,
    String? message,
    String? messagetype,
    UserModel? user,
    RealTimeUserModel? isOnlineData,
  }) {
    return FriendModel(
      id: id ?? this.id,
      messagetime: messagetime ?? this.messagetime,
      message: message ?? this.message,
      user: user ?? this.user,
      isOnlineData: isOnlineData ?? this.isOnlineData,
    );
  }
}
