import 'package:agora_chat_sdk/agora_chat_sdk.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            for (int i = 0; i < 11; i++) {
              ChatMessage msg = ChatMessage.createTxtSendMessage(
                  targetId: "15", content: i.toString());
              await ChatClient.getInstance.chatManager.sendMessage(msg);
            }
          },
          child: const Text(
            "sss",
          )),
    );
  }
}
