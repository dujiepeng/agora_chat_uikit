import 'package:agora_chat_uikit/widgets/agora_message_input_widget/agora_emoji_data.dart';
import 'package:flutter/material.dart';

import 'agora_emoji_widget.dart';

class AgoraMessageInputWidget extends StatefulWidget {
  const AgoraMessageInputWidget({
    super.key,
    this.inputTextStr,
    this.recordStart,
    this.recordCancel,
    this.recordDone,
    this.enableEmoji = true,
    this.enableVoice = true,
    this.enableMore = true,
    this.hiddenStr = "请输入消息",
  });
  final String? inputTextStr;
  final VoidCallback? recordStart;
  final VoidCallback? recordCancel;
  final VoidCallback? recordDone;
  final bool enableEmoji;
  final bool enableVoice;
  final bool enableMore;
  final String hiddenStr;
  @override
  State<AgoraMessageInputWidget> createState() =>
      _AgoraMessageInputWidgetState();
}

class _AgoraMessageInputWidgetState extends State<AgoraMessageInputWidget> {
  late TextEditingController textEditingController;
  AgoraInputType _currentInputType = AgoraInputType.text;
  AgoraInputType? _lastInputType;

  final FocusNode _inputFocusNode = FocusNode();
  final GlobalKey _gestureKey = GlobalKey();
  AgoraVoiceOffsetType _voiceTouchType = AgoraVoiceOffsetType.noTouch;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
      text: widget.inputTextStr,
    );
    _inputFocusNode.addListener(() {
      if (_inputFocusNode.hasFocus) {
        _updateCurrentInputType(AgoraInputType.text);
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 140, minHeight: 50),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 3, 10, 4),
                  child: Offstage(
                    offstage: !widget.enableVoice,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _currentInputType == AgoraInputType.voice
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                            ),
                            onTap: () {
                              _updateCurrentInputType(AgoraInputType.voice);
                            }),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: _currentInputType != AgoraInputType.voice
                        ? _inputWidget()
                        : _voiceWidget()),
                () {
                  return _currentInputType != AgoraInputType.voice
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 3, 4, 4),
                          child: Offstage(
                            offstage: !widget.enableMore,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container();
                }(),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
        _faceWidget(),
      ],
    );
  }

  void _updateCurrentInputType(AgoraInputType type) {
    if (type == _currentInputType && _lastInputType != null) {
      _currentInputType = _lastInputType!;
    } else {
      _lastInputType = _currentInputType;
      _currentInputType = type;
    }
    setState(() {});
  }

  Widget _inputWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              focusNode: _inputFocusNode,
              controller: textEditingController,
              maxLines: null,
              decoration: InputDecoration(
                prefixText: " ",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                isCollapsed: true,
                hintText: widget.hiddenStr,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 3, 4, 4),
            child: Offstage(
              offstage: !widget.enableEmoji,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      _inputFocusNode.unfocus();
                      _updateCurrentInputType(AgoraInputType.emoji);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _currentInputType == AgoraInputType.emoji
                            ? Colors.blue
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _voiceWidget() {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: Container(
        key: _gestureKey,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 230, 230, 230)),
        height: 44,
        child: Center(
          child: Text(
            () {
              switch (_voiceTouchType) {
                case AgoraVoiceOffsetType.noTouch:
                  return "Hold to Talk";
                case AgoraVoiceOffsetType.dragInside:
                  return "Release to send";
                case AgoraVoiceOffsetType.dragOutside:
                  return "Release to cancel";
              }
            }(),
            style: const TextStyle(color: Color.fromARGB(255, 165, 167, 166)),
          ),
        ),
      ),
    );
  }

  Widget _faceWidget() {
    return _currentInputType == AgoraInputType.emoji
        ? SizedBox(
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  child: AgoraEmojiWidget(
                    emojiClicked: (p0) {
                      TextEditingValue value = textEditingController.value;
                      int current = value.selection.baseOffset;
                      String text = value.text;
                      text = text.substring(0, current) +
                          p0 +
                          text.substring(current);
                      textEditingController.value = value.copyWith(
                        text: text,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: current + 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: InkWell(
                    onTap: () {
                      TextEditingValue value = textEditingController.value;
                      int current = value.selection.baseOffset;
                      String mStr = "";
                      int offset = 0;
                      do {
                        if (current == 0) {
                          return;
                        }
                        if (current == 1) {
                          mStr = value.text.substring(1);
                          break;
                        }

                        if (current >= 2) {
                          String subText =
                              value.text.substring(current - 2, current);
                          if (AgoraEmojiData.emojiList.contains(subText)) {
                            mStr = value.text.substring(0, current - 2) +
                                value.text.substring(current);
                            offset = current - 2;
                            break;
                          } else {
                            mStr = value.text.substring(0, current - 1) +
                                value.text.substring(current);
                            offset = current - 1;
                            break;
                          }
                        }
                      } while (false);
                      textEditingController.value = value.copyWith(
                        text: mStr,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: offset,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  _onPointerDown(PointerDownEvent event) {
    setState(() => _voiceTouchType = AgoraVoiceOffsetType.dragInside);
  }

  _onPointerMove(PointerMoveEvent event) {
    RenderBox renderBox =
        _gestureKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = event.localPosition;
    bool outside = false;
    if (offset.dx < 0 || offset.dy < 0) {
      outside = true;
    } else if (renderBox.size.width - offset.dx < 0 ||
        renderBox.size.height - offset.dy < 0) {
      outside = true;
    }
    AgoraVoiceOffsetType type = AgoraVoiceOffsetType.noTouch;
    if (!outside) {
      type = AgoraVoiceOffsetType.dragInside;
    } else {
      type = AgoraVoiceOffsetType.dragOutside;
    }
    if (_voiceTouchType != type) {
      setState(() => _voiceTouchType = type);
    }
  }

  _onPointerUp(PointerUpEvent event) {
    RenderBox renderBox =
        _gestureKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = event.localPosition;
    bool outside = false;
    if (offset.dx < 0 || offset.dy < 0) {
      outside = true;
    } else if (renderBox.size.width - offset.dx < 0 ||
        renderBox.size.height - offset.dy < 0) {
      outside = true;
    }

    if (!outside) {
    } else {}
    setState(() => _voiceTouchType = AgoraVoiceOffsetType.noTouch);
  }
}

enum AgoraInputType { text, voice, emoji }

enum AgoraVoiceOffsetType {
  noTouch,
  dragInside,
  dragOutside,
}
