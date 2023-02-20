import 'package:flutter/material.dart';

class AgoraSwipeItem {
  const AgoraSwipeItem({
    required this.text,
    int? index,
    this.onTap,
    this.itemWidth = 80,
    this.backgroundColor = Colors.white,
    this.style = const TextStyle(color: Colors.white),
  });

  final void Function(int index)? onTap;
  final TextStyle style;
  final String text;
  final Color backgroundColor;
  final double itemWidth;
}
