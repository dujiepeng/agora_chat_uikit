import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

Widget defaultAvatar = AgoraImageLoader.defaultAvatar(width: 40, height: 40);

Widget userInfoAvatar(ChatUserInfo info) {
  return FadeInImage(
    placeholder: AgoraImageLoader.assetImage("avatar.png"),
    image: NetworkImage(info.avatarUrl ?? ""),
    placeholderErrorBuilder: (context, error, stackTrace) {
      return AgoraImageLoader.defaultAvatar();
    },
    imageErrorBuilder: (context, error, stackTrace) {
      return AgoraImageLoader.defaultAvatar();
    },
  );
}
