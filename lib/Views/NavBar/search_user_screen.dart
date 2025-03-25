import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Components/TextFields/search_textfield.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Views/NavBar/Home/Widgets/user_message_tile.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/Cloud%20firestore/user_datahendler.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/Cloud%20firestore/user_repository.dart';
import 'package:ourtalks/view_model/Models/friend_model.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final _userController = Get.find<UserController>();

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<String>? serachuserlist = _userController.user!.serachuserlist;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Image.asset(
                cnstSheet.images.talk,
                fit: BoxFit.cover,
                color: cnstSheet.colors.primary.withAlpha(150),
                width: cnstSheet.services.screenWidth(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Column(
                children: [
                  SearchTextField(
                    controller: _searchController,
                    iconOnTap: () async {
                      if (_searchController.text.isNotEmpty) {
                        await UserDataHandler.addserchlist(
                            _userController.user!.userID!,
                            _searchController.text.trim());
                        setState(() {
                          _searchController.clear();
                        });
                      }
                    },
                  ),
                  Gap(10.h),
                  HeadingText2(
                    text: LanguageConst.bettertypeUserNotFound.tr,
                    textColor: cnstSheet.colors.white.withAlpha(150),
                  ),
                  Gap(10.h),
                  serachuserlist != null && serachuserlist.isNotEmpty
                      ? Expanded(
                          child: FutureBuilder<List<UserModel>>(
                            future: UserRepository()
                                .fetchsearchListId(serachuserlist),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return SizedBox();
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final user = snapshot.data![index];
                                  return UserMessageTile(
                                    onTap: () {},
                                    trailingIcon: Icons.message,
                                    model: FriendModel(users: user),
                                  ).marginOnly(bottom: 15.h);
                                },
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
