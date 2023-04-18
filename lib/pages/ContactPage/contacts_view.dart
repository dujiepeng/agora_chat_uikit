import 'package:agora_chat_demo/demo_default.dart';
import 'package:agora_chat_demo/tools/user_info_manager.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'contact_info.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView>
    with AutomaticKeepAliveClientMixin {
  List<ChatUserInfo> userInfos = [];

  @override
  void initState() {
    super.initState();
    ChatClient.getInstance.contactManager.addEventHandler(
        "handlerKey",
        ContactEventHandler(
          onContactAdded: (userId) {
            _addContact(userId);
          },
          onContactDeleted: (userId) {
            userInfos.removeWhere((element) => element.userId == userId);
            setState(() {});
          },
        ));
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      List<String> list = await ChatClient.getInstance.contactManager
          .getAllContactsFromServer();
      Map<String, ChatUserInfo> userMap =
          await UserInfoManager.getUserInfoList(list);

      userInfos.clear();
      userInfos.addAll(userMap.values);
      setState(() {});
    } on ChatError catch (e) {
      EasyLoading.showError(e.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _loadContacts,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(height: 0.3);
        },
        itemBuilder: (ctx, index) {
          ChatUserInfo info = userInfos[index];
          String showName = info.nickName ?? "";
          if (showName.isEmpty) showName = info.userId;
          return InkWell(
            onTap: () {
              _contactInfo.call(ctx, info);
            },
            child: Container(
                color: Colors.white,
                height: 80,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 12.5, 10, 12.5),
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: userInfoAvatar(info),
                      ),
                    ),
                    Text(
                      showName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )),
          );
        },
        itemCount: userInfos.length,
      ),
    );
  }

  void _contactInfo(BuildContext ctx, ChatUserInfo userInfo) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (ctx) {
        return ContactInfo(userInfo);
      },
    )).then((value) {
      if (value is Map) {
        String userId = value.keys.first as String;
        String str = value[userId];
        if (str == "delete") {
          userInfos.remove(userInfo);
          setState(() {});
        }
      }
    });
  }

  void _addContact(String userId) async {
    Map<String, ChatUserInfo> infoMap = await ChatClient
        .getInstance.userInfoManager
        .fetchUserInfoById([userId]);
    userInfos.add(infoMap.values.first);
    setState(() {});
  }

  @override
  void dispose() {
    ChatClient.getInstance.contactManager.removeEventHandler("handlerKey");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
