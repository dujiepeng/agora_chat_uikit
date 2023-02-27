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
                messageListViewController: msgListViewController,
              ),
            ),
            widget.inputBar ?? const AgoraMessageInputWidget()
          ],
        ),
      ),
    );
  }
}
