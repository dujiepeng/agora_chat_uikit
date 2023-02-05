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
      itemExtent: 50,
      itemCount: 1,
      itemBuilder: (context, index) => const AgoraSwipeWidget(
        leftSwipeItems: [AgoraSwipeItem(color: Colors.red, text: "收藏")],
        rightSwipeItems: [
          AgoraSwipeItem(color: Colors.blue, text: "置顶"),
          AgoraSwipeItem(color: Colors.red, text: "删除")
        ],
        child: ListTile(
          title: Text("test123123213"),
          trailing: Text("test123123213"),
        ),
      ),
    );
  }
}
