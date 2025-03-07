import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
  late types.User _user;
  final _messagesRef = ChatRespository.getConversationID;

  @override
  void initState() {
    super.initState();
    // ++
    _user = types.User(
        id: widget.usermodel.userID!,
        imageUrl: widget.usermodel.userDP,
        firstName: widget.usermodel.name);

    // *****
    _setupMessageListener();
    _markMessagesAsRead();
  }

  void _setupMessageListener() {
    _messagesRef(widget.usermodel.userID.toString(), "messages")
        .orderByChild("createdAt")
        .limitToLast(100)
        .onChildAdded
        .listen((event) {
      _handleNewMessage(event.snapshot.value);
    });

    _messagesRef(widget.usermodel.userID.toString(), "messages")
        .onChildChanged
        .listen((event) {
      _handleMessageUpdate(event.snapshot.value);
    });
  }

  void _handleNewMessage(dynamic messageData) {
    if (messageData == null) return;

    try {
      final convertedData = AppFunctions.convertFirebaseData(messageData);
      final message = _parseMessage(convertedData);
      if (message != null) {
        setState(() => _messages.insert(0, message));

        // Update status to delivered if message is from other user
        if (message.author.id != _user.id &&
            message.metadata?['status'] == 'sent') {
          _updateMessageStatus(
            message.id,
            {'status': 'delivered'},
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint("Error processing message: $e\n$stackTrace");
    }
  }

  void _handleMessageUpdate(dynamic messageData) {
    if (messageData == null) return;

    try {
      final convertedData = AppFunctions.convertFirebaseData(messageData);
      final message = _parseMessage(convertedData);
      if (message != null) {
        final index = _messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          setState(() => _messages[index] = message);
        }
      }
    } catch (e, stackTrace) {
      debugPrint("Error processing message update: $e\n$stackTrace");
    }
  }

  types.Message? _parseMessage(Map<String, dynamic> json) {
    try {
      json['createdAt'] ??= DateTime.now().millisecondsSinceEpoch;
      json['id'] ??= const Uuid().v4();

      if (json['author'] is Map) {
        json['author'] = AppFunctions.convertFirebaseData(json['author']);
      }

      switch (json['type']) {
        case 'text':
          return types.TextMessage.fromJson(json);
        default:
          return null;
      }
    } catch (e) {
      debugPrint("Error parsing message: $e");
      return null;
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
      metadata: {'status': 'sent'},
    );

    ChatRespository.sendFirstMessage(
      text: textMessage.text,
      receiverId: widget.usermodel.userID.toString(),
      metadata: textMessage.metadata!,
    );
  }

  Future<void> _updateMessageStatus(
    String messageId,
    Map<String, dynamic> metadata,
  ) async {
    await ChatRespository.updateMessageStatus(
      receiverId: widget.usermodel.userID.toString(),
      messageId: messageId,
      metadata: metadata,
    );
  }

  Future<void> _markMessagesAsRead() async {
    final messages = _messages.where((message) =>
        message.author.id != _user.id &&
        message.metadata?['status'] == 'delivered');

    for (final message in messages) {
      await _updateMessageStatus(
        message.id,
        {'status': 'read'},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30.w,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 24.sp,
            color: cnstSheet.colors.primary,
          ),
        ),
        title: GestureDetector(
          onTap: () => Get.to(() => ProfileViewScreen(model: widget.usermodel)),
          child: Row(
            children: [
              ClipRRect(
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
              ),
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
                    style: cnstSheet.textTheme.fs12Normal
                        .copyWith(color: cnstSheet.colors.white.withAlpha(150)),
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
        bubbleBuilder: _buildBubble,
        customDateHeaderText: (date) => AppFunctions.formatChatTime(date),
        theme: DefaultChatTheme(
          backgroundColor: cnstSheet.colors.black,
          receivedMessageBodyTextStyle: TextStyle(
            color: cnstSheet.colors.black,
            fontSize: 16.sp,
          ),
          sentMessageBodyTextStyle: TextStyle(
            color: cnstSheet.colors.black,
            fontSize: 16.sp,
          ),
          inputBorderRadius: BorderRadius.circular(10.r),
          inputContainerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: cnstSheet.colors.primary.withAlpha(180)),
          ),
          inputTextStyle: cnstSheet.textTheme.fs16Medium,
          inputBackgroundColor: cnstSheet.colors.gray.withAlpha(120),
          inputMargin: EdgeInsets.all(8.sp),
          inputTextCursorColor: cnstSheet.colors.primary,
          primaryColor: cnstSheet.colors.primary,
          secondaryColor: cnstSheet.colors.white,
        ),
      ),
    );
  }

  Widget _buildBubble(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    // Manually apply bubble colors for older versions
    final isSent = message.author.id == _user.id;
    final bubbleColor =
        isSent ? cnstSheet.colors.primary : cnstSheet.colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          child,
          if (isSent)
            Positioned(
              bottom: 4.h,
              right: 4.w,
              child: _buildStatusIndicator(message.metadata?['status']),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String? status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'sent':
        icon = Icons.check;
        color = cnstSheet.colors.gray;
        break;
      case 'delivered':
        icon = Icons.done_all;
        color = cnstSheet.colors.gray;
        break;
      case 'read':
        icon = Icons.done_all;
        color = cnstSheet.colors.primary;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Icon(icon, size: 14.sp, color: color);
  }
}
