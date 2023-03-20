import 'package:agora_chat_demo/demo_default.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'choice_avatar_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ChatUserInfo? _userInfo;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    _userInfo = await ChatClient.getInstance.userInfoManager.fetchOwnInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String showName =
        _userInfo?.nickName ?? ChatClient.getInstance.currentUserId ?? "";
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            expandedHeight: 240,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
                background: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: InkWell(
                      onTap: _showUpdateAvatarView,
                      child: userInfoAvatar(_userInfo),
                    ),
                  ),
                  const Divider(height: 12, color: Colors.transparent),
                  InkWell(
                    onTap: _showNicknameInputBar,
                    child: Text(
                      showName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Divider(height: 8, color: Colors.transparent),
                  Text(
                    "AgoraID: ${ChatClient.getInstance.currentUserId}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  const Divider(height: 20, color: Colors.transparent),
                ],
              ),
            )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 32,
                  color: const Color.fromRGBO(245, 245, 245, 1),
                  child: Row(children: const [
                    Text(
                      "About",
                      style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    height: 60,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Center(
                            child: Text(
                              "SDK Version",
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            "v1.1.0",
                            style: TextStyle(
                                color: Color.fromRGBO(102, 102, 102, 1),
                                fontWeight: FontWeight.w400,
                                fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 0.3),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    height: 60,
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Center(
                          child: Text(
                            "UI Library Version",
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "v0.1.0",
                          style: TextStyle(
                              color: Color.fromRGBO(102, 102, 102, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        )
                      ],
                    )),
                  ),
                ),
                const Divider(height: 0.3),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: SizedBox(
                    height: 60,
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
                          child: Text(
                            "Legals n' Policies",
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.navigate_next))
                      ],
                    )),
                  ),
                ),
                const Divider(height: 0.3),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: SizedBox(
                    height: 60,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Center(
                            child: Text(
                              "More",
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Agora.io",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(17, 78, 255, 1)),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 0.3),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 32,
                  color: const Color.fromRGBO(245, 245, 245, 1),
                  child: Row(
                    children: const [
                      Text(
                        "Logins",
                        style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: SizedBox(
                    height: 60,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: _logout,
                            child: const Center(
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                  color: Color.fromRGBO(17, 78, 255, 1),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    ChatClient.getInstance.logout();
    Navigator.of(context).popAndPushNamed("login");
  }

  void _showUpdateAvatarView() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const ChoiceAvatarPage();
      },
    )).then((value) async {
      if (value != null && value > -1) {
        try {
          _userInfo = await ChatClient.getInstance.userInfoManager
              .updateUserInfo(avatarUrl: value.toString());
          debugPrint("更新成功");
          setState(() {});
        } on ChatError catch (e) {
          EasyLoading.showError(e.description);
        }
      }
    });
  }

  void _showNicknameInputBar() {
    AgoraDialog(
      titleLabel: "Change Nickname",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      content: SizedBox(
        height: 40,
        width: 280,
        child: TextField(
          controller: _controller,
          cursorColor: Colors.blue,
          onChanged: (text) {},
          decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(250, 250, 250, 1),
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
              hintText: "Nickname",
              hintStyle: const TextStyle(color: Colors.grey)),
          obscureText: false,
        ),
      ),
      items: [
        AgoraDialogItem(
          label: "Cancel",
          onTap: () => Navigator.of(context).pop(),
          labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        AgoraDialogItem(
          label: "Confirm",
          onTap: () {
            _updateNickname();
            Navigator.of(context).pop();
          },
          backgroundColor: const Color.fromRGBO(17, 78, 255, 1),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    ).show(context);
  }

  void _updateNickname() async {
    try {
      _userInfo = await ChatClient.getInstance.userInfoManager
          .updateUserInfo(nickname: _controller.text);
      _controller.text = "";
      setState(() {});
    } on ChatError catch (e) {
      EasyLoading.showError(e.description);
    }
  }
}
