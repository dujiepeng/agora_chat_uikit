import 'package:agora_chat_demo/tools/tool.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

import '../tools/image_loader.dart';
import 'ContactPage/contacts_page.dart';

import 'ConversationPage/conversations_page.dart';
import 'SettingsPage/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  int _unreadCount = 0;

  late List<Widget> _pages;
  final _connectKey = "connectKey";

  @override
  void initState() {
    super.initState();

    _pages = [
      ConversationsPage(
          onUnreadCountChanged: (p0) => setState(() => _unreadCount = p0)),
      const ContactsPage(),
      const SettingsPage(),
    ];

    DemoDataStore.shared.requestCount.addListener(_requestCountChanged);

    ChatClient.getInstance.addConnectionEventHandler(
        _connectKey,
        ConnectionEventHandler(
          onTokenDidExpire: _logoutCallback,
          onUserAuthenticationFailed: _logoutCallback,
          onUserDidChangePassword: _logoutCallback,
          onUserDidLoginTooManyDevice: _logoutCallback,
          onUserDidRemoveFromServer: _logoutCallback,
          onUserKickedByOtherDevice: _logoutCallback,
          onUserDidForbidByServer: _logoutCallback,
          onUserDidLoginFromOtherDevice: _logoutCallback,
        ));

    AgoraChatUIKit.of(context).uiSetup();
  }

  void _logoutCallback() {
    Navigator.of(context).popAndPushNamed("login");
  }

  void _requestCountChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget content = Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => _currentIndex = value),
        items: [
          getBarItem(
              imageName: "bar_chat.png",
              unreadCount: _unreadCount,
              selected: _currentIndex == 0),
          getBarItem(
              imageName: "bar_contact.png",
              unreadCount:
                  DemoDataStore.shared.requestCount.value != 0 ? -1 : 0,
              selected: _currentIndex == 1),
          getBarItem(imageName: "bar_me.png", selected: _currentIndex == 2),
        ],
      ),
    );

    return content;
  }

  BottomNavigationBarItem getBarItem({
    required String imageName,
    String title = "",
    int unreadCount = 0,
    bool selected = false,
  }) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 40,
        height: 35,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              ImageLoader.getImg(imageName),
              height: 30,
              color:
                  selected ? const Color.fromRGBO(0, 95, 255, 1) : Colors.black,
            ),
            Positioned(
              right: unreadCount < 0 ? 0 : null,
              top: unreadCount < 0 ? 0 : null,
              left: unreadCount > 0 ? 20 : null,
              bottom: unreadCount > 0 ? 15 : null,
              child: AgoraBadgeWidget(unreadCount),
            ),
          ],
        ),
      ),
      tooltip: '',
      label: title,
    );
  }

  @override
  void dispose() {
    DemoDataStore.shared.requestCount.removeListener(_requestCountChanged);
    ChatClient.getInstance.removeConnectionEventHandler(_connectKey);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
