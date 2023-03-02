import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';

class AgoraMessageStatusWidget extends StatefulWidget {
  const AgoraMessageStatusWidget(
    this.message, {
    super.key,
    this.onTap,
  });

  final ChatMessage message;
  final VoidCallback? onTap;

  @override
  State<AgoraMessageStatusWidget> createState() =>
      _AgoraMessageStatusWidgetState();
}

class _AgoraMessageStatusWidgetState extends State<AgoraMessageStatusWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AgoraMessageStatusWidget oldWidget) {
    controller.stop();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;

    if (widget.message.status == MessageStatus.PROGRESS) {
      controller.repeat();
      content = RotationTransition(
        turns: controller.view,
        child: const Icon(Icons.rotate_right, size: 11.2),
      );
    }

    if (widget.message.status == MessageStatus.FAIL) {
      content = InkWell(
        onTap: widget.onTap,
        child: const Icon(Icons.error_outline, size: 11.2, color: Colors.red),
      );
    }

    if (widget.message.status == MessageStatus.SUCCESS) {
      if (widget.message.hasDeliverAck && widget.message.hasReadAck) {
        content = const Icon(Icons.done_all,
            size: 11.2, color: Color.fromRGBO(0, 204, 119, 1));
      } else if (widget.message.hasDeliverAck || widget.message.hasReadAck) {
        content = const Icon(Icons.done, size: 11.2, color: Colors.grey);
      }
    }

    return content ?? const Offstage();
  }
}
