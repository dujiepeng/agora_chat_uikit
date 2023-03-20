import 'package:agora_chat_demo/demo_default.dart';
import 'package:agora_chat_demo/pages/ConversationPage/MessagesPage/show_image_page.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MessagePage extends StatefulWidget {
  const MessagePage(
      {super.key, required this.conversation, this.messagesListController});

  final ChatConversation conversation;
  final AgoraMessageListController? messagesListController;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final Map<String, ChatUserInfo?> _infoMap = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ChatUserInfo? _judgmentUserInfoAndUpdate(String userId) {
    if (!_infoMap.keys.contains(userId)) {
      _infoMap[userId] = null;
      ChatClient.getInstance.userInfoManager
          .fetchUserInfoById([userId]).then((value) {
        _infoMap[userId] = value.entries.first.value;
        setState(() {});
      }).catchError((e) {
        _infoMap.remove(userId);
      });
      return null;
    }
    return _infoMap[userId];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarBackIconColor,
        ),
        shadowColor: Theme.of(context).appBarShadowColor,
        backgroundColor: Theme.of(context).appBarBackgroundColor,
        title: Row(
          children: [
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
        child: AgoraMessagesView(
          conversation: widget.conversation,
          titleAvatarBuilder: (context, conversation) {
            if (conversation.type == ChatConversationType.Chat) {
              ChatUserInfo? info = _judgmentUserInfoAndUpdate(conversation.id);
              if (info == null) {
                return AgoraImageLoader.defaultAvatar();
              } else {
                return userInfoAvatar(info);
              }
            }
            return null;
          },
          // avatarBuilder: (context, userId) {
          //   ChatUserInfo? info = _judgmentUserInfoAndUpdate(userId);
          //   if (info == null) {
          //     return AgoraImageLoader.defaultAvatar();
          //   } else {
          //     return userInfoAvatar(info);
          //   }
          // },
          onTap: (ctx, message) {
            if (message.body.type == MessageType.IMAGE) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowImagePage(message)));
              return true;
            } else if (message.body.type == MessageType.FILE) {
              EasyLoading.showError("No support show");
              return true;
            }
            return false;
          },
          onBubbleDoubleTap: (context, message) {
            return false;
          },
          onBubbleLongPress: (context, message) async {
            return false;
          },
        ),
      ),
    );
  }
}
