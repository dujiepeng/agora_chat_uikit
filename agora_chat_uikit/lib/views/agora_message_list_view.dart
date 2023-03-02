import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:agora_chat_uikit/controllers/agora_base_controller.dart';

import 'package:flutter/material.dart';

class AgoraMessageListViewController extends AgoraBaseController {
  AgoraMessageListViewController(this.conversation, {super.key}) {
    _makeAllMessagesAsRead();
    _addChatManagerListener();
  }

  final List<ChatMessage> _oldList = [];
  final List<ChatMessage> _newList = [];

  bool _hasMore = true;
  bool _loading = false;
  bool hasFirstLoad = false;

  void _addChatManagerListener() {
    ChatClient.getInstance.chatManager.addMessageEvent(
        key,
        ChatMessageEvent(
          onProgress: (msgId, progress) {},
          onSuccess: (msgId, msg) {
            int index = -1;
            do {
              index = _newList.indexWhere((element) => msgId == element.msgId);
              if (index > -1) {
                _newList[index] = msg;
                break;
              }
              index = _oldList.indexWhere((element) => msgId == element.msgId);
              if (index > -1) {
                _oldList[index] = msg;
              }
            } while (false);
            if (index > -1) {
              reloadData();
            }
          },
          onError: (msgId, msg, error) {},
        ));
    ChatClient.getInstance.chatManager.addEventHandler(
        key,
        ChatEventHandler(
          onMessagesRead: _updateMessageItems,
          onMessagesReceived: (messages) {
            List<ChatMessage> tmp = messages
                .where((element) => element.conversationId == conversation.id)
                .toList();
            _newList.addAll(tmp);
            reloadData();
          },
          // onMessagesDelivered: _updateMessageItems,
        ));
  }

  void _updateMessageItems(List<ChatMessage> list) {
    bool hasChange = false;

    for (var item in list) {
      int index = -1;
      do {
        index = _newList.indexWhere((element) => item.msgId == element.msgId);
        if (index > -1) {
          _newList[index] = item;
          hasChange = true;
          break;
        }
        index = _oldList.indexWhere((element) => item.msgId == element.msgId);
        if (index > -1) {
          _oldList[index] = item;
        }
        hasChange = true;
      } while (false);
    }
    if (hasChange) {
      reloadData();
    }
  }

  void _remoteChatManagerListener() {
    ChatClient.getInstance.chatManager.removeEventHandler(key);
    ChatClient.getInstance.chatManager.removeMessageEvent(key);
  }

  final ChatConversation conversation;

  void _makeAllMessagesAsRead() async {
    await conversation.markAllMessagesAsRead();
  }

  void sendMessage(ChatMessage message) async {
    ChatClient.getInstance.chatManager.sendMessage(message);
    _newList.add(message);
    await moveToEnd();
  }

  void removeMessage(ChatMessage message) {}

  Future<void> loadMoreMessage([int count = 10]) async {
    if (_loading) return;
    _loading = true;
    if (!_hasMore) return;
    List<ChatMessage> tmpList = _oldList + _newList;
    List<ChatMessage> list = await conversation.loadMessages(
      startMsgId: tmpList.isEmpty ? "" : tmpList.first.msgId,
      loadCount: count,
    );
    if (list.length < count) {
      _hasMore = false;
    }
    if (!hasFirstLoad) {
      _newList.addAll(list);
      hasFirstLoad = true;
    } else {
      _oldList.insertAll(0, list);
    }
    _loading = false;
    reloadData();
  }

  Future<void> Function([int milliseconds])? _moveToEnd;
  Future<void> Function()? _reloadData;

  void _bindingActions({
    Future<void> Function([int milliseconds])? moveToEnd,
    Future<void> Function()? reloadData,
  }) {
    _moveToEnd = moveToEnd;
    _reloadData = reloadData;
  }

  Future<void>? moveToEnd([int milliseconds = 50]) {
    return _moveToEnd?.call(milliseconds);
  }

  Future<void>? reloadData() {
    return _reloadData?.call();
  }

  void dispose() {
    _remoteChatManagerListener();
  }
}

class AgoraMessageListView extends StatefulWidget {
  const AgoraMessageListView({
    super.key,
    required this.conversation,
    this.messageListViewController,
    this.itemBuilder,
  });

  final ChatConversation conversation;
  final AgoraMessageListViewController? messageListViewController;
  final AgoraMessageListItemBuilder? itemBuilder;

  @override
  State<AgoraMessageListView> createState() => _AgoraMessageListViewState();
}

class _AgoraMessageListViewState extends State<AgoraMessageListView>
    with WidgetsBindingObserver {
  late AgoraMessageListViewController controller;

  final ScrollController _scrollController = ScrollController();
  late final ValueKey _centerKey;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _centerKey = ValueKey(widget.conversation.id);
    _scrollController.addListener(scrollListener);

    controller = widget.messageListViewController ??
        AgoraMessageListViewController(
          widget.conversation,
        );

    controller._bindingActions(
      moveToEnd: _moveToEnd,
      reloadData: _reloadData,
    );

    controller.loadMoreMessage();
  }

  Future<void> _moveToEnd([int milliseconds = 50]) async {
    setState(() {});
    if (_scrollController.position.extentAfter > 200) {
      _scrollController.jumpTo(_scrollController.position.extentAfter - 200);
    }

    _scrollToEnd(milliseconds);
  }

  Future<void> _reloadData() async {
    setState(() {});
    if (_scrollController.position.extentAfter == 0) {
      await _scrollToEnd(100);
    }
  }

  Future<void> _scrollToEnd([int milliseconds = 50]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 80),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  void didUpdateWidget(covariant AgoraMessageListView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() async {
    if (_scrollController.position.extentBefore == 0) {
      controller.loadMoreMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> oldList = controller._oldList;
    List<ChatMessage> newList = controller._newList;
    return Opacity(
      opacity: controller.hasFirstLoad ? 1 : 0,
      child: Scrollbar(
        child: CustomScrollView(
          center: _centerKey,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  debugPrint("index $index");
                  return messageWidget(oldList[oldList.length - 1 - index]);
                },
                childCount: oldList.length,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.zero,
              key: _centerKey,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return messageWidget(newList[index]);
                },
                childCount: newList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageWidget(ChatMessage message) {
    return widget.itemBuilder?.call(context, message) ??
        () {
          if (message.body.type == MessageType.TXT) {
            return AgoraMessageListTextItem(message: message);
          } else if (message.body.type == MessageType.IMAGE) {}

          return Container(width: 100, height: 100, color: Colors.red);
        }();
  }
}
