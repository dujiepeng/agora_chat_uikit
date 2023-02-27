import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'package:flutter/material.dart';

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
                fontSize: 25, fontWeight: FontWeight.w900, color: Colors.blue)),
        actions: [
          TextButton(
              onPressed: () async {
                setState(() {
                  showMenu(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      context: context,
                      elevation: 1,
                      color: Colors.black,
                      position: const RelativeRect.fromLTRB(0, 70, -1, 0),
                      items: [
                        PopupMenuItem(
                          onTap: () async {
                            conversationListController.loadAllConversations();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Icon(
                                Icons.contact_mail,
                                color: Colors.white,
                              ),
                              Text(
                                "刷新列表",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () async {
                            ChatConversation? a = await ChatClient
                                .getInstance.chatManager
                                .getConversation("du100");
                            conversationListController.conversationList = [a!];
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Icon(
                                Icons.contact_mail,
                                color: Colors.white,
                              ),
                              Text(
                                "插入一项",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () async {
                            conversationListController.deleteAllConversations();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Icon(
                                Icons.contact_mail,
                                color: Colors.white,
                              ),
                              Text(
                                "清空列表",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ]);
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 40,
              )),
        ],
      ),
      body: AgoraConversationListView(
        conversationListController: conversationListController,
        // onItemTap: (conversation) {
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) {
        //       return MessagePage(
        //         conversation: conversation,
        //       );
        //     },
        //   ));
        // },
      ),
    );
  }
}
