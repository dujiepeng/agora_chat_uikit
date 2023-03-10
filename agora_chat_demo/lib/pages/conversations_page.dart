import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'package:flutter/material.dart';

import 'messages_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key, this.onUnreadCountChanged});
  final void Function(int)? onUnreadCountChanged;
  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final AgoraConversationListController conversationListController =
      AgoraConversationListController();

  @override
  void initState() {
    super.initState();
    conversationListController.addTotalUnreadCountListener(unreadCountChange);
  }

  @override
  void dispose() {
    conversationListController
        .removeTotalUnreadCountListener(unreadCountChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ConversationsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void unreadCountChange() {
    widget.onUnreadCountChanged
        ?.call(conversationListController.totalUnreadCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: AgoraConversationListView(
        conversationListController: conversationListController,
        onItemTap: (conversation) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return MessagePage(
                conversation: conversation,
              );
            },
          ));
        },
      ),
    );
  }

  void showMenu() async {
    await AgoraBottomSheet(titleLabel: "Create", items: [
      AgoraBottomSheetItem(
        "New Conversation",
        onTap: () {},
      ),
      AgoraBottomSheetItem(
        "Create a group",
        onTap: () {},
      ),
      AgoraBottomSheetItem(
        "Add contact",
        onTap: () {},
      ),
    ]).show(context);
  }
}
