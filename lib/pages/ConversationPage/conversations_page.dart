import 'package:agora_chat_demo/demo_default.dart';
import 'package:agora_chat_demo/pages/ContactPage/contact_search_page.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'package:flutter/material.dart';

import 'MessagesPage/messages_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key, this.onUnreadCountChanged});
  final void Function(int)? onUnreadCountChanged;
  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final Map<String, ChatUserInfo?> _infoMap = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ConversationsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void unreadCountChange() {
    widget.onUnreadCountChanged?.call(
        AgoraChatUIKit.of(context).conversationsController.totalUnreadCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Theme.of(context).appBarShadowColor,
        backgroundColor: Theme.of(context).appBarBackgroundColor,
        title: const Text('Chats',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Color.fromRGBO(0, 95, 255, 1))),
        actions: [
          TextButton(
              onPressed: showMenu,
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 40,
              )),
        ],
      ),
      body: AgoraConversationsView(
        avatarBuilder: (context, conversation) {
          if (conversation.type == ChatConversationType.Chat) {
            ChatUserInfo? info = _judgmentUserInfoAndUpdate(conversation.id);
            if (info == null) {
              return AgoraImageLoader.defaultAvatar(size: 40);
            } else {
              return userInfoAvatar(info, size: 40);
            }
          }
          return null;
        },
        nicknameBuilder: (context, conversation) {
          if (conversation.type == ChatConversationType.Chat) {
            ChatUserInfo? info = _judgmentUserInfoAndUpdate(conversation.id);
            String showName = info?.nickName ?? "";
            if (showName.isEmpty) {
              showName = conversation.id;
            }
            return Text(
              showName,
              style: const TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            );
          }
          return null;
        },
        onItemTap: (conversation) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return MessagePage(conversation: conversation);
            },
          )).then((value) async {
            await AgoraChatUIKit.of(context)
                .conversationsController
                .markConversationAsRead(conversation.id);
          });
        },
      ),
    );
  }

  void showMenu() async {
    await AgoraBottomSheet(titleLabel: "Create", items: [
      AgoraBottomSheetItem(
        "Add contact",
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const ContactSearchPage();
            },
          ));
        },
      ),
    ]).show(context);
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
}
