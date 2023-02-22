import 'package:agora_chat_sdk/agora_chat_sdk.dart';
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
  final AgoraConversationListViewController conversationListViewController =
      AgoraConversationListViewController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
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
                            conversationListViewController
                                .loadAllConversations();
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
                            conversationListViewController.conversationList = [
                              a!
                            ];
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
                            conversationListViewController
                                .deleteAllConversations();
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
        conversationListController: conversationListViewController,
        onUnreadCountChanged: widget.onUnreadCountChanged,
        onTap: (conversation) {
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
}
