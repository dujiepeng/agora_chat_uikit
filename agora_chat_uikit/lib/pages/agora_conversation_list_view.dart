import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/controllers/agora_conversation_list_view_controller.dart';
import 'package:flutter/widgets.dart';
import '';

typedef AgoraConversationItemWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  ChatConversation conversation,
);

class AgoraConversationListView extends StatefulWidget {
  const AgoraConversationListView({
    super.key,
    this.controller,
    required this.itemBuilder,
    this.separatorBuilder,
    this.onUnreadCountChanged,
  });

  final void Function(int)? onUnreadCountChanged;
  final AgoraConversationListViewController? controller;
  final AgoraConversationItemWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  @override
  State<AgoraConversationListView> createState() =>
      AgoraConversationListViewState();
}

class AgoraConversationListViewState extends State<AgoraConversationListView> {
  List<ChatConversation> _convList = [];

  @override
  void initState() {
    super.initState();
    _loadAllConversations();
    ChatClient.getInstance.chatManager.addEventHandler("conversations",
        ChatEventHandler(
      onMessagesReceived: (messages) {
        _loadAllConversations();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      cacheExtent: 50,
      itemCount: _convList.length,
      itemBuilder: ((context, index) {
        return widget.itemBuilder(context, index, _convList[index]);
      }),
      separatorBuilder: (context, index) {
        return widget.separatorBuilder?.call(context, index) ??
            const Offstage();
      },
    );
  }

  void _loadAllConversations() {
    ChatClient.getInstance.chatManager.loadAllConversations().then((value) {
      debugPrint(value.length.toString());
      setState(() {
        _convList = value;
      });

      ChatClient.getInstance.chatManager
          .getUnreadMessageCount()
          .then((value) => widget.onUnreadCountChanged?.call(value));
    });
  }
}
