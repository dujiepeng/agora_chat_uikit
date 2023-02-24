import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';

import '../controllers/agora_message_list_view_controller.dart';

class AgoraMessageListView extends StatefulWidget {
  const AgoraMessageListView(
      {super.key, required this.conversation, this.messageListViewController});

  final ChatConversation conversation;
  final AgoraMessageListViewController? messageListViewController;

  @override
  State<AgoraMessageListView> createState() => _AgoraMessageListViewState();
}

class _AgoraMessageListViewState extends State<AgoraMessageListView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
