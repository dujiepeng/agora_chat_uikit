import 'package:agora_chat_demo/demo_default.dart';
import 'package:agora_chat_demo/tools/tool.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:flutter/material.dart';

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

      Map<String, ChatUserInfo> userMap = await ChatClient
          .getInstance.userInfoManager
          .fetchUserInfoById(list, expireTime: 3600);

      userInfos.clear();
      userInfos.addAll(userMap.values);
      setState(() {});
    } on ChatError catch (e) {
      String str = e.description;
      DemoTool.showSnackBar(context, str);
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
          return InkWell(
            onTap: () {
              _contactInfo.call(info);
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
                      info.nickName ?? info.userId,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ],
                )),
          );
        },
        itemCount: userInfos.length,
      ),
    );
  }

  void _contactInfo(ChatUserInfo userInfo) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
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
