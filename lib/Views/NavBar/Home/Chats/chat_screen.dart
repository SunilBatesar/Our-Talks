import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class ChatScreen extends StatelessWidget {
  final UserModel model;
  ChatScreen({super.key, required this.model});
  final _user = types.User(id: "1234567");
  final List<types.Message> _messages = [];
  @override
  Widget build(BuildContext context) {
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
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000.sp),
              child: CachedNetworkImage(
                imageUrl: model.userDP!,
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
                  model.name,
                  style: cnstSheet.textTheme.fs18Medium
                      .copyWith(color: cnstSheet.colors.white),
                ),
                Text(
                  model.lastActive,
                  style: cnstSheet.textTheme.fs12Normal
                      .copyWith(color: cnstSheet.colors.white.withAlpha(150)),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Chat(
        messages: _messages, //message ki list show krna ni hai
        onSendPressed: _handleSendPressed, // message send krn ka function
        user: _user, // current user ki id
        //===========STYLING================

        theme: DefaultChatTheme(
          backgroundColor: cnstSheet.colors.black,
          inputBorderRadius: BorderRadius.circular(10.r),
          inputContainerDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border:
                  Border.all(color: cnstSheet.colors.primary.withAlpha(180))),
          inputTextStyle: cnstSheet.textTheme.fs16Medium,
          inputBackgroundColor: cnstSheet.colors.gray.withAlpha(120),
          inputMargin: EdgeInsets.all(8.sp),
          inputTextCursorColor: cnstSheet.colors.primary,
        ),
      ),
    );
  }

  // jesa bhi message krna ho es ka use krna hai jese text ,image,audio;
  void _handleSendPressed(types.PartialText message) {
    //*********/ Yani ki ye textMessage jaye ga Firebase pr okay ****************
    final textMessage = types.TextMessage(
      author: _user, // current user id jo message send kr rha hai
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: "123456", // message ki id add krni hai
      text: message
          .text, // jo bhi message hoga jese String Url ya kuch bhi vo es me String rup me save hoga
    );
  }
}
