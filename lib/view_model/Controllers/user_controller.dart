import 'package:get/get.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  UserModel? get alluser => _user.value;

  void setUser(UserModel model) {
    _user.value = model;
    update();
  }
}
