import 'package:agora_chat_sdk/agora_chat_sdk.dart';

class AgoraMessageListViewController {
  AgoraMessageListViewController(this.conversation) {
    _makeAllMessagesAsRead();
  }

  void _makeAllMessagesAsRead() async {
    await conversation.markAllMessagesAsRead();
  }

  final ChatConversation conversation;
}
