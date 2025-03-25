import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ourtalks/view_model/Apis/firebase_apis.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Data/Networks/realtime%20database/chat_respository.dart';
import 'package:ourtalks/view_model/Models/friend_model.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class FriendController extends GetxController {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  // RxBool iswidgetBuild = false.obs;

  final RxList<UserModel> _friendsData = <UserModel>[].obs;
  List<UserModel> get friendsData => _friendsData;

  final RxList<FriendModel> _sortedUsers = <FriendModel>[].obs;
  List<FriendModel> get sortedUsers => _sortedUsers;

  void updatesortedUsersData(List<FriendModel> data) {
    _sortedUsers.value = data;
    // print((data.first["user"] as UserModel).name);
  }

  final RxBool _isUpdateUsersStatus = true.obs;
  RxBool get isUpdateUsersStatus => _isUpdateUsersStatus;
  void updateisUpdateUsersStatus(bool value) {
    _isUpdateUsersStatus.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    _friendsData.value = [];
    _sortedUsers.value = [];
    updateisUpdateUsersStatus(true);
    _handleData();
  }

  void _handleData() async {
    await fetchChatRooms();
    // await sortedUsersData();
  }

  Future<void> fetchChatRooms() async {
    final usercontroller = Get.find<UserController>();
    final String currentUser = usercontroller.user!.userID!;
    try {
      FirebaseApis.userDocumentRef(currentUser)
          .collection("my_chatroom")
          .snapshots()
          .listen(
        (QuerySnapshot snapshot) async {
          final userIds = snapshot.docs.map((e) => e.id).toList();

          if (userIds.isNotEmpty) {
            final usersData = await FirebaseApis.userCollectionRef
                .where(FieldPath.documentId, whereIn: userIds)
                .get();
            final db = usersData.docs
                .map((e) =>
                    UserModel.fromJson(e.data() as Map<String, dynamic>, e.id))
                .toList();
            _friendsData.clear();
            _friendsData.value = db;

            // for (var data in db) {
            //   // await DatabaseHelper().insertFriend(data);
            //   iswidgetBuild.value = true;
            // }
            // iswidgetBuild.value = false;
            await sortedUsersData(db);
          }
        },
      );
    } catch (e) {
      debugPrint("fetchChatRooms Function Set Error => $e");
    }
  }

  Future<void> sortedUsersData(List<UserModel> model) async {
    if (model.isEmpty) return;

    for (var user in model) {
      // TIME AND LAST MESSAGE
      ChatRespository.getLastMsg(user.userID!).listen((event) {
        final index = _sortedUsers.indexWhere((e) => e.id == user.userID);
        final lastMessageTime = event.snapshot.value != null
            ? AppFunctions.convertFirebaseData(event.snapshot.value)
                .values
                .first['createdAt']
                .toString()
            : "0";

        final message = event.snapshot.value != null
            ? AppFunctions.convertFirebaseData(event.snapshot.value)
                .values
                .first['text']
                .toString()
            : "Media message";

        final data = FriendModel(
          id: user.userID,
          messagetime: lastMessageTime,
          message: message,
          users: user,
        );

        if (index >= 0) {
          _sortedUsers[index] = data;
        } else {
          _sortedUsers.add(data);
        }

        _sortedUsers.sort((a, b) =>
            int.parse(b.messagetime!).compareTo(int.parse(a.messagetime!)));
        update();
      });
    }
  }

  void getUserStatus() {
    if (_sortedUsers.isEmpty) return;
    final userData = _firebaseDatabase.ref("user_data");
    for (var user in _sortedUsers) {
      userData.child(user.users.userID!).onValue.listen((event) {
        final index = _sortedUsers.indexWhere((e) => e.id == user.users.userID);
        if (event.snapshot.value != null) {
          final response =
              AppFunctions.convertFirebaseData(event.snapshot.value);
          final data = RealTimeUserModel.fromJson(response);
          if (index >= 0) {
            _sortedUsers[index] =
                _sortedUsers[index].copyWith(isOnlineData: data);
            update();
          }
        }
      });
    }
  }

  // static Future<List<UserModel>> getFriendsInLocal() async {
  //   final db = await DatabaseHelper().getFriends();
  //   if (db.isEmpty) return [];
  //   return db;
  // }
}
