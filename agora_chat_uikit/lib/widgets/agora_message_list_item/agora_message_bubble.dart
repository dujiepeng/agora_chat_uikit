import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

import 'agora_message_status_widget.dart';

class AgoraMessageBubble extends StatelessWidget {
  const AgoraMessageBubble({
    super.key,
    required this.message,
    required this.childBuilder,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.avatarBuilder,
    this.showNameBuilder,
    this.onResendTap,
    this.bubbleColor,
    this.padding,
  });

  final ChatMessage message;
  final VoidCallback? onTap;
  final VoidCallback? onBubbleLongPress;
  final VoidCallback? onBubbleDoubleTap;
  final AgoraWidgetBuilder? avatarBuilder;
  final AgoraWidgetBuilder? showNameBuilder;

  final VoidCallback? onResendTap;
  final WidgetBuilder childBuilder;
  final Color? bubbleColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    bool isLeft = message.direction == MessageDirection.RECEIVE;
    Widget content = Container(
      decoration: BoxDecoration(
        color: bubbleColor ??
            (isLeft
                ? const Color.fromRGBO(242, 242, 242, 1)
                : const Color.fromRGBO(0, 65, 255, 1)),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft:
              !isLeft ? const Radius.circular(10) : const Radius.circular(3),
          bottomRight:
              isLeft ? const Radius.circular(10) : const Radius.circular(3),
        ),
      ),
      constraints: const BoxConstraints(maxWidth: 260),
      child: Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: childBuilder(context),
      ),
    );

    List<Widget> insideBubbleWidgets = [];
    if (showNameBuilder != null) {
      insideBubbleWidgets.add(Container(
        constraints: const BoxConstraints(maxWidth: 260),
        child: showNameBuilder!.call(context, message.from!),
      ));
      insideBubbleWidgets.add(const SizedBox(height: 6));
      insideBubbleWidgets.add(content);

      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: insideBubbleWidgets.toList(),
      );
      insideBubbleWidgets.clear();
    }

    if (avatarBuilder != null) {
      insideBubbleWidgets.add(avatarBuilder!.call(context, message.from!));
      insideBubbleWidgets.add(const SizedBox(width: 10));
    }

    insideBubbleWidgets.add(content);
    insideBubbleWidgets.add(SizedBox(width: isLeft ? 0 : 10.4));

    if (!isLeft) {
      insideBubbleWidgets
          .add(AgoraMessageStatusWidget(message, onTap: onResendTap));
    }

    content = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: isLeft ? TextDirection.ltr : TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: insideBubbleWidgets.toList(),
    );
    insideBubbleWidgets.clear();

    content = Padding(
      padding: EdgeInsets.fromLTRB(15, 7.5, isLeft ? 7.5 : 15, 7.5),
      child: content,
    );
    return InkWell(
      onDoubleTap: onBubbleDoubleTap,
      onTap: onTap,
      onLongPress: onBubbleLongPress,
      child: content,
    );
  }
}
