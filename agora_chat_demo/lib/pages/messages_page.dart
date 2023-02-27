import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage(
      {super.key, required this.conversation, this.messagesListController});

  final ChatConversation conversation;
  final AgoraMessageListViewController? messagesListController;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Theme.of(context).appBarShadowColor,
        backgroundColor: Theme.of(context).appBarBackgroundColor,
        title: Text(
          widget.conversation.id,
        ),
      ),
      body: AgoraMessageListView(
        key: const Key("messageList"),
        conversation: widget.conversation,
      ),
    );
  }
}
