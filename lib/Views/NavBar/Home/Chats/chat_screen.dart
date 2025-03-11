import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/BottomSheets/chat_bottom_sheet.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Views/NavBar/Home/profile_view_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
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
  final _usercontroller = Get.find<UserController>();
  final List<types.Message> _messages = [];
  late types.User _user;
  final _messagesRef = ChatRespository.getConversationID;
  types.Message? _repliedMessage;

  @override
  void initState() {
    super.initState();
    // ++
    _user = types.User(
        id: _usercontroller.user!.userID!,
        imageUrl: _usercontroller.user!.userDP,
        firstName: _usercontroller.user!.name);

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
      metadata: {
        'status': 'sent',
        if (_repliedMessage != null) 'replyTo': _repliedMessage!.id,
      },
    );

    if (_messages.isEmpty) {
      debugPrint("first msg*************");
      ChatRespository.sendFirstMessage(
        text: textMessage.text,
        receiverId: widget.usermodel.userID.toString(),
        metadata: textMessage.metadata!,
      );
    } else {
      debugPrint("reglure msg*************");
      ChatRespository.sendMessage(
          text: textMessage.text,
          receiverId: widget.usermodel.userID.toString(),
          metadata: textMessage.metadata!);
    }
    _clearRepliedMessage();
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
    final unreadMessages = _messages.where((message) =>
        message.author.id != _usercontroller.user!.userID &&
        message.metadata?['status'] != 'read');

    for (final message in unreadMessages) {
      await ChatRespository.updateMessageStatus(
        receiverId: widget.usermodel.userID!,
        messageId: message.id,
        metadata: {'status': 'read'},
      );
    }
  }

  // ***replay function

  void _setRepliedMessage(types.Message message) {
    setState(() {
      _repliedMessage = message;
    });
  }

  void _clearRepliedMessage() {
    setState(() {
      _repliedMessage = null;
    });
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
                  scale: 1,
                  imageUrl: widget.usermodel.userDP!.isNotEmpty
                      ? widget.usermodel.userDP!
                      : AppConfig.defaultDP,
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
      body: Column(
        children: [
          if (_repliedMessage != null && _repliedMessage is types.TextMessage)
            Container(
              padding: EdgeInsets.all(8.sp),
              color: cnstSheet.colors.gray,
              child: Row(
                children: [
                  Icon(Icons.reply, size: 16.sp, color: cnstSheet.colors.white),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      'Replying to: ${(_repliedMessage as types.TextMessage).text}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: cnstSheet.colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _clearRepliedMessage,
                    icon: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: cnstSheet.colors.red,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _user,
              // bubbleBuilder: _buildBubble,
              bubbleBuilder: (child,
                  {required message, required nextMessageInGroup}) {
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    // Check if the drag is significant (e.g., more than 50 pixels)
                    if (details.primaryVelocity != null &&
                        details.primaryVelocity!.abs() > 50) {
                      _setRepliedMessage(
                          message); // Set the message to reply to
                    }
                  },
                  child: _buildBubble(
                    child,
                    message: message,
                    nextMessageInGroup: nextMessageInGroup,
                  ),
                );
              },
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
                  border: Border.all(
                      color: cnstSheet.colors.primary.withAlpha(180)),
                ),
                inputTextStyle: cnstSheet.textTheme.fs16Medium,
                inputBackgroundColor: cnstSheet.colors.gray.withAlpha(120),
                inputMargin: EdgeInsets.all(8.sp),
                inputTextCursorColor: cnstSheet.colors.primary,
                primaryColor: cnstSheet.colors.primary,
                secondaryColor: cnstSheet.colors.white,
              ),
              onAttachmentPressed: () {
                //  PICK IMAGE
                chatBottomSheetFunction(file: (fileValue) {});
              },
            ),
          ),
        ],
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

    // Check if this message is a reply
    final repliedMessageId = message.metadata?['replyTo'];
    final repliedMessage = repliedMessageId != null
        ? _messages.firstWhere((m) => m.id == repliedMessageId)
        : null;

    return Column(
      crossAxisAlignment:
          isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (repliedMessage != null && repliedMessage is types.TextMessage)
          Container(
            padding: EdgeInsets.all(8.sp),
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              color: bubbleColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Replying to: ${repliedMessage.text}',
              style: TextStyle(
                fontSize: 12.sp,
                color: cnstSheet.colors.black,
              ),
            ),
          ),
        Container(
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
        ),
      ],
    );
  }

  // BUILD STATUS INDICATOR
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
        color = cnstSheet.colors.blue;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Icon(icon, size: 14.sp, color: color);
  }
}
