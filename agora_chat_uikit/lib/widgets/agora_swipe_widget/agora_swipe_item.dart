import 'package:flutter/material.dart';

class AgoraSwipeItem {
  const AgoraSwipeItem({
    required this.text,
    this.onTap,
    this.itemWidth = 80,
    this.backgroundColor = Colors.white,
    this.style = const TextStyle(color: Colors.white),
  });

  final VoidCallback? onTap;
  final TextStyle style;
  final String text;
  final Color backgroundColor;
  final double itemWidth;
}
