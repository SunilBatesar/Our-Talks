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
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Data/Networks/realtime%20database/chat_respository.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final UserModel usermodel;
  const ChatScreen({super.key, required this.usermodel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final _user = types.User(id: Prefs.getUserIdPref());
  final _messagesRef = ChatRespository.getConversationID;

  @override
  void initState() {
    super.initState();
    _setupMessageListener();
  }

  void _setupMessageListener() {
    _messagesRef(widget.usermodel.userID.toString(), "messages")
        .orderByChild("createdAt")
        .limitToLast(10)
        .onChildAdded
        .listen((event) {
      _handleNewMessage(event.snapshot.value);
    });
  }

  /// Processes incoming message data
  void _handleNewMessage(dynamic messageData) {
    if (messageData == null) return;

    try {
      final convertedData = _convertFirebaseData(messageData);
      final message = _parseMessage(convertedData);
      if (message != null) {
        setState(() {
          _messages.insert(0, message);
        });
      }
    } catch (e, stackTrace) {
      debugPrint("Error processing message: $e\n$stackTrace");
    }
  }

  /// Converts Firebase's dynamic map to properly typed map
  Map<String, dynamic> _convertFirebaseData(dynamic data) {
    if (data is! Map<dynamic, dynamic>) {
      throw const FormatException('Invalid message format');
    }

    final converted = <String, dynamic>{};
    data.forEach((key, value) {
      converted[key.toString()] =
          value is Map ? _convertFirebaseData(value) : value;
    });
    return converted;
  }

  types.Message? _parseMessage(Map<String, dynamic> json) {
    try {
      // Handle potential null values
      json['createdAt'] ??= DateTime.now().millisecondsSinceEpoch;
      json['id'] ??= const Uuid().v4();

      // Ensure author is properly formatted
      if (json['author'] is Map) {
        json['author'] =
            _convertFirebaseData(json['author'] as Map<dynamic, dynamic>);
      }

      switch (json['type']) {
        case 'text':
          return types.TextMessage.fromJson(json);
        default:
          return null;
      }
    } catch (e, stackTrace) {
      debugPrint("Error parsing message: $e");
      debugPrint("Stack trace: $stackTrace");
      debugPrint("Problematic JSON: $json");
      return null;
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    ChatRespository.sendMessage(
      text: textMessage.text,
      receiverId: widget.usermodel.userID.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 30.sp,
          leading: IconButton(
            onPressed: Get.back,
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 24.sp,
              color: cnstSheet.colors.primary,
            ),
          ),
          title: GestureDetector(
            onTap: () =>
                Get.to(() => ProfileViewScreen(model: widget.usermodel)),
            child: Row(
              children: [
                _buildUserAvatar(),
                Gap(5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.usermodel.name,
                      style: cnstSheet.textTheme.fs18Medium
                          .copyWith(color: cnstSheet.colors.white),
                    ),
                    Text(
                      widget.usermodel.lastActive,
                      style: cnstSheet.textTheme.fs12Normal.copyWith(
                          color: cnstSheet.colors.white.withAlpha(150)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          customDateHeaderText: (date) => AppFunctions.formatChatTime(date),
          theme: DefaultChatTheme(
            backgroundColor: cnstSheet.colors.black,
            // Message text colors
            receivedMessageBodyTextStyle: TextStyle(
              color: cnstSheet.colors.black, // Text color for received messages
              fontSize: 16.sp,
            ),
            sentMessageBodyTextStyle: TextStyle(
              color: cnstSheet.colors.black, // Text color for sent messages
              fontSize: 16.sp,
            ),
            // Input decoration
            inputBorderRadius: BorderRadius.circular(10.r),
            inputContainerDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border:
                  Border.all(color: cnstSheet.colors.primary.withAlpha(180)),
            ),
            inputTextStyle: cnstSheet.textTheme.fs16Medium,
            inputBackgroundColor: cnstSheet.colors.gray.withAlpha(120),
            inputMargin: EdgeInsets.all(8.sp),
            inputTextCursorColor: cnstSheet.colors.primary,
            // Bubble colors
            primaryColor: cnstSheet.colors.primary, // Sent message bubble color
            secondaryColor:
                cnstSheet.colors.white, // Received message bubble color
            // Additional text styles
            // receivedMessageCaptionTextStyle: TextStyle(
            //   color: cnstSheet.colors.black.withOpacity(0.5),
            // ),
            // sentMessageCaptionTextStyle: TextStyle(
            //   color: cnstSheet.colors.white.withOpacity(0.5),
            // ),
          ),
        ));
  }

  Widget _buildUserAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000.sp),
      child: CachedNetworkImage(
        imageUrl: widget.usermodel.userDP!,
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
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
