import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

class UserInfoManager {
  static UserInfoManager? _instance;
  static UserInfoManager get instance => _instance ??= UserInfoManager._();

  final Map<String, ChatUserInfo> _infoMap = {};

  UserInfoManager._();

  static ChatUserInfo? getUserInfo(
    String userId, [
    VoidCallback? finish,
  ]) {
    if (UserInfoManager.instance._infoMap.containsKey(userId)) {
      return UserInfoManager.instance._infoMap[userId];
    }
    UserInfoManager.instance.fetchUserInfo([userId], finish);
    return null;
  }

  static Future<Map<String, ChatUserInfo>> getUserInfoList(List<String> userIds,
      [VoidCallback? finish]) async {
    return await UserInfoManager.instance.fetchUserInfo(userIds, finish);
  }

  Future<Map<String, ChatUserInfo>> fetchUserInfo(
      List<String> userIds, VoidCallback? finish) async {
    Map<String, ChatUserInfo> map =
        await ChatClient.getInstance.userInfoManager.fetchUserInfoById(
      userIds,
      expireTime: 3600,
    );
    _infoMap.addAll(map);
    finish?.call();
    return map;
  }
}
