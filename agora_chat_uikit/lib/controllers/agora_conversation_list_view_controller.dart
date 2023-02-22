import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:flutter/widgets.dart';

typedef AgoraConversationSortHandle = Future<List<ChatConversation>> Function(
    List<ChatConversation> beforeList);

class AgoraConversationListViewController {
  AgoraConversationListViewController({this.sortHandle}) {
    addListener();
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

  Future<void> deleteConversationWithId(String id) async {
    List<ChatConversation> list = conversationList;
    int index = list.indexWhere((element) => element.id == id);
    if (index >= 0) {
      list.removeAt(index);
      await ChatClient.getInstance.chatManager.deleteConversation(id);
      conversationList = await sortHandle?.call(list) ?? list;
    }
  }

  void deleteAllConversations() async {
    List<ChatConversation> list = conversationList;
    await Future.wait(list.map((element) =>
            ChatClient.getInstance.chatManager.deleteConversation(element.id)))
        .then((value) => conversationList = []);
  }

  List<ChatConversation> get conversationList {
    return _listValueNotifier.value;
  }

  set conversationList(List<ChatConversation> list) {
    _listValueNotifier.value = List.from(list);
  }

  void registerNotifier(VoidCallback function) {
    _listValueNotifier.addListener(function);
  }

  void unregisterNotifier(VoidCallback function) {
    _listValueNotifier.removeListener(function);
  }

  void addListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      "conversationListController",
      ChatEventHandler(
        onMessagesReceived: (messages) async {
          loadAllConversations();
        },
      ),
    );
  }

  void dispose() {
    ChatClient.getInstance.chatManager
        .removeEventHandler("conversationListController");
  }
}
