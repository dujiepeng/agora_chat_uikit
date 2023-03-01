import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:flutter/material.dart';

class AgoraMessageListViewController {
  AgoraMessageListViewController(this.conversation) {
    _makeAllMessagesAsRead();
  }

  final ChatConversation conversation;
  AgoraMessageListActions? action;

  void _makeAllMessagesAsRead() async {
    await conversation.markAllMessagesAsRead();
  }

  void _addListener(AgoraMessageListActions action) {
    this.action = action;
  }

  void moveToEnd() {
    action?.onScrollEnd();
  }

  void moveToBegin() {
    action?.onScrollBegin();
  }

  void dispose() {
    action = null;
  }
}

class AgoraMessageListActions {
  const AgoraMessageListActions({
    required this.onScrollEnd,
    required this.onScrollBegin,
  });
  final VoidCallback onScrollEnd;
  final VoidCallback onScrollBegin;
}

class AgoraMessageListView extends StatefulWidget {
  AgoraMessageListView(
      {super.key,
      required this.conversation,
      AgoraMessageListViewController? controller})
      : messageListViewController =
            controller ?? AgoraMessageListViewController(conversation);

  final ChatConversation conversation;
  final AgoraMessageListViewController messageListViewController;

  @override
  State<AgoraMessageListView> createState() => _AgoraMessageListViewState();
}

class _AgoraMessageListViewState extends State<AgoraMessageListView> {
  final List<ChatMessage> _newList = [];
  final List<ChatMessage> _oldList = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _scrolled = false;

  final ScrollController _scrollController = ScrollController();
  late final ValueKey _centerKey;

  @override
  void initState() {
    super.initState();
    _centerKey = ValueKey(widget.conversation.id);
    _scrollController.addListener(scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      loadMoreMessage(
        firstLoad: true,
        callback: () {
          Future.delayed(const Duration(milliseconds: 100)).then((value) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
            setState(() => _scrolled = true);
          });
        },
      );
    });

    widget.messageListViewController._addListener(AgoraMessageListActions(
      onScrollEnd: _scrollToEnd,
      onScrollBegin: () {
        debugPrint("scroll begin");
      },
    ));
  }

  void _scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 400), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    widget.messageListViewController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() async {
    if (_scrollController.position.extentBefore == 0) {
      await loadMoreMessage();
    }
  }

  Future<void> loadMoreMessage({
    bool firstLoad = false,
    int count = 20,
    VoidCallback? callback,
  }) async {
    if (!_hasMore || _isLoading) return;
    List<ChatMessage> list = [];
    if (firstLoad) {
      list = await widget.conversation.loadMessages(loadCount: count);
      _newList.addAll(list);
    } else {
      List<ChatMessage> tmpMsgList = _oldList + _newList;
      list = await widget.conversation.loadMessages(
        loadCount: count,
        startMsgId: tmpMsgList.isEmpty ? "" : tmpMsgList.first.msgId,
      );
      _oldList.insertAll(0, list);
    }
    if (list.length < count) {
      _hasMore = false;
    }
    _isLoading = false;
    debugPrint("load!!!");
    setState(() {
      callback?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _scrolled ? 1 : 0,
      child: CustomScrollView(
        center: _centerKey,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return messageWidget(_oldList[index]);
              },
              childCount: _oldList.length,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.zero,
            key: _centerKey,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return messageWidget(_newList[index]);
              },
              childCount: _newList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget messageWidget(ChatMessage message) {
    ChatTextMessageBody body = message.body as ChatTextMessageBody;
    return SizedBox(
      height: 80,
      child: Center(
        child: Text(body.content),
      ),
    );
  }
}
