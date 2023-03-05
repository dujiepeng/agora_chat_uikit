import 'package:flutter/material.dart';

extension AgoraUIKitThemeData on ThemeData {
  Color get appBarShadowColor => Colors.transparent;
  Color get appBarBackgroundColor => Colors.transparent;
  Color get appBarBackIconColor => Colors.black;
  TextStyle get appBarTitleTextStyle =>
      const TextStyle(fontWeight: FontWeight.w400, color: Colors.black);
  Color get agoraBadgeColor => const Color.fromRGBO(255, 20, 204, 1);
  Color get agoraBadgeBorderColor => Colors.white;
  TextStyle get agoraBadgeTextTheme =>
      const TextStyle(fontWeight: FontWeight.w500, color: Colors.white);
  double get agoraBadgeBorderWidth => 2.0;
  TextStyle get agoraMessagesListItemTs =>
      const TextStyle(color: Colors.grey, fontSize: 14);
  TextStyle get agoraBottomSheetItemLabelDefaultStyle => const TextStyle(
      fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black);
}
