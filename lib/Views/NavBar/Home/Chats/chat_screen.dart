import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/chat_screeen_app_bar.dart';
import 'package:ourtalks/Components/BottomSheets/chat_bottom_sheet.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Data/Networks/cloudinary/cloudinary_function.dart';
import 'package:ourtalks/view_model/Data/Networks/realtime%20database/chat_respository.dart';
import 'package:ourtalks/view_model/Models/friend_model.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final FriendModel usermodel;
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
  late String _conversationId;

  @override
  void initState() {
    super.initState();
    // Generate conversation ID
    final sortedIds = [
      _usercontroller.user!.userID!,
      widget.usermodel.users.userID!
    ]..sort();
    _conversationId = "${sortedIds[0]}_${sortedIds[1]}";
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
    _messagesRef(widget.usermodel.users.userID.toString(), "messages")
        .orderByChild("createdAt")
        .limitToLast(100)
        .onChildAdded
        .listen((event) {
      _handleNewMessage(event.snapshot.value);
    });

    _messagesRef(widget.usermodel.users.userID.toString(), "messages")
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
        case 'image': // Add image case
          return types.ImageMessage.fromJson(json);
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
        receiverId: widget.usermodel.users.userID.toString(),
        metadata: textMessage.metadata!,
      );
    } else {
      debugPrint("reglure msg*************");
      ChatRespository.sendMessage(
          text: textMessage.text,
          receiverId: widget.usermodel.users.userID.toString(),
          metadata: textMessage.metadata!);
    }
    _clearRepliedMessage();
  }

  // send image
  void _sendImageMessage(String imageUrl) {
    final imageMessage = types.ImageMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      name: 'image',
      size: 0, // Add actual size if available
      uri: imageUrl,
      metadata: {
        'status': 'sent',
        if (_repliedMessage != null) 'replyTo': _repliedMessage!.id,
      },
    );

    if (_messages.isEmpty) {
      ChatRespository.sendFirstMessage(
        text: imageMessage.uri,
        receiverId: widget.usermodel.users.userID.toString(),
        metadata: imageMessage.metadata!,
      );
    } else {
      ChatRespository.sendImageMessage(
        imageUrl: imageMessage.uri,
        receiverId: widget.usermodel.users.userID.toString(),
        metadata: imageMessage.metadata!,
      );
    }
  }

  Future<void> _updateMessageStatus(
    String messageId,
    Map<String, dynamic> metadata,
  ) async {
    await ChatRespository.updateMessageStatus(
      receiverId: widget.usermodel.users.userID.toString(),
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
        receiverId: widget.usermodel.users.userID!,
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
      appBar: chatScreenAppBar(
          model: widget.usermodel,
          context: context), // CHAT SCREEN AAP BAR CALL
      //  BODY
      body: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Column(
          children: [
            if (_repliedMessage != null && _repliedMessage is types.TextMessage)
              Container(
                padding: EdgeInsets.all(8.sp),
                color: cnstSheet.colors.gray,
                child: Row(
                  children: [
                    Icon(Icons.reply,
                        size: 16.sp, color: cnstSheet.colors.white),
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
              // CHAT WIDGET
              child: Chat(
                emojiEnlargementBehavior: EmojiEnlargementBehavior.never,
                messages: _messages,
                onSendPressed: _handleSendPressed,
                user: _user,
                // bubbleBuilder: _buildBubble,
                bubbleBuilder: (child,
                    {required message, required nextMessageInGroup}) {
                  return GestureDetector(
                    onLongPressStart: (details) => _showMessageOptions(
                        context, message, details.globalPosition),
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
                customDateHeaderText: (date) =>
                    AppFunctions.formatChatTime(date),
                theme: DefaultChatTheme(
                  inputPadding: EdgeInsets.all(15),
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
                  chatBottomSheetFunction(file: (fileValue) async {
                    try {
                      final imageUrl =
                          await CloudinaryFunctions().uploadImageToCloudinary(
                        fileValue,
                        folder:
                            _conversationId, // Use conversation ID as folder
                      );
                      _sendImageMessage(imageUrl!);
                    } catch (e) {
                      debugPrint("Error uploading image: $e");
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    final isSent = message.author.id == _user.id;
    final bubbleColor =
        isSent ? cnstSheet.colors.primary : cnstSheet.colors.white;

    final repliedMessageId = message.metadata?['replyTo'];
    final repliedMessage = repliedMessageId != null
        ? _messages.firstWhere(
            (m) => m.id == repliedMessageId,
            orElse: () => types.TextMessage(
                author: types.User(id: ""),
                id: "",
                text: LanguageConst.deletedMessage.tr),
          )
        : null;

    if (message is types.ImageMessage) {
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
                '${LanguageConst.replayto.tr}: ${repliedMessage.text}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: cnstSheet.colors.black,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: bubbleColor,
            ),
            child: CachedNetworkImage(
              imageUrl: message.uri,
              width: 200.w,
              height: 200.h,
              fit: BoxFit.cover,
            ),
          ),
          if (isSent)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: _buildStatusIndicator(message.metadata?['status']),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment:
          isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (repliedMessage != null && repliedMessage is types.TextMessage)
          Container(
            padding: EdgeInsets.all(8.sp),
            margin: EdgeInsets.only(bottom: 4.h, top: 8.h),
            decoration: BoxDecoration(
              color: bubbleColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${LanguageConst.replayto.tr}: ${repliedMessage.text}',
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

  //  SHOW MESSAGE OPTIONS
  void _showMessageOptions(
      BuildContext context, types.Message message, Offset position) {
    // POSITION
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final localPosition = overlay.globalToLocal(position);
    double menuHeight = 100;
    double yOffset = localPosition.dy;

    if (yOffset + menuHeight > cnstSheet.services.screenHeight(context)) {
      yOffset -= menuHeight;
    }

    // DATA
    final bool isUserMessage = message.author.id == _user.id;
    final bool isTextMessage = message is types.TextMessage;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        localPosition.dx, // X Position
        yOffset, // Y Position
        localPosition.dx + 50, // Width
        yOffset + 50, // Height
      ),
      color: cnstSheet.colors.gray.withAlpha(200),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          side: BorderSide(color: cnstSheet.colors.primary)),
      items: [
        if (isUserMessage && isTextMessage)
          PopupMenuItem(
            child: Text(
              LanguageConst.edit.tr,
              style: cnstSheet.textTheme.fs15Normal
                  .copyWith(color: cnstSheet.colors.white),
            ),
            onTap: () => _handleEditMessage(message),
          ),
        PopupMenuItem(
            child: Text(LanguageConst.delete.tr,
                style: cnstSheet.textTheme.fs15Normal
                    .copyWith(color: cnstSheet.colors.white)),
            onTap: () {
              ChatRespository.deleteMessage(
                receiverId: widget.usermodel.users.userID!,
                messageId: message.id,
              ).then((_) => setState(
                  () => _messages.removeWhere((m) => m.id == message.id)));
            }),
        PopupMenuItem(
          child: Text(LanguageConst.cancel.tr,
              style: cnstSheet.textTheme.fs15Normal
                  .copyWith(color: cnstSheet.colors.white)),
        ),
      ],
    );
  }

  // EDIT MESSAGE
  void _handleEditMessage(types.TextMessage message) {
    TextEditingController controller =
        TextEditingController(text: message.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newText = controller.text.trim();
              if (newText.isNotEmpty && newText != message.text) {
                ChatRespository.updateMessage(
                  receiverId: widget.usermodel.users.userID!,
                  messageId: message.id,
                  newText: newText,
                ).then((_) {
                  final index = _messages.indexWhere((m) => m.id == message.id);
                  if (index != -1) {
                    final updatedMessage = types.TextMessage(
                      id: message.id,
                      author: message.author,
                      createdAt: message.createdAt,
                      text: newText,
                      metadata: message.metadata,
                    );
                    setState(() => _messages[index] = updatedMessage);
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // void _handleDeleteMessage(types.Message message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete Message'),
  //       content: const Text('Are you sure you want to delete this message?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             ChatRespository.deleteMessage(
  //               receiverId: widget.usermodel.users.userID!,
  //               messageId: message.id,
  //             ).then((_) => setState(
  //                 () => _messages.removeWhere((m) => m.id == message.id)));
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Delete', style: TextStyle(color: Colors.red)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
