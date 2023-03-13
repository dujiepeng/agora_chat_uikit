import 'dart:math';

import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

class AgoraMessageListVoiceItem extends StatelessWidget {
  const AgoraMessageListVoiceItem({
    super.key,
    required this.model,
    this.isPlay = false,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.onResendTap,
    this.avatarBuilder,
    this.nicknameBuilder,
  });

  final AgoraMessageListItemModel model;
  final AgoraMessageTapBuilder? onTap;
  final AgoraMessageTapBuilder? onBubbleLongPress;
  final AgoraMessageTapBuilder? onBubbleDoubleTap;
  final VoidCallback? onResendTap;
  final AgoraWidgetBuilder? avatarBuilder;
  final AgoraWidgetBuilder? nicknameBuilder;

  final bool isPlay;

  @override
  Widget build(BuildContext context) {
    ChatMessage message = model.message;
    ChatVoiceMessageBody body = message.body as ChatVoiceMessageBody;
    double width = body.duration / 60 * 160;
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.red,
          width: 22,
          height: 22,
        ),
        Container(
            constraints: const BoxConstraints(minWidth: 20),
            child: SizedBox(
              width: min(width, 130),
            )),
        Text(AgoraTimeTool.durationStr(body.duration)),
      ],
    );

    return AgoraMessageBubble(
      model: model,
      childBuilder: (context) {
        return content;
      },
      unreadFlagBuilder: message.hasRead
          ? null
          : (context) {
              return Container(
                width: 10,
                height: 10,
                color: Colors.pink,
              );
            },
      onBubbleDoubleTap: onBubbleDoubleTap,
      onBubbleLongPress: onBubbleLongPress,
      onTap: onTap,
      avatarBuilder: avatarBuilder,
      nicknameBuilder: nicknameBuilder,
      onResendTap: onResendTap,
    );
  }
}
