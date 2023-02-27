import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef AgoraConversationItemWidgetBuilder = Widget? Function(
  BuildContext context,
  int index,
  ChatConversation conversation,
);

typedef AgoraWidgetBuilder = Widget? Function(
  BuildContext context,
  String conversationId,
  ChatConversationType type,
);

class AgoraConversationListView extends StatefulWidget {
  const AgoraConversationListView({
    super.key,
    this.onItemTap,
    this.conversationListController,
    this.controller,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.down,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.itemBuilder,
    this.avatarBuilder,
    this.showNameBuilder,
  });

  final AgoraConversationListController? conversationListController;
  final ScrollController? controller;
  final AgoraConversationItemWidgetBuilder? itemBuilder;
  final AgoraWidgetBuilder? avatarBuilder;
  final AgoraWidgetBuilder? showNameBuilder;

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
  final void Function(ChatConversation conversation)? onItemTap;
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
  late final AgoraConversationListController controller;
  @override
  void initState() {
    super.initState();
    controller =
        widget.conversationListController ?? AgoraConversationListController();
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
    controller.addListListener(_handleDataSourceUpdate);
  }

  void _deleteDataSourceHandle() {
    controller.removeListListener(_handleDataSourceUpdate);
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
              scrollDirection: Axis.vertical,
              reverse: widget.reverse,
              controller: widget.controller,
              primary: widget.primary,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  ChatConversation conversation = _tmpList[index];
                  return widget.itemBuilder
                          ?.call(context, index, conversation) ??
                      AgoraSwipeWidget(
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
                            confirmAction: (_) async {
                              return await showModalBottomSheet(
                                    elevation: 300,
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 300,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Divider(height: 40),
                                            const Text(
                                              "删除会话?",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const Divider(height: 40),
                                            InkWell(
                                              child: const Text(
                                                "确定",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              onTap: () => Navigator.of(context)
                                                  .pop(AgoraSwipeItemAction
                                                      .dismiss),
                                            ),
                                            const Divider(height: 40),
                                            InkWell(
                                              child: const Text(
                                                "取消",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              onTap: () => Navigator.of(context)
                                                  .pop(AgoraSwipeItemAction
                                                      .close),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ) ??
                                  AgoraSwipeItemAction.close;
                            },
                          ),
                        ],
                        child: Container(
                          color: Colors.white,
                          child: AgoraConversationListTile(
                            avatar: Container(
                              width: 50,
                              height: 50,
                              color: Colors.red,
                            ),
                            conversation: conversation,
                            onTap: (conversation) {
                              if (widget.onItemTap != null) {
                                widget.onItemTap?.call(
                                  conversation,
                                );
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return AgoraMessagesPage(
                                      conversation: conversation,
                                    );
                                  },
                                )).then((value) =>
                                    controller.loadAllConversations());
                              }
                            },
                          ),
                        ),
                      );
                },
                semanticIndexCallback: (Widget _, int index) => index,
                findChildIndexCallback: (key) {
                  final ValueKey<String> valueKey = key as ValueKey<String>;
                  int index = _tmpList.indexWhere(
                      (conversation) => conversation.id == valueKey.value);

                  return index > -1 ? index : null;
                },
                childCount: _tmpList.length,
              ),
              cacheExtent: widget.cacheExtent,
              dragStartBehavior: widget.dragStartBehavior,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              restorationId: widget.restorationId,
              clipBehavior: widget.clipBehavior,
            ),
    );
  }
}
