import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, this.onUnreadFlagChange});

  final void Function(bool)? onUnreadFlagChange;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<String> list = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17"
  ];

  @override
  Widget build(BuildContext context) {
    return AgoraSwipeAutoCloseBehavior(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => AgoraSwipeWidget(
          index: index,
          animationDuration: const Duration(milliseconds: 500),
          enable: true,
          leftSwipeItems: [
            AgoraSwipeItem(
              onTap: (index) async {
                for (int i = 0; i < 10; i++) {
                  ChatMessage msg = ChatMessage.createTxtSendMessage(
                      targetId: i.toString(), content: "hello");
                  await ChatClient.getInstance.chatManager.sendMessage(msg);
                }
              },
              backgroundColor: Colors.green,
              text: "收藏",
            )
          ],
          rightSwipeItems: [
            AgoraSwipeItem(
              onTap: (index) => debugPrint("置顶： $index"),
              backgroundColor: Colors.blue,
              text: "置顶",
            ),
            AgoraSwipeItem(
              onTap: (index) {
                setState(() {
                  list.removeAt(index);
                });
              },
              backgroundColor: Colors.red,
              text: "删除",
            ),
          ],
          child: Container(
            color: Colors.white,
            child: ListTile(
              onTap: () {},
              title: Text(list[index].toString()),
              trailing: const Text("test123123213"),
              subtitle: const Text("subTest"),
            ),
          ),
        ),
      ),
    );
  }
}
