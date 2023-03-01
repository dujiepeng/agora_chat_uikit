import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

class AgoraMessagesPage extends StatefulWidget {
  const AgoraMessagesPage({
    super.key,
    this.appBar,
    this.inputBar,
    required this.conversation,
  });

  final AppBar? appBar;
  final Widget? inputBar;
  final ChatConversation conversation;

  @override
  State<AgoraMessagesPage> createState() => _AgoraMessagesPageState();
}

class _AgoraMessagesPageState extends State<AgoraMessagesPage> {
  late final AgoraMessageListViewController msgListViewController;

  @override
  void initState() {
    super.initState();
    msgListViewController = AgoraMessageListViewController(widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: widget.appBar ??
          AppBar(
            titleSpacing: 0,
            iconTheme: IconThemeData(
              color: Theme.of(context).appBarBackIconColor,
            ),
            centerTitle: false,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                FutureBuilder(
                  builder: (context, snapshot) {
                    return Container(
                      width: 40,
                      height: 40,
                      color: Colors.red,
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.conversation.id,
                  style: Theme.of(context).appBarTitleTextStyle,
                ),
              ],
            ),
          ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AgoraMessageListView(
                conversation: widget.conversation,
                controller: msgListViewController,
              ),
            ),
            widget.inputBar ??
                AgoraMessageInputWidget(
                  moreAction: showMoreItems,
                  textFieldOnChanged: (text) {
                    msgListViewController.moveToEnd();
                  },
                )
          ],
        ),
      ),
    );
  }

  void showMoreItems() {
    showModalBottomSheet(
      elevation: 50,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Divider(height: 10),
              InkWell(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Camera",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    )),
                onTap: () => {},
              ),
              InkWell(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Album",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    )),
                onTap: () => {},
              ),
              InkWell(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Files",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    )),
                onTap: () => {},
              ),
            ],
          ),
        );
      },
    );
  }
}
