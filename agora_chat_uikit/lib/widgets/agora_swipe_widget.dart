import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';

class AgoraSwipeItem {
  const AgoraSwipeItem({
    required this.text,
    this.onTap,
    this.color = Colors.white,
    this.style = const TextStyle(color: Colors.white),
  });

  final void Function(ChatConversation)? onTap;
  final TextStyle style;
  final String text;
  final Color color;
}

class AgoraSwipeWidget extends StatefulWidget {
  const AgoraSwipeWidget({
    super.key,
    this.leftSwipeItems,
    this.rightSwipeItems,
    this.enable = true,
    required this.child,
  });

  final List<AgoraSwipeItem>? leftSwipeItems;
  final List<AgoraSwipeItem>? rightSwipeItems;
  final Widget child;
  final bool enable;

  @override
  State<AgoraSwipeWidget> createState() => _AgoraSwipeWidgetState();
}

class _AgoraSwipeWidgetState extends State<AgoraSwipeWidget>
    with TickerProviderStateMixin {
  late final AgoraSwipeGestureController controller;

  @override
  Widget build(BuildContext context) {
    controller = AgoraSwipeGestureController(this);
    return AgoraSwipeGestureDetector(
      enable: widget.enable,
      controller: controller,
      child: ValueListenableBuilder(
        valueListenable: controller.dxNotifier,
        builder: (BuildContext context, double value, Widget? child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    () {
                      if (widget.leftSwipeItems != null) {
                        return Row(children: () {
                          List<Widget> list = [];
                          for (var item in widget.leftSwipeItems!) {
                            list.add(
                              Container(
                                height: 500,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                color: item.color,
                                child: Center(
                                    child: Text(item.text, style: item.style)),
                              ),
                            );
                          }
                          return list;
                        }());
                      } else {
                        return const Offstage();
                      }
                    }(),
                    () {
                      if (widget.rightSwipeItems != null) {
                        return Row(children: () {
                          List<Widget> list = [];
                          for (var item in widget.rightSwipeItems!) {
                            list.add(
                              Container(
                                height: 500,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                color: item.color,
                                child: Center(
                                    child: Text(item.text, style: item.style)),
                              ),
                            );
                          }
                          return list;
                        }());
                      } else {
                        return const Offstage();
                      }
                    }(),
                  ],
                ),
              ),
              Positioned.fill(
                  top: 0,
                  bottom: 0,
                  left: value,
                  right: -value,
                  child: Container(color: Colors.white)),
              Positioned(
                top: 0,
                bottom: 0,
                left: value,
                right: -value,
                child: widget.child,
              )
            ],
          );
        },
      ),
    );
  }
}

class AgoraSwipeGestureController {
  AgoraSwipeGestureController(TickerProvider vsync)
      : _animationController = AnimationController(vsync: vsync);
  ValueNotifier<double> dxNotifier = ValueNotifier(0);
  ValueNotifier<Size> itemSizeNotifier = ValueNotifier(Size.zero);

  final AnimationController _animationController;

  void setDx(double value) {
    if (value == dxNotifier.value) return;
    dxNotifier.value = value;
  }

  void setItemSize(Size value) {
    if (value == itemSizeNotifier.value) return;
    itemSizeNotifier.value = value;
  }

  void pushToRight() {}
  void pushToLift() {}
  void close() {
    dxNotifier.value = 0;
  }
}

class AgoraSwipeGestureDetector extends StatefulWidget {
  const AgoraSwipeGestureDetector({
    super.key,
    this.enable = true,
    required this.child,
    required this.controller,
  });

  final bool enable;
  final Widget child;
  final AgoraSwipeGestureController controller;

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
    startPosition = details.localPosition;
    lastPosition = startPosition;
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    lastPosition = details.localPosition;
    widget.controller.setDx(lastPosition.dx - startPosition.dx);
  }

  void _horizontalDragEnd(DragEndDetails details) {
    final delta = lastPosition - startPosition;
    if (delta.dx > 0) {
      debugPrint("end: 左滑 ${delta.toString()}");
    } else {
      debugPrint("end: 右滑 ${delta.toString()}");
    }
    widget.controller.close();
  }
}

class _AgoraSwipeClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  Rect getApproximateClipRect(Size size) => getClip(size);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
