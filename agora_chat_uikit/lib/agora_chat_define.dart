import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/widgets.dart';

typedef AgoraWidgetBuilder = Widget Function(
    BuildContext context, String userId);

typedef AgoraConversationWidgetBuilder = Widget? Function(
  BuildContext context,
  ChatConversation conversation,
);

typedef AgoraMessageListItemBuilder = Widget? Function(
    BuildContext context, ChatMessage message);

typedef AgoraMessageTapBuilder = void Function(
    BuildContext context, ChatMessage message);

typedef AgoraConfirmDismissCallback = Future<bool> Function(
    BuildContext context);
