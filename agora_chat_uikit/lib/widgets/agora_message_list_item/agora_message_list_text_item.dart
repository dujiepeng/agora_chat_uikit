import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'package:flutter/material.dart';

class AgoraMessageListTextItem extends StatelessWidget {
  const AgoraMessageListTextItem({
    super.key,
    required this.message,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.onResendTap,
    this.avatarBuilder,
    this.showNameBuilder,
  });

  final ChatMessage message;
  final VoidCallback? onTap;
  final VoidCallback? onBubbleLongPress;
  final VoidCallback? onBubbleDoubleTap;
  final VoidCallback? onResendTap;
  final AgoraWidgetBuilder? avatarBuilder;
  final AgoraWidgetBuilder? showNameBuilder;

  @override
  Widget build(BuildContext context) {
    bool isLeft = message.direction == MessageDirection.RECEIVE;
    return AgoraMessageBubble(
      message: message,
      childBuilder: (context) {
        ChatTextMessageBody body = message.body as ChatTextMessageBody;
        return SelectableText(
          body.content,
          style: TextStyle(
            color: isLeft ? Colors.black : Colors.white,
          ),
        );
      },
      onBubbleDoubleTap: onBubbleDoubleTap,
      onBubbleLongPress: onBubbleLongPress,
      onTap: onTap,
      avatarBuilder: avatarBuilder,
      showNameBuilder: showNameBuilder,
    );
  }
}
