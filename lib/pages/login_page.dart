import 'package:agora_chat_demo/tools/image_loader.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _password = '';

  bool _showPwd = false;
  bool _canLogin = false;
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              const Divider(height: 80),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  children: [
                    Image.asset(
                      ImageLoader.getImg("icon_log.png"),
                      width: 144,
                    ),
                    const Text(
                      "AgoraChat",
                      style: TextStyle(
                          color: Color.fromRGBO(17, 78, 255, 1),
                          fontSize: 30,
                          fontWeight: FontWeight.w900),
                    ),
                    const Divider(height: 64, color: Colors.transparent),
                    TextField(
                      cursorColor: Colors.blue,
                      onChanged: (text) {
                        judgmentLoginBtnCallPress();
                      },
                      controller: _usernameController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(242, 242, 242, 1),
                          contentPadding:
                              const EdgeInsets.fromLTRB(30, 17, 30, 17),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                _usernameController.text = "";
                                judgmentLoginBtnCallPress();
                              },
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.grey)),
                          hintText: "Username",
                          hintStyle: const TextStyle(color: Colors.grey)),
                      obscureText: false,
                    ),
                    const Divider(height: 18, color: Colors.transparent),
                    TextField(
                      cursorColor: Colors.blue,
                      onChanged: (text) {
                        _password = text;
                        judgmentLoginBtnCallPress();
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(30, 17, 30, 17),
                          filled: true,
                          fillColor: const Color.fromRGBO(242, 242, 242, 1),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPwd = !_showPwd;
                              });
                            },
                            icon: const Icon(
                              Icons.remove_red_eye_sharp,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.grey)),
                      obscureText: !_showPwd,
                    ),
                    const Divider(height: 18, color: Colors.transparent),
                    ElevatedButton(
                      style: ButtonStyle(
                        // 设置圆角
                        shape: MaterialStateProperty.all(
                          const StadiumBorder(
                            side: BorderSide(style: BorderStyle.none),
                          ),
                        ),
                      ),
                      onPressed: _canLogin ? loginAction : null,
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: const Text(
                          "Log in",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const Divider(height: 34, color: Colors.transparent),
                    Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                            text: "No account? ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: "Register",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                debugPrint("tap");
                              },
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(17, 78, 255, 1),
                                fontWeight: FontWeight.w700))
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void judgmentLoginBtnCallPress() {
    if (_usernameController.text.isNotEmpty && _password.isNotEmpty) {
      if (_canLogin == false) {
        setState(() {
          _canLogin = true;
        });
      }
    } else {
      if (_canLogin == true) {
        setState(() {
          _canLogin = false;
        });
      }
    }
  }

  void loginAction() {
    EasyLoading.show(status: 'login...');
    ChatClient.getInstance
        .login(_usernameController.text, _password)
        .then((value) {
      EasyLoading.dismiss();
      Navigator.of(context).pushReplacementNamed("home");
    }).catchError((error) {
      EasyLoading.dismiss();
      String desc = (error as ChatError).description;
      EasyLoading.showError(desc);
    });
  }
}
