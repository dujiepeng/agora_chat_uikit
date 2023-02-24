import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../controllers/agora_conversation_list_view_controller.dart';

import '../widgets/agora_conversation_list_tile.dart';

import '../widgets/agora_swipe_widget/agora_swipe_widget.dart';

typedef AgoraConversationItemWidgetBuilder = Widget? Function(
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
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.builder,
  });

  final void Function(int)? onUnreadCountChanged;
  final AgoraConversationListViewController? conversationListController;
  final ScrollController? controller;
  final AgoraConversationItemWidgetBuilder? builder;

  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

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
  late final AgoraConversationListViewController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.conversationListController ??
        AgoraConversationListViewController();
    _addDataSourceHandle();
  }

  @override
  void dispose() {
    _deleteDataSourceHandle();
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AgoraConversationListView oldWidget) {
    _deleteDataSourceHandle();
    _addDataSourceHandle();
    super.didUpdateWidget(oldWidget);
  }

  void _addDataSourceHandle() {
    controller.registerNotifier(_handleDataSourceUpdate);
  }

  void _deleteDataSourceHandle() {
    controller.unregisterNotifier(_handleDataSourceUpdate);
  }

  void _handleDataSourceUpdate() {
    setState(() {});
  }

  final List<ChatConversation> _tmpList = [];

  @override
  Widget build(BuildContext context) {
    _tmpList.clear();
    _tmpList.addAll(controller.conversationList);

    return AgoraSwipeAutoCloseBehavior(
      child: _tmpList.isEmpty
          ? const Center(
              child: Text("No conversations"),
            )
          : ListView.custom(
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              controller: widget.controller,
              primary: widget.primary,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              childrenDelegate: SliverChildBuilderDelegate(
                semanticIndexCallback: (Widget _, int index) => index,
                findChildIndexCallback: (key) {
                  final ValueKey<String> valueKey = key as ValueKey<String>;
                  int index = _tmpList.indexWhere(
                      (conversation) => conversation.id == valueKey.value);

                  return index > -1 ? index : null;
                },
                childCount: _tmpList.length,
                (context, index) {
                  ChatConversation conversation = _tmpList[index];
                  return widget.builder?.call(context, index, conversation) ??
                      () {
                        return AgoraSwipeWidget(
                          key: ValueKey(conversation.id),
                          rightSwipeItems: [
                            AgoraSwipeItem(
                              didAction: (AgoraSwipeItemAction action) async {
                                if (action == AgoraSwipeItemAction.dismiss) {
                                  {
                                    await controller.deleteConversationWithId(
                                        conversation.id);
                                  }
                                }
                              },
                              backgroundColor: Colors.red,
                              text: "删除",
                              confirmAction: () async {
                                return await showDialog<AgoraSwipeItemAction>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Are you sure?'),
                                          content: const Text(
                                              'Are you sure to dismiss?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    AgoraSwipeItemAction
                                                        .dismiss);
                                              },
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    AgoraSwipeItemAction.close);
                                              },
                                              child: const Text('No'),
                                            ),
                                          ],
                                        );
                                      },
                                    ) ??
                                    AgoraSwipeItemAction.close;
                              },
                            ),
                            // AgoraSwipeItem(text: "test"),
                          ],
                          child: Container(
                            color: Colors.white,
                            child: AgoraConversationListTile(
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
                      }();
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
    controller.loadAllConversations();
  }
}
