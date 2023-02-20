import 'dart:math';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../controllers/agora_conversation_list_view_controller.dart';

import '../widgets/agora_conversation_list_tile.dart';

import '../widgets/agora_swipe_widget/agora_swipe_widget.dart';

typedef AgoraConversationItemWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  ChatConversation conversation,
);

typedef AgoraChatMessagePageBuilder = Widget Function(
  BuildContext context,
  ChatConversation conversation,
);

class AgoraConversationListView extends StatefulWidget {
  const AgoraConversationListView({
    super.key,
    this.onTap,
    this.onUnreadCountChanged,
    this.conversationListController,
    this.controller,
    this.separatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });

  final void Function(int)? onUnreadCountChanged;
  final AgoraConversationListViewController? conversationListController;

  final ScrollController? controller;
  // final AgoraConversationItemWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final int? Function(Key)? findChildIndexCallback;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final void Function(ChatConversation conversation)? onTap;
  @override
  State<AgoraConversationListView> createState() =>
      AgoraConversationListViewState();

  static AgoraConversationListViewState of(BuildContext context) {
    AgoraConversationListViewState? state;
    state = context.findAncestorStateOfType<AgoraConversationListViewState>();

    assert(
      state != null,
      'You must have a AgoraConversationListView widget at the top of you widget tree',
    );

    return state!;
  }
}

class AgoraConversationListViewState extends State<AgoraConversationListView> {
  List<ChatConversation> _convList = [];

  @override
  void initState() {
    super.initState();
    loadAllConversations();
    ChatClient.getInstance.chatManager.addEventHandler(
      "conversations",
      ChatEventHandler(
        onMessagesReceived: (messages) async {
          loadAllConversations();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AgoraSwipeAutoCloseBehavior(
      child: _convList.isEmpty
          ? const Center(
              child: Text("No conversations"),
            )
          : ListView.custom(
              // key: Key('messageListView'),
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              controller: widget.controller,
              primary: widget.primary,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              childrenDelegate: SliverChildBuilderDelegate(
                findChildIndexCallback: (key) {
                  final ValueKey<String> valueKey = key as ValueKey<String>;
                  return _convList.indexWhere(
                      (conversation) => conversation.id == valueKey.value);
                },
                childCount: _convList.length,
                (context, index) {
                  ChatConversation conversation = _convList[index];
                  return AgoraSwipeWidget(
                    key: ValueKey(conversation.id),
                    rightSwipeItems: [
                      AgoraSwipeItem(
                          onTap: (index) async {
                            try {
                              await ChatClient.getInstance.chatManager
                                  .deleteConversation(
                                      _convList.removeAt(index).id);
                              setState(() {});
                            } on ChatError catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                          backgroundColor: Colors.red,
                          text: "删除")
                    ],
                    index: index,
                    child: Container(
                      color: Colors.white,
                      child: AgoraConversationListTile(
                        key: Key(conversation.id),
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.red,
                        ),
                        conversation: conversation,
                        onTap: (conversation) =>
                            widget.onTap?.call(conversation),
                      ),
                    ),
                  );
                },
              ),
              cacheExtent: widget.cacheExtent,
              dragStartBehavior: widget.dragStartBehavior,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              restorationId: widget.restorationId,
              clipBehavior: widget.clipBehavior,
            ),
    );
  }

  void loadAllConversations() {
    ChatClient.getInstance.chatManager.loadAllConversations().then((value) {
      if (mounted) {
        setState(() {
          _convList = value;
        });
      }

      ChatClient.getInstance.chatManager
          .getUnreadMessageCount()
          .then((value) => widget.onUnreadCountChanged?.call(value));
    });
  }
}
