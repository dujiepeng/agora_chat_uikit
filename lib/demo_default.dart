import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

import 'tools/image_loader.dart';

Widget defaultAvatar = AgoraImageLoader.defaultAvatar(size: 40);

Widget userInfoAvatar(ChatUserInfo? info, {double size = 30}) {
  String avatarUrl = info?.avatarUrl ?? "";
  return Container(
    width: size,
    height: size,
    decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    )),
    clipBehavior: Clip.hardEdge,
    child: avatarUrl.isEmpty
        ? AgoraImageLoader.defaultAvatar()
        : FadeInImage(
            placeholder: AgoraImageLoader.assetImage("avatar.png"),
            // use in local, in your app, need server uri.
            image: AssetImage(ImageLoader.getImg("avatar$avatarUrl.png")),
            placeholderErrorBuilder: (context, error, stackTrace) {
              return AgoraImageLoader.defaultAvatar();
            },
            imageErrorBuilder: (context, error, stackTrace) {
              return AgoraImageLoader.defaultAvatar();
            },
          ),
  );
}
