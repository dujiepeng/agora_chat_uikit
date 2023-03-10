import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AgoraMessagesPage extends StatefulWidget {
  const AgoraMessagesPage({
    super.key,
    this.appBar,
    this.inputBar,
    required this.conversation,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.avatarBuilder,
    this.showNameBuilder,
    this.titleAvatarBuilder,
    this.moreItems,
    this.userInfo,
  });

  final AppBar? appBar;
  final Widget? inputBar;
  final ChatConversation conversation;
  final AgoraMessageTapBuilder? onTap;
  final AgoraMessageTapBuilder? onBubbleLongPress;
  final AgoraMessageTapBuilder? onBubbleDoubleTap;
  final AgoraWidgetBuilder? avatarBuilder;
  final AgoraWidgetBuilder? showNameBuilder;
  final List<AgoraBottomSheetItem>? moreItems;
  final ChatUserInfo? userInfo;
  final AgoraConversationWidgetBuilder? titleAvatarBuilder;

  @override
  State<AgoraMessagesPage> createState() => _AgoraMessagesPageState();
}

class _AgoraMessagesPageState extends State<AgoraMessagesPage> {
  late final AgoraMessageListViewController msgListViewController;
  final ImagePicker _picker = ImagePicker();
  ChatUserInfo? _userInfo;
  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
    msgListViewController = AgoraMessageListViewController(widget.conversation);
    msgListViewController.markAllMessagesAsRead();
  }

  @override
  void dispose() {
    msgListViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: widget.appBar ??
          AppBar(
            titleSpacing: 0,
            iconTheme: IconThemeData(
              color: Theme.of(context).appBarBackIconColor,
            ),
            centerTitle: false,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                widget.titleAvatarBuilder?.call(context, widget.conversation) ??
                    AgoraImageLoader.defaultAvatar(),
                const SizedBox(width: 10),
                Text(
                  widget.conversation.id,
                  style: Theme.of(context).appBarTitleTextStyle,
                ),
              ],
            ),
          ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AgoraMessageListView(
                conversation: widget.conversation,
                messageListViewController: msgListViewController,
                onTap: (context, message) {
                  if (message.body.type == MessageType.VOICE) {
                    _voiceBubblePressed(message);
                  }
                  return;
                },
                onBubbleDoubleTap: (context, message) {
                  debugPrint("message double tap");
                  return;
                },
                onBubbleLongPress: (ctx, msg) async {
                  await longPressAction.call(msg);
                },
              ),
            ),
            widget.inputBar ??
                AgoraMessageInputWidget(
                  msgListViewController: msgListViewController,
                  onTextFieldFocus: () {},
                  moreAction: showMoreItems,
                  onTextFieldChanged: (text) {},
                  onSendBtnTap: (text) {
                    var msg = ChatMessage.createTxtSendMessage(
                        targetId: widget.conversation.id, content: text);
                    msg.chatType =
                        ChatType.values[widget.conversation.type.index];
                    msgListViewController.sendMessage(msg);
                  },
                )
          ],
        ),
      ),
    );
  }

  Future<void> longPressAction(ChatMessage message) async {
    List<AgoraBottomSheetItem> list = [];
    if (message.body.type == MessageType.TXT) {
      list.add(
        AgoraBottomSheetItem(
          "Copy",
          onTap: () {
            ChatTextMessageBody body = message.body as ChatTextMessageBody;
            Clipboard.setData(ClipboardData(text: body.content));
            return Navigator.of(context).pop();
          },
        ),
      );
    }
    list.add(
      AgoraBottomSheetItem(
        "Delete",
        onTap: () {
          msgListViewController.removeMessage(message);
          return Navigator.of(context).pop(true);
        },
      ),
    );
    if (DateTime.now().millisecondsSinceEpoch - message.serverTime <
        180 * 1000) {
      list.add(
        AgoraBottomSheetItem(
          "Unsend",
          labelStyle: const TextStyle(
              color: Color.fromRGBO(255, 20, 204, 1),
              fontWeight: FontWeight.w400,
              fontSize: 18),
          onTap: () {
            msgListViewController.unsendMessage(context, message);
            return Navigator.of(context).pop(true);
          },
        ),
      );
    }
    return AgoraBottomSheet(
      items: list,
    ).show(context);
  }

  void showMoreItems() {
    AgoraBottomSheet(
      items: widget.moreItems ??
          [
            AgoraBottomSheetItem("Camera", onTap: () {
              Navigator.of(context).pop();
              _takePhoto();
            }),
            AgoraBottomSheetItem("Album", onTap: () {
              Navigator.of(context).pop();
              _openImagePicker();
            }),
            AgoraBottomSheetItem("Files", onTap: () {
              Navigator.of(context).pop();
              _openFilePicker();
            }),
          ],
    ).show(context);
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile? file = result.files.first;
      ChatMessage fileMsg = ChatMessage.createFileSendMessage(
        targetId: widget.conversation.id,
        filePath: file.path!,
        fileSize: file.size,
        displayName: file.name,
      );
      fileMsg.chatType = ChatType.values[widget.conversation.type.index];
      msgListViewController.sendMessage(fileMsg);
    }
  }

  void _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      _sendImage(photo.path);
    }
  }

  void _openImagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _sendImage(image.path);
    }
  }

  void _sendImage(String path) async {
    if (path.isEmpty) {
      return;
    }

    bool hasSize = false;
    File file = File(path);
    Image.file(file)
        .image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, synchronousCall) {
      if (!hasSize) {
        hasSize = true;
        ChatMessage msg = ChatMessage.createImageSendMessage(
          targetId: widget.conversation.id,
          filePath: path,
          width: info.image.width.toDouble(),
          height: info.image.height.toDouble(),
          fileSize: file.sizeInBytes,
        );
        msgListViewController.sendMessage(msg);
      }
    }));
  }

  void _voiceBubblePressed(ChatMessage message) async {
    await widget.conversation.markMessageAsRead(message.msgId);
    message.hasRead = true;
    if (msgListViewController.playingMessage?.msgId == message.msgId) {
      _stopVoice(message);
    } else {
      _playVoice(message);
    }
  }

  void _playVoice(ChatMessage message) {
    msgListViewController.play(message);
    msgListViewController.reloadData();
  }

  void _stopVoice(ChatMessage message) {
    msgListViewController.stopPlay(message);
    msgListViewController.reloadData();
  }
}
