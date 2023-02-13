import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, this.onUnreadFlagChange});

  final void Function(bool)? onUnreadFlagChange;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) => AgoraSwipeWidget(
        index: index,
        animationDuration: const Duration(seconds: 1),
        enable: true,
        leftSwipeItems: [
          AgoraSwipeItem(
            onTap: (index) => debugPrint("收藏： $index"),
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
            onTap: (index) => debugPrint("删除： $index"),
            backgroundColor: Colors.red,
            text: "删除",
          ),
        ],
        child: Container(
          color: Colors.white,
          child: ListTile(
            onTap: () {},
            title: const Text("test123123213"),
            trailing: const Text("test123123213"),
            subtitle: const Text("subTest"),
          ),
        ),
      ),
    );
  }
}
