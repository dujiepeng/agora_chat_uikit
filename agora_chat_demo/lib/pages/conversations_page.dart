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
              onPressed: () {},
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 40,
              )),
        ],
      ),
      body: AgoraConversationListView(
        separatorBuilder: (context, index) => const Divider(
          height: 15,
          color: Colors.black,
        ),
        itemBuilder: (
          BuildContext context,
          int index,
          ChatConversation conversation,
        ) {
          return AgoraConversationListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("Title!"), Text("10:10:10")]),
            subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(conversation.id,
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                  FutureBuilder<int>(
                    future: conversation.unreadCount(),
                    builder: (context, snapshot) {
                      return AgoraUnreadCountWidget(
                          unreadCount: snapshot.data ?? 0);
                    },
                  )
                ]),
            leading: Container(width: 40, height: 40, color: Colors.red),
            onTap: () {},
          );
        },
        onUnreadCountChanged: widget.onUnreadCountChanged,
      ),
    );
  }
}
