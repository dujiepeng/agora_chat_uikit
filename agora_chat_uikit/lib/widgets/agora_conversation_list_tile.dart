import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/tools/agora_tool.dart';
import 'package:flutter/material.dart';

import 'agora_unread_count_widget.dart';

class AgoraConversationListTile extends StatefulWidget {
  const AgoraConversationListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.conversation,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function(ChatConversation conversation)? onTap;
  final ChatConversation conversation;

  @override
  State<AgoraConversationListTile> createState() =>
      AgoraConversationListTileState();
}

class AgoraConversationListTileState extends State<AgoraConversationListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.conversation.lastReceivedMessage(),
      builder: (context, snapshot) {
        ChatMessage? _msg;
        if (snapshot.hasData) {
          _msg = snapshot.data!;
        }
        return ListTile(
          leading: widget.leading,
          title: widget.title ??
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.conversation.id,
                      style: const TextStyle(fontSize: 17),
                    ),
                    Text(
                      _msg?.createTs ?? "",
                      style: const TextStyle(fontSize: 14),
                    )
                  ]),
          subtitle: widget.subtitle ??
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Builder(
                  builder: (context) {
                    return Text(
                      _msg?.summary ?? "",
                      style: const TextStyle(fontSize: 14),
                    );
                  },
                )),
                FutureBuilder<int>(
                  future: widget.conversation.unreadCount(),
                  builder: (context, snapshot) {
                    return AgoraUnreadCountWidget(
                        unreadCount: snapshot.data ?? 0);
                  },
                )
              ]),
          trailing: widget.trailing,
          onTap: () => widget.onTap?.call(widget.conversation),
        );
      },
    );
  }
}
