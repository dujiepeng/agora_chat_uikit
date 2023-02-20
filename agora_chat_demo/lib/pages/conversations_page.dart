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
              onPressed: () {
                setState(() {
                  showMenu(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      context: context,
                      elevation: 1,
                      color: Colors.black,
                      position: const RelativeRect.fromLTRB(0, 120, -10, 0),
                      items: getPopupMenuItems());
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
        onUnreadCountChanged: widget.onUnreadCountChanged,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0.02,
          );
        },
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

  final List _appBarData = [
    {"icon_codePoint": 0xe66c, "tag": "添加好友", "color": Colors.white},
    {"icon_codePoint": 0xe611, "tag": "扫一扫", "color": Colors.white},
    {"icon_codePoint": 0xe64d, "tag": "收付款", "color": Colors.white},
    {"icon_codePoint": 0xe60d, "tag": "帮助与反馈", "color": Colors.white}
  ];
  List<PopupMenuItem> getPopupMenuItems() {
    return _appBarData.map((item) {
      return PopupMenuItem(
          child: Row(
        children: <Widget>[
          SizedBox(
            width: 30,
            height: 30,
            child: Icon(
              IconData(item['icon_codePoint'], fontFamily: 'AppBarIcons'),
              color: item['color'],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: Text(
              item['tag'],
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ));
    }).toList();
  }
}
