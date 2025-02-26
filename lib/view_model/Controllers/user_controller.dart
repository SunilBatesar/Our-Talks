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
}
