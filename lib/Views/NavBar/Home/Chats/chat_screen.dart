import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/prefs/prefs.dart';
import 'package:ourtalks/Views/NavBar/Home/profile_view_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/Networks/realtime%20database/chat_respository.dart';
import 'package:ourtalks/view_model/Models/chat_modal.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

import 'package:firebase_database/ui/firebase_animated_list.dart';

class ChatScreen extends StatelessWidget {
  final UserModel usermodel;
  const ChatScreen({super.key, required this.usermodel});

  @override
  Widget build(BuildContext context) {
    final user = types.User(id: usermodel.userID.toString());
    final List<types.Message> messages = [];

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30.sp,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 24.sp,
              color: cnstSheet.colors.primary,
            )),
        title: GestureDetector(
          onTap: () {
            Get.to(() => ProfileViewScreen(model: usermodel));
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000.sp),
                child: CachedNetworkImage(
                  imageUrl: usermodel.userDP!,
                  height: 35.sp,
                  width: 35.sp,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                        height: 12.sp,
                        width: 12.sp,
                        child: CircularProgressIndicator(
                          color: cnstSheet.colors.white,
                          strokeWidth: 3,
                        )),
                  ),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
              Gap(5.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    usermodel.name,
                    style: cnstSheet.textTheme.fs18Medium
                        .copyWith(color: cnstSheet.colors.white),
                  ),
                  Text(
                    usermodel.lastActive,
                    style: cnstSheet.textTheme.fs12Normal
                        .copyWith(color: cnstSheet.colors.white.withAlpha(150)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: ChatRespository.getAllMessages(usermodel),
              itemBuilder: (context, snapshot, animation, index) {
                final data = ChatRomModel.fromJson(
                    snapshot.value! as Map<Object?, Object?>, snapshot.key);
                final newMessages = data.messages ?? [];

                messages.clear();
                messages.addAll(newMessages);

                return SizedBox
                    .shrink(); // We just update the message list here
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Chat(
              messages: messages,
              onSendPressed: _handleSendPressed,
              user: user,
              theme: DefaultChatTheme(
                backgroundColor: cnstSheet.colors.black,
                inputBorderRadius: BorderRadius.circular(10.r),
                inputContainerDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: cnstSheet.colors.primary.withAlpha(180))),
                inputTextStyle: cnstSheet.textTheme.fs16Medium,
                inputBackgroundColor: cnstSheet.colors.gray.withAlpha(120),
                inputMargin: EdgeInsets.all(8.sp),
                inputTextCursorColor: cnstSheet.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final textMessage = types.TextMessage(
      author: types.User(id: Prefs.getUserIdPref()),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: time,
      text: message.text,
    );

    ChatRespository.sendMessage(
        ChatRomModel(
            fromUser: usermodel.userID,
            messages: [textMessage],
            roomId: time,
            toUser: Prefs.getUserIdPref()),
        usermodel);
  }
}
