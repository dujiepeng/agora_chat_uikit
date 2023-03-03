import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

class AgoraMessageListImageItem extends StatelessWidget {
  const AgoraMessageListImageItem({
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
    ChatImageMessageBody body = message.body as ChatImageMessageBody;
    double max = 200.0;
    double width = body.width ?? max;
    double height = body.height ?? max;

    double ratio = width / height;
    if (ratio <= 0.5 || ratio >= 2) {
      max = max / 3 * 4;
    }
    if (width > height) {
      height = max / width * height;
      width = max;
    } else {
      width = max / height * width;
      height = max;
    }

    Widget content;
    if (body.thumbnailStatus == DownloadStatus.SUCCESS) {
      content = Image.file(File(body.thumbnailLocalPath!), fit: BoxFit.fill);
    } else if (body.fileStatus == DownloadStatus.SUCCESS) {
      content = Image.file(File(body.localPath), fit: BoxFit.fill);
    } else {
      content = FadeInImage.assetNetwork(
          placeholder: "loading",
          image: body.thumbnailRemotePath!,
          fit: BoxFit.fill);
    }

    return AgoraMessageBubble(
      onBubbleDoubleTap: onBubbleDoubleTap,
      onBubbleLongPress: onBubbleLongPress,
      onTap: onTap,
      avatarBuilder: avatarBuilder,
      showNameBuilder: showNameBuilder,
      padding: EdgeInsets.zero,
      message: message,
      childBuilder: (context) {
        return SizedBox(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: content,
          ),
        );
      },
    );
  }
}
