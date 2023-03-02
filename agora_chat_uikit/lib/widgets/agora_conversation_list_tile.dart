import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/tools/agora_extension.dart';
import 'package:flutter/material.dart';

import 'agora_badge_widget.dart';

class AgoraConversationListTile extends StatelessWidget {
  const AgoraConversationListTile(
      {super.key,
      required this.conversation,
      this.avatar,
      this.title,
      this.subtitle,
      this.trailing,
      this.onTap});

  final Widget? avatar;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function(ChatConversation conversation)? onTap;
  final ChatConversation conversation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // key: ValueKey(conversation.id),
      future: conversation.latestMessage(),
      builder: (context, snapshot) {
        ChatMessage? msg;
        if (snapshot.hasData) {
          msg = snapshot.data!;
        }
        return ListTile(
          leading: avatar,
          title: title ??
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      conversation.id,
                      style: const TextStyle(fontSize: 17),
                    ),
                    Text(
                      msg?.createTs ?? "",
                      style: const TextStyle(fontSize: 14),
                    )
                  ]),
          subtitle: subtitle ??
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Builder(
                  builder: (context) {
                    return Text(
                      msg?.summary ?? "",
                      style: const TextStyle(fontSize: 14),
                    );
                  },
                )),
                FutureBuilder<int>(
                  future: conversation.unreadCount(),
                  builder: (context, snapshot) {
                    return AgoraBadgeWidget(
                      unreadCount: snapshot.data ?? 0,
                    );
                  },
                )
              ]),
          trailing: trailing,
          onTap: () => onTap?.call(conversation),
        );
      },
    );
  }
}
