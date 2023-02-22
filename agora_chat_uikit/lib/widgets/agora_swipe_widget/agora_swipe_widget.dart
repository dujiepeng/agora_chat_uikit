import 'package:flutter/material.dart';

export 'agora_swipe_gesture_controller.dart';
export 'agora_swipe_gesture_detector.dart';
export 'agora_swipe_item.dart';
export 'agora_swipe_scrolling_close_behavior.dart';
export 'agora_swipe_auto_close_behavior.dart';

import 'agora_swipe_gesture_controller.dart';
import 'agora_swipe_gesture_detector.dart';
import 'agora_swipe_item.dart';
import 'agora_swipe_scrolling_close_behavior.dart';

class AgoraSwipeWidget extends StatefulWidget {
  const AgoraSwipeWidget({
    super.key,
    this.leftSwipeItems,
    this.rightSwipeItems,
    this.enable = true,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.child,
  });

  final List<AgoraSwipeItem>? leftSwipeItems;
  final List<AgoraSwipeItem>? rightSwipeItems;
  final Widget child;
  final bool enable;
  final Duration animationDuration;

  @override
  State<AgoraSwipeWidget> createState() => _AgoraSwipeWidgetState();
}

class _AgoraSwipeWidgetState extends State<AgoraSwipeWidget>
    with TickerProviderStateMixin {
  late final AgoraSwipeGestureController controller;

  double maxLeftDragDistance = 0;
  double maxRightDragDistance = 0;

  @override
  void initState() {
    super.initState();

    widget.leftSwipeItems?.forEach((element) {
      maxLeftDragDistance += element.itemWidth;
    });

    widget.rightSwipeItems?.forEach((element) {
      maxRightDragDistance += element.itemWidth;
    });

    controller = AgoraSwipeGestureController(
      this,
      duration: widget.animationDuration,
      rightDragDistance: maxRightDragDistance,
      leftDragDistance: maxLeftDragDistance,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> leftWidgets = [];
    widget.leftSwipeItems?.forEach((element) {
      leftWidgets.add(InkWell(
        onTap: () {
          element.onTap?.call();
          controller.close();
        },
        child: Container(
          alignment: Alignment.center,
          width: element.itemWidth,
          color: element.backgroundColor,
          child: Text(
            element.text,
            style: element.style,
          ),
        ),
      ));
    });

    Widget leftWidget =
        leftWidgets.isNotEmpty ? Row(children: leftWidgets) : const Offstage();

    final List<Widget> rightWidgets = [];
    widget.rightSwipeItems?.forEach((element) {
      rightWidgets.add(InkWell(
        onTap: () {
          element.onTap?.call();
          controller.close();
        },
        child: Container(
          width: element.itemWidth,
          alignment: Alignment.center,
          color: element.backgroundColor,
          child: Text(
            element.text,
            style: element.style,
          ),
        ),
      ));
    });

    Widget rightWidget = rightWidgets.isNotEmpty
        ? Row(children: rightWidgets)
        : const Offstage();

    return WillPopScope(
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [leftWidget, rightWidget],
            ),
          ),
          AgoraSwipeGestureDetector(
            enable: widget.enable,
            controller: controller,
            child: AgoraSwipeScrollingCloseBehavior(
              controller: controller,
              child: widget.child,
            ),
          ),
        ],
      ),
      onWillPop: () async {
        if (controller.dxNotifier.value != 0) {
          controller.scrollEnd(context);
          return false;
        }
        return true;
      },
    );
  }
}
