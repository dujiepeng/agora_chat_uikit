library agora_chat_uikit;

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/widgets.dart';

export 'agora_chat_uikit_theme.dart';
export 'agora_chat_define.dart';
export 'controllers/agora_chat_uikit_controller.dart';

export 'controllers/agora_contact_list_view_controller.dart';

export 'generated/agora_chat_uikit_localizations.dart';

export 'models/agora_message_model.dart';

export 'pages/agora_messages_page.dart';

export 'tools/agora_extension.dart';
export 'tools/agora_tools.dart';
export 'tools/agora_image_loader.dart';

export 'views/agora_contact_list_view.dart';
export 'views/agora_message_list_view.dart';
export 'views/agora_conversation_list_view.dart';

export 'widgets/agora_conversation_list_tile.dart';
export 'widgets/agora_badge_widget.dart';
export 'widgets/agora_swipe_widget/agora_swipe_widget.dart';
export 'widgets/agora_dialog_widget.dart';
export 'widgets/agora_bottom_sheet.dart';

export 'widgets/agora_message_input_widget/agora_message_input_widget.dart';
export 'widgets/agora_message_input_widget/agora_emoji_data.dart';
export 'widgets/agora_message_list_item/agora_message_bubble.dart';
export 'widgets/agora_message_list_item/agora_message_list_text_item.dart';
export 'widgets/agora_message_list_item/agora_message_list_image_item.dart';
export 'widgets/agora_message_list_item//agora_message_list_file_item.dart';
export 'widgets/agora_message_list_item/agora_message_list_voice_item.dart';

class AgoraChatUIKitSettings {
  AgoraChatUIKitSettings({
    this.enableUserData = true,
  });
  final bool enableUserData;
}

class AgoraChatUIKit extends StatefulWidget {
  const AgoraChatUIKit({
    required this.child,
    this.settings,
    super.key,
  });

  final Widget child;
  final AgoraChatUIKitSettings? settings;

  @override
  State<AgoraChatUIKit> createState() => AgoraChatUIKitState();

  static AgoraChatUIKitState of(BuildContext context) {
    AgoraChatUIKitState? state;
    state = context.findAncestorStateOfType<AgoraChatUIKitState>();
    assert(
      state != null,
      'You must have a AgoraChatUIKit widget at the top of you widget tree',
    );

    return state!;
  }
}

class AgoraChatUIKitState extends State<AgoraChatUIKit> {
  String? _userId;

  Future<ChatUserInfo?> get userInfo => _getUserInfo();

  Future<ChatUserInfo?> _getUserInfo() async {
    return ChatClient.getInstance.userInfoManager
        .fetchOwnInfo(expireTime: 1800);
  }

  @override
  void initState() {
    super.initState();
    assert(
      ChatClient.getInstance.options != null,
      'You must has init AgoraChat SDK.',
    );
    ChatClient.getInstance.startCallback();
    _userId = ChatClient.getInstance.currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  String? get currentUserId => _userId;
}
