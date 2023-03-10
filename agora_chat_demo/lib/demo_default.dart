import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

Widget defaultAvatar = AgoraImageLoader.defaultAvatar(width: 40, height: 40);

Widget userInfoAvatar(ChatUserInfo info, {double size = 30}) {
  return Container(
    width: size,
    height: size,
    decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    )),
    clipBehavior: Clip.hardEdge,
    child: info.avatarUrl == null
        ? AgoraImageLoader.defaultAvatar()
        : FadeInImage(
            placeholder: AgoraImageLoader.assetImage("avatar.png"),
            // use in local, in your app, need server uri.
            image: NetworkImage(info.avatarUrl ?? ""),
            placeholderErrorBuilder: (context, error, stackTrace) {
              return AgoraImageLoader.defaultAvatar();
            },
            imageErrorBuilder: (context, error, stackTrace) {
              return AgoraImageLoader.defaultAvatar();
            },
          ),
  );
}
