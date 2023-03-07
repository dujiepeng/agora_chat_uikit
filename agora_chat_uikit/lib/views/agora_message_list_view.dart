import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:agora_chat_uikit/controllers/agora_base_controller.dart';

import 'package:flutter/material.dart';

class AgoraMessageListViewController extends AgoraBaseController {
  AgoraMessageListViewController(
    this.conversation, {
    super.key,
    this.sendReadAck = true,
  }) {
    _makeAllMessagesAsRead();
    _addChatManagerListener();
  }

  final bool sendReadAck;

  final List<AgoraMessageListItemModel> _oldList = [];
  final List<AgoraMessageListItemModel> _newList = [];
  ChatMessage? playingMessage;
  int _latestShowTsTime = -1;
  final ChatConversation conversation;
  bool _hasMore = true;
  bool _loading = false;
  bool hasFirstLoad = false;

  void _handleMessage(String msgId, ChatMessage message) {
    int index = -1;
    do {
      index = _newList.indexWhere((element) => msgId == element.msgId);
      if (index > -1) {
        _newList[index] = _newList[index].copyWith(message);
        break;
      }
      index = _oldList.indexWhere((element) => msgId == element.msgId);
      if (index > -1) {
        _oldList[index] = _oldList[index].copyWith(message);
      }
    } while (false);
    if (index > -1) {
      reloadData();
    }
  }

  void _addChatManagerListener() {
    ChatClient.getInstance.chatManager.addMessageEvent(
        key,
        ChatMessageEvent(
          onProgress: (msgId, progress) {},
          onSuccess: _handleMessage,
          onError: (msgId, msg, error) {
            _handleMessage.call(msgId, msg);
          },
        ));
    ChatClient.getInstance.chatManager.addEventHandler(
        key,
        ChatEventHandler(
          onMessagesRead: _updateMessageItems,
          onMessagesReceived: (messages) {
            List<ChatMessage> tmp = messages
                .where((element) => element.conversationId == conversation.id)
                .toList();

            _newList.addAll(tmp.map((e) => _modelCreator(e)).toList());
            reloadData();
          },
        ));
  }

