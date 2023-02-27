import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:flutter/widgets.dart';
import 'agora_base_controller.dart';

typedef AgoraConversationSortHandle = Future<List<ChatConversation>> Function(
    List<ChatConversation> beforeList);

class AgoraConversationListController extends AgoraBaseController {
  AgoraConversationListController({
    super.key,
    this.sortHandle,
  }) {
    _addListener();
    loadAllConversations();
  }

  final AgoraConversationSortHandle? sortHandle;

  void loadAllConversations() async {
    debugPrint(ChatClient.getInstance.currentUserId);
    List<ChatConversation> list =
        await ChatClient.getInstance.chatManager.loadAllConversations();
    conversationList = await sortHandle?.call(list) ?? list;
  }

  final ValueNotifier<List<ChatConversation>> _listValueNotifier =
      ValueNotifier([]);
  final ValueNotifier<int> _totalUnreadCountNotifier = ValueNotifier(0);

  Future<void> deleteConversationWithId(String id) async {
    List<ChatConversation> list = conversationList;
    int index = list.indexWhere((element) => element.id == id);
    if (index >= 0) {
      list.removeAt(index);
      await ChatClient.getInstance.chatManager.deleteConversation(id);
      conversationList = await sortHandle?.call(list) ?? list;
    }
  }

  void deleteAllConversations({bool includeMessage = true}) async {
    List<ChatConversation> list = conversationList;
    await Future.wait(list
        .map((element) => ChatClient.getInstance.chatManager.deleteConversation(
              element.id,
              deleteMessages: includeMessage,
            ))).then((value) => conversationList = []);
    if (includeMessage) {
      _totalUnreadCountNotifier.value = 0;
    }
  }

  List<ChatConversation> get conversationList => _listValueNotifier.value;
  int get totalUnreadCount => _totalUnreadCountNotifier.value;

  set conversationList(List<ChatConversation> list) {
    _listValueNotifier.value = List.from(list);

    ChatClient.getInstance.chatManager
        .getUnreadMessageCount()
        .then((value) => _totalUnreadCountNotifier.value = value);
  }

  void addListListener(VoidCallback function) {
    _listValueNotifier.addListener(function);
  }

  void removeListListener(VoidCallback function) {
    _listValueNotifier.removeListener(function);
  }

  void addTotalUnreadCountListener(VoidCallback function) {
    _totalUnreadCountNotifier.addListener(function);
  }

  void removeTotalUnreadCountListener(VoidCallback function) {
    _totalUnreadCountNotifier.removeListener(function);
  }

  void _addListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      key,
      ChatEventHandler(
        onMessagesReceived: (messages) async {
          loadAllConversations();
        },
      ),
    );
  }

  void dispose() {
    ChatClient.getInstance.chatManager.removeEventHandler(key);
  }
}
