import 'package:flutter/material.dart';

import 'agora_swipe_change_notification.dart';

class AgoraSwipeGestureController {
  AgoraSwipeGestureController(
    TickerProvider vsync, {
    this.leftDragDistance = 0,
    this.rightDragDistance = 0,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    animationController = AnimationController(
        upperBound: leftDragDistance,
        lowerBound: -rightDragDistance,
        vsync: vsync,
        duration: duration)
      ..addListener(() {
        dxNotifier.value = animationController.value;
      });
  }

  void dispose() {
    animationController.dispose();
  }

  double leftDragDistance = 0;
  double rightDragDistance = 0;

  late AnimationController animationController;

  final Map<Type, GestureRecognizerFactory> gestures =
      <Type, GestureRecognizerFactory>{};
  ValueNotifier<double> dxNotifier = ValueNotifier(0);

  void setDx(double dx) {
    dxNotifier.value =
        (dxNotifier.value + dx).clamp(-rightDragDistance, leftDragDistance);
  }

  void startMove(BuildContext context) {
    AgoraSwipeChangeNotification(this).dispatch(context);
  }

  void willClear(BuildContext context) {
    AgoraSwipeControllerClearNotification(this).dispatch(context);
  }

  void scrollEnd(BuildContext context, {double speed = 0}) {
    animationController.value = dxNotifier.value;
    double target = 0.0;

    if (animationController.value > leftDragDistance / 2) {
      target = leftDragDistance;
    } else if (animationController.value < -rightDragDistance / 2) {
      target = -rightDragDistance;
    }
    if (target == animationController.value) return;
    animationController.animateBack(target, curve: Curves.linear);
  }

  void close() {
    if (dxNotifier.value == 0) {
      return;
    }

    animationController.value = dxNotifier.value;
    animationController.animateBack(0, curve: Curves.ease);
  }
}
