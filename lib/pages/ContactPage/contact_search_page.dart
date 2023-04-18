import 'package:agora_chat_demo/demo_default.dart';

import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContactSearchPage extends StatefulWidget {
  const ContactSearchPage({super.key});

  @override
  State<ContactSearchPage> createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends State<ContactSearchPage> {
  final TextEditingController _controller = TextEditingController();

  List<ChatUserInfo> infoList = [];
  final List<String> _addList = [];
  final List<String> _addingList = [];

  @override
  void initState() {
    super.initState();
    _loadAddList();
  }

  void _loadAddList() async {
    try {
      _addList.addAll(
          await ChatClient.getInstance.contactManager.getAllContactsFromDB());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: SizedBox(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: _controller,
                  cursorColor: Colors.blue,
                  onSubmitted: (value) {
                    _searchContact(value);
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(242, 242, 242, 1),
                      contentPadding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      suffixIconConstraints:
                          const BoxConstraints(maxHeight: 30, maxWidth: 30),
                      suffixIcon: InkWell(
                        onTap: () {
                          _controller.text = "";
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              )),
                        ),
                      ),
                      hintText: "UserId",
                      hintStyle: const TextStyle(color: Colors.grey)),
                  obscureText: false,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  _controller.text = "";
                  infoList.clear();
                  setState(() {});
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        leading: SizedBox(
          width: 50,
          child: InkWell(
            child: const Icon(
              Icons.navigate_before,
              color: Color.fromRGBO(51, 51, 51, 1),
              size: 40,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: infoList.isEmpty
          ? Center(
              child: AgoraImageLoader.loadImage("conversation_empty.png"),
            )
          : ListView.separated(
              itemBuilder: (ctx, index) {
                return _item(infoList[index]);
              },
              separatorBuilder: (ctx, index) => const Divider(height: 0.3),
              itemCount: infoList.length),
    );
  }

  Widget _item(ChatUserInfo info) {
    Widget content = ListTile(
      leading: SizedBox(width: 48, height: 48, child: userInfoAvatar(info)),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 17, 0),
        child: Text(
          info.nickName ?? info.userId,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(51, 51, 51, 1)),
        ),
      ),
      subtitle: Text(
        _controller.text,
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Color.fromRGBO(102, 102, 102, 1)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.hardEdge,
            child: ElevatedButton(
              onPressed: (_addList.contains(info.userId) ||
                      _addingList.contains(info.userId))
                  ? null
                  : () {
                      _addContact(info.userId);
                    },
              child: Text(
                _addList.contains(info.userId)
                    ? "Added"
                    : _addingList.contains(info.userId)
                        ? "Adding"
                        : "Add",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );

    return content;
  }

  void _addContact(String userId) async {
    try {
      await ChatClient.getInstance.contactManager.addContact(userId);
      _addingList.add(userId);
      setState(() {});
    } on ChatError catch (e) {
      EasyLoading.showError(e.description);
    }
  }

  void _searchContact(String userId) async {
    debugPrint(userId);
    if (userId.isEmpty) return;
    try {
      Map<String, ChatUserInfo> map = await ChatClient
          .getInstance.userInfoManager
          .fetchUserInfoById([userId]);
      infoList.clear();
      infoList.addAll(map.values);
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
