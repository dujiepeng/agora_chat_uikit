import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AgoraUnreadCountWidget extends StatelessWidget {
  const AgoraUnreadCountWidget({
    super.key,
    required this.unreadCount,
    this.maxCount = 99,
  });
  final int unreadCount;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: () {
        if (unreadCount == 0) {
          return const Offstage();
        } else if (unreadCount < 0) {
          return Container(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 20, 204, 1),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            width: 10,
            height: 10,
          );
        } else {
          String unreadStr = unreadCount.toString();
          if (unreadCount > maxCount) {
            unreadStr = '$maxCount+';
          }
          return Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 20, 204, 1),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              unreadStr,
            ),
          );
        }
      }(),
    );
  }
}
