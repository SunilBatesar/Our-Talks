import 'package:get/get.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class UserController extends GetxController {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel model) {
    _user = model;
    update();
  }

  void clearUser() {
    _user = null;
    update();
  }

  void updateUser(UserModel model) {
    if (_user != null && _user!.userID == model.userID) {
      _user = model;
      update();
    }
  }

  void updateSingleKey(String key, dynamic value) {
    if (_user != null) {
      _user = _user!.copyWith(
        userName: key == 'userName' ? value : _user!.userName,
        name: key == 'name' ? value : _user!.name,
        createdAt: key == 'createdAt' ? value : _user!.createdAt,
        lastActive: key == 'lastActive' ? value : _user!.lastActive,
        email: key == 'email' ? value : _user!.email,
        userDP: key == 'userDP' ? value : _user!.userDP,
        banner: key == 'banner' ? value : _user!.banner,
        about: key == 'about' ? value : _user!.about,
        pushToken: key == 'pushToken' ? value : _user!.pushToken,
        isOnline: key == 'isOnline' ? value : _user!.isOnline,
        pravacy: key == 'pravacy' ? value : _user!.pravacy,
        friends: key == 'friends' ? value : _user!.friends,
        chatroom: key == 'chatroom' ? value : _user!.chatroom,
        serachuserlist: key == 'serachuserlist' ? value : _user!.serachuserlist,
        dob: key == 'dob' ? value : _user!.dob,
        gender: key == 'gender' ? value : _user!.gender,
        blockedUsers: key == 'blockedUsers' ? value : _user!.blockedUsers,
      );
      update();
    }
  }
}
