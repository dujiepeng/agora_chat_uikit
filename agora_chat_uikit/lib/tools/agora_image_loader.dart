import 'package:flutter/material.dart';

class AgoraImageLoader {
  static Image loadImage(name, {double? width, double? height}) {
    return Image.asset(
      "images/$name",
      width: width,
      height: height,
      fit: BoxFit.fill,
      package: "agora_chat_uikit",
    );
  }

  static ImageProvider<Object> assetImage(String name) {
    return AssetImage("images/$name", package: "agora_chat_uikit");
  }

  static Widget defaultAvatar({
    double width = 30,
    double height = 30,
  }) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      )),
      child: loadImage("avatar.png"),
    );
  }
}
