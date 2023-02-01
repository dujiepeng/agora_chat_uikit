import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class AgoraSwipeListTile extends StatefulWidget {
  const AgoraSwipeListTile({
    super.key,
    this.startActions,
    this.endActions,
    this.enable = true,
  });

  final List<Widget>? startActions;
  final List<Widget>? endActions;
  final bool enable;

  @override
  State<AgoraSwipeListTile> createState() => _AgoraSwipeListTileState();
}

class _AgoraSwipeListTileState extends State<AgoraSwipeListTile> {
  @override
  Widget build(BuildContext context) {
    return AgoraSwipeGestureDetector(
      enable: widget.enable,
      child: Stack(
        children: const [
          ListTile(
            title: Text("test"),
          ),
        ],
      ),
    );
  }
}

class AgoraSwipeGestureDetectorController {}

class AgoraSwipeGestureDetector extends StatefulWidget {
  const AgoraSwipeGestureDetector({
    super.key,
    this.enable = true,
    required this.child,
  });

  final bool enable;
  final Widget child;

  @override
  State<AgoraSwipeGestureDetector> createState() =>
      _AgoraSwipeGestureDetectorState();
}

class _AgoraSwipeGestureDetectorState extends State<AgoraSwipeGestureDetector> {
  late Offset startPosition;
  late Offset lastPosition;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: widget.enable ? _horizontalDragStart : null,
      onHorizontalDragUpdate: widget.enable ? _horizontalDragUpdate : null,
      onHorizontalDragEnd: widget.enable ? _horizontalDragEnd : null,
      child: widget.child,
    );
  }

  void _horizontalDragStart(DragStartDetails details) {
    debugPrint("start:  ${details.toString()}");
    startPosition = details.localPosition;
    lastPosition = startPosition;
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    // debugPrint("update:  ${details.toString()}");
    lastPosition = details.localPosition;
  }

  void _horizontalDragEnd(DragEndDetails details) {
    final delta = lastPosition - startPosition;
    if (delta.dx > 0) {
      debugPrint("end: 左滑 ${delta.toString()}");
    } else {
      debugPrint("end: 右滑 ${delta.toString()}");
    }
  }
}
