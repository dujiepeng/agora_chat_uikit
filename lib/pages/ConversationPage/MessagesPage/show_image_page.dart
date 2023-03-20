import 'dart:io';

import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

class ShowImagePage extends StatefulWidget {
  const ShowImagePage(this.message, {super.key});
  final ChatMessage message;

  @override
  State<ShowImagePage> createState() => _ShowImagePageState();
}

class _ShowImagePageState extends State<ShowImagePage> {
  final String _msgEventKey = "msgEventKey";

  ChatImageMessageBody? body;
  ChatMessage? message;

  @override
  void initState() {
    super.initState();
    message = widget.message;
    ChatClient.getInstance.chatManager.addMessageEvent(
        _msgEventKey,
        ChatMessageEvent(
          onProgress: (msgId, progress) {},
          onSuccess: (msgId, msg) {
            message = msg;
            setState(() {});
          },
          onError: (msgId, msg, error) {},
        ));
  }

  @override
  void dispose() {
    ChatClient.getInstance.chatManager.removeMessageEvent(_msgEventKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    body = message!.body as ChatImageMessageBody;

    Widget? content;
    if (body!.fileStatus != DownloadStatus.SUCCESS &&
        message!.direction == MessageDirection.RECEIVE) {
      _downloadImage(message!);
      content = Image.network(body!.thumbnailRemotePath!);
    } else {
      try {
        content = Image.file(File(body!.localPath));
      } catch (e) {
        _downloadImage(message!);
        content = Image.network(body!.thumbnailRemotePath!);
      }
    }

    content = InteractiveViewer(
      child: content,
    );

    content = SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          left: 5,
          top: 5,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: content),
    );
  }

  void _downloadImage(ChatMessage message) {
    ChatClient.getInstance.chatManager.downloadAttachment(message);
  }
}
