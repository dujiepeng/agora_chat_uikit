import 'package:flutter/gestures.dart';
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

class AgoraSwipeWidget extends StatefulWidget {
  const AgoraSwipeWidget({
    super.key,
    this.leftSwipeItems,
    this.rightSwipeItems,
    this.enable = true,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.index,
    required this.child,
  });

  final List<AgoraSwipeItem>? leftSwipeItems;
  final List<AgoraSwipeItem>? rightSwipeItems;
  final Widget child;
  final int index;
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
  Widget build(BuildContext context) {
    List<Widget> leftWidgets = [];
    widget.leftSwipeItems?.forEach((element) {
      leftWidgets.add(InkWell(
        onTap: () {
          element.onTap?.call(widget.index);
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

    List<Widget> rightWidgets = [];
    widget.rightSwipeItems?.forEach((element) {
      rightWidgets.add(InkWell(
        onTap: () {
          element.onTap?.call(widget.index);
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
            child: widget.child,
          ),
        ],
      ),
      onWillPop: () async {
        if (controller.dxNotifier.value != 0) {
          controller.scrollEnd();
          return false;
        }
        return true;
      },
    );
  }
}

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

  double leftDragDistance;
  double rightDragDistance;

  late AnimationController animationController;

  final Map<Type, GestureRecognizerFactory> gestures =
      <Type, GestureRecognizerFactory>{};
  ValueNotifier<double> dxNotifier = ValueNotifier(0);

  void setDx(double dx) {
    dxNotifier.value =
        (dxNotifier.value + dx).clamp(-rightDragDistance, leftDragDistance);
  }

  void scrollEnd() {
    animationController.value = dxNotifier.value;
    double target = 0;

    if (animationController.value > leftDragDistance / 2) {
      target = leftDragDistance;
    } else if (animationController.value < -rightDragDistance / 2) {
      target = -rightDragDistance;
    }
    animationController.animateBack(target, curve: Curves.ease);
  }

  void close() {
    animationController.value = dxNotifier.value;
    animationController.animateBack(0, curve: Curves.ease);
  }
}

class AgoraSwipeGestureDetector extends StatefulWidget {
  const AgoraSwipeGestureDetector(
      {super.key,
      this.enable = true,
      required this.child,
      required this.controller,
      this.dragStartBehavior = DragStartBehavior.start});

  final bool enable;
  final Widget child;
  final AgoraSwipeGestureController controller;
  final DragStartBehavior dragStartBehavior;

  @override
  State<AgoraSwipeGestureDetector> createState() =>
      _AgoraSwipeGestureDetectorState();
}

class _AgoraSwipeGestureDetectorState extends State<AgoraSwipeGestureDetector> {
  late Offset startPosition;
  late Offset lastPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: !widget.enable ? null : _horizontalDragDown,
      onPanUpdate: !widget.enable ? null : _horizontalDragUpdate,
      onPanEnd: !widget.enable ? null : _horizontalDragEnd,
      child: ValueListenableBuilder(
        valueListenable: widget.controller.dxNotifier,
        builder: (BuildContext context, double value, Widget? child) {
          return Transform.translate(
            offset: Offset(value, 0),
            child: widget.child,
          );
        },
      ),
    );
  }

  void _horizontalDragDown(DragDownDetails details) {
    startPosition = details.localPosition;
    lastPosition = startPosition;
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    widget.controller.setDx(details.delta.dx);
  }

  void _horizontalDragEnd(DragEndDetails details) {
    widget.controller.scrollEnd();
  }
}
