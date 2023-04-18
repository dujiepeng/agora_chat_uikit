import 'package:agora_chat_demo/pages/ContactPage/request_model.dart';
import 'package:agora_chat_demo/tools/tool.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'package:flutter/material.dart';

import 'contacts_view.dart';
import 'requests_view.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, this.onUnreadFlagChange});

  final void Function(bool)? onUnreadFlagChange;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  final TextStyle selectedStyle = const TextStyle(
      color: Color.fromRGBO(4, 9, 37, 1),
      fontSize: 16,
      fontWeight: FontWeight.w600);
  final TextStyle unselectedStyle = const TextStyle(
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: 16,
      fontWeight: FontWeight.w400);

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {});
    });

    ChatClient.getInstance.contactManager.addEventHandler(
      "contact_event_key",
      ContactEventHandler(onContactInvited: (userId, reason) {
        _addRequest.call(userId, reason);
      }),
    );

    ChatClient.getInstance.groupManager
        .addEventHandler("group_event_key", ChatGroupEventHandler());

    DemoDataStore.shared.requestCount.addListener(_requestCountChanged);
  }

  void _requestCountChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          title: const Text('Contacts',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(0, 95, 255, 1))),
          bottom: TabBar(
            controller: _controller,
            padding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: const Color.fromRGBO(17, 78, 255, 1),
            indicatorWeight: 2,
            indicatorPadding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
            tabs: [
              Tab(
                child: SizedBox(
                    width: 100,
                    child: Center(
                      child: Text("Contacts",
                          style: _controller.index == 0
                              ? selectedStyle
                              : unselectedStyle),
                    )),
              ),
              Tab(
                child: SizedBox(
                  width: 85,
                  child: Stack(
                    children: [
                      Text("Requests",
                          style: _controller.index == 1
                              ? selectedStyle
                              : unselectedStyle),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: AgoraBadgeWidget(
                              DemoDataStore.shared.requestCount.value > 0
                                  ? -1
                                  : 0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: const [
            ContactsView(),
            RequestsView(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ChatClient.getInstance.contactManager
        .removeEventHandler("contact_event_key");
    ChatClient.getInstance.groupManager.removeEventHandler("group_event_key");
    DemoDataStore.shared.requestCount.removeListener(_requestCountChanged);
    _controller.dispose();
    super.dispose();
  }

  void _addRequest(String userId, String? reason) async {
    Map<String, ChatUserInfo> map = await ChatClient.getInstance.userInfoManager
        .fetchUserInfoById([userId]);
    ChatUserInfo? info = map.values.first;
    RequestModel model = RequestModel(
        userId: userId,
        showName: info.nickName,
        avatarURL: info.avatarUrl,
        requestMsg: reason,
        ts: DateTime.now().millisecondsSinceEpoch);
    DemoDataStore.shared.addRequest(model);
  }
}