  void _updateMessageItems(List<ChatMessage> list) {
    bool hasChange = false;

    for (var item in list) {
      int index = -1;
      do {
        index = _newList.indexWhere((element) => item.msgId == element.msgId);
        if (index > -1) {
          _newList[index] = AgoraMessageListItemModel(item);
          hasChange = true;
          break;
        }
        index = _oldList.indexWhere((element) => item.msgId == element.msgId);
        if (index > -1) {
          _oldList[index] = AgoraMessageListItemModel(item);
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

  void _makeAllMessagesAsRead() async {
    await conversation.markAllMessagesAsRead();
  }

  void sendMessage(ChatMessage message) async {
    int index = -1;
    do {
      index = _newList.indexWhere((element) => message.msgId == element.msgId);
      if (index > -1) {
        _newList.removeAt(index);
        break;
      }
      index = _oldList.indexWhere((element) => message.msgId == element.msgId);
      if (index > -1) {
        _oldList.removeAt(index);
      }
    } while (false);

    ChatMessage msg =
        await ChatClient.getInstance.chatManager.sendMessage(message);
    _newList.add(_modelCreator(msg));

    await moveToEnd();
  }

  void removeMessage(ChatMessage message) {
    int index = -1;
    do {
      index = _newList.indexWhere((element) => message.msgId == element.msgId);
      if (index >= 0) {
        _newList.removeAt(index);
        break;
      }
      index = _oldList.indexWhere((element) => message.msgId == element.msgId);
      if (index >= 0) {
        _oldList.removeAt(index);
        break;
      }
    } while (false);
    if (index >= 0) {
      reloadData();
    }
  }

  Future<void> loadMoreMessage([int count = 10]) async {
    if (_loading) return;
    _loading = true;
    if (!_hasMore) return;
    List<AgoraMessageListItemModel> tmpList = _oldList + _newList;
    List<ChatMessage> list = await conversation.loadMessages(
      startMsgId: tmpList.isEmpty ? "" : tmpList.first.msgId,
      loadCount: count,
    );
    if (list.length < count) {
      _hasMore = false;
    }

    List<AgoraMessageListItemModel> models = _modelsCreator(list, _hasMore);

    if (!hasFirstLoad) {
      _newList.addAll(models);
      hasFirstLoad = true;
    } else {
      _oldList.insertAll(0, models);
    }
    _loading = false;
    reloadData();
  }

  List<AgoraMessageListItemModel> _modelsCreator(
      List<ChatMessage> msgs, bool hasMore) {
    List<AgoraMessageListItemModel> list = [];
    for (var i = 0; i < msgs.length; i++) {
      if (i == 0 && !_hasMore) {
        _latestShowTsTime = msgs[i].serverTime;
        list.add(AgoraMessageListItemModel(msgs[i], true));
      } else {
        list.add(_modelCreator(msgs[i]));
      }
    }
    return list;
  }

  AgoraMessageListItemModel _modelCreator(ChatMessage message) {
    bool needShowTs = false;
    if (_latestShowTsTime < 0) {
      needShowTs = true;
    } else if ((message.serverTime - _latestShowTsTime).abs() > 120 * 1000) {
      needShowTs = true;
    }
    if (needShowTs == true) {
      _latestShowTsTime = message.serverTime;
    }
    return AgoraMessageListItemModel(message, needShowTs);
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

  void play(ChatMessage message) {
    playingMessage = message;
  }

  void stopPlay(ChatMessage message) {
    playingMessage = null;
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
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.avatarBuilder,
    this.showNameBuilder,
  });

  final ChatConversation conversation;
  final AgoraMessageListViewController? messageListViewController;
  final AgoraMessageListItemBuilder? itemBuilder;
  final AgoraMessageTapBuilder? onTap;
  final AgoraMessageTapBuilder? onBubbleLongPress;
  final AgoraMessageTapBuilder? onBubbleDoubleTap;
  final AgoraWidgetBuilder? avatarBuilder;
  final AgoraWidgetBuilder? showNameBuilder;

  @override
  State<AgoraMessageListView> createState() => _AgoraMessageListViewState();
}

class _AgoraMessageListViewState extends State<AgoraMessageListView>
    with WidgetsBindingObserver {
  late AgoraMessageListViewController controller;

  final ScrollController _scrollController = ScrollController();
  late final ValueKey _centerKey;
  bool _hasLongPress = false;

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
      _scrollController.jumpTo(200);
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
    if (!_hasLongPress) return;
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
    List<AgoraMessageListItemModel> oldList = controller._oldList;
    List<AgoraMessageListItemModel> newList = controller._newList;
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

  Widget messageWidget(AgoraMessageListItemModel model) {
    ChatMessage message = model.message;
    if (controller.sendReadAck) {
      sendReadAck(message);
    }

    Widget content = widget.itemBuilder?.call(context, model.message) ??
        () {
          if (message.body.type == MessageType.TXT) {
            return AgoraMessageListTextItem(
              model: model,
              onTap: widget.onTap,
              onBubbleDoubleTap: widget.onBubbleDoubleTap,
              onBubbleLongPress: (ctx, msg) async {
                _hasLongPress = true;
                widget.onBubbleLongPress?.call(ctx, msg);
                _hasLongPress = false;
              },
              onResendTap: () => resendMsg(message),
            );
          } else if (message.body.type == MessageType.IMAGE) {
            return AgoraMessageListImageItem(
              model: model,
              onTap: widget.onTap,
              onBubbleDoubleTap: widget.onBubbleDoubleTap,
              onBubbleLongPress: widget.onBubbleLongPress,
              onResendTap: () => resendMsg(message),
            );
          } else if (message.body.type == MessageType.FILE) {
            return AgoraMessageListFileItem(
              model: model,
              onTap: widget.onTap,
              onBubbleDoubleTap: widget.onBubbleDoubleTap,
              onBubbleLongPress: widget.onBubbleLongPress,
              onResendTap: () => resendMsg(message),
            );
          } else if (message.body.type == MessageType.VOICE) {
            return AgoraMessageListVoiceItem(
              model: model,
              onTap: widget.onTap,
              onBubbleDoubleTap: widget.onBubbleDoubleTap,
              onBubbleLongPress: widget.onBubbleLongPress,
              onResendTap: () => resendMsg(message),
              isPlay: controller.playingMessage?.msgId == message.msgId,
            );
          }

          return Container(width: 100, height: 100, color: Colors.red);
        }();

    return content;
  }

  void resendMsg(ChatMessage message) {
    controller.sendMessage(message);
  }

  void sendReadAck(ChatMessage message) async {
    if (message.body.type == MessageType.VIDEO ||
        message.body.type == MessageType.VOICE) {
      return;
    }
    if (message.direction == MessageDirection.RECEIVE) {
      if (message.chatType == ChatType.Chat && !message.hasReadAck) {
        debugPrint("send read ack, msgId: ${message.msgId}");
        try {
          ChatClient.getInstance.chatManager.sendMessageReadAck(message);
        } catch (e) {
          debugPrint("send read ack error, msgId: ${message.msgId}");
        }
      }
    }
  }

  void markMessageAsRead(ChatMessage message) {
    if (message.direction == MessageDirection.RECEIVE) {
      controller.conversation.markMessageAsRead(message.msgId);
    }
  }
}
