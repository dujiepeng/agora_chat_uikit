import 'package:flutter/widgets.dart';

import 'agora_swipe_gesture_controller.dart';

class AgoraSwipeChangeNotification extends Notification {
  AgoraSwipeChangeNotification(this.controller);
  final AgoraSwipeGestureController? controller;
}
