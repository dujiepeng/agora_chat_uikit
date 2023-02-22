import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/widgets.dart';

class AgoraChatUIKit extends StatefulWidget {
  const AgoraChatUIKit({
    required this.child,
    super.key,
  });

  final Widget child;

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
  @override
  void initState() {
    super.initState();
    ChatClient.getInstance.startCallback();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void reloadAllConversations() {
    AgoraConversationListView.of(context).loadAllConversations();
  }
}
