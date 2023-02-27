import 'package:flutter/material.dart';

typedef ConfirmDismissCallback = Future<AgoraSwipeItemAction> Function(
    BuildContext context);

enum AgoraSwipeItemAction { close, dismiss }

class AgoraSwipeItem {
  const AgoraSwipeItem({
    required this.text,
    this.didAction,
    this.itemWidth = 80,
    this.backgroundColor = Colors.white,
    this.confirmAction,
    this.style = const TextStyle(color: Colors.white),
  });

  final void Function(AgoraSwipeItemAction action)? didAction;
  final TextStyle style;
  final String text;
  final Color backgroundColor;
  final double itemWidth;
  final ConfirmDismissCallback? confirmAction;
}
