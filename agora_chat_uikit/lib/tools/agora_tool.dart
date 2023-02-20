import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:common_utils/common_utils.dart';

extension ChatMessageExt on ChatMessage {
  String get summary {
    String ret = "";
    switch (body.type) {
      case MessageType.TXT:
        {
          String str = (body as ChatTextMessageBody).content;
          ret = str;
        }
        break;
      case MessageType.IMAGE:
        ret = "[图片]";
        break;
      case MessageType.VIDEO:
        ret = "[视频]";
        break;
      case MessageType.LOCATION:
        ret = "[位置]";
        break;
      case MessageType.VOICE:
        ret = "[音频]";
        break;
      case MessageType.FILE:
        ret = "[文件]";
        break;
      case MessageType.CMD:
        ret = "";
        break;
      case MessageType.CUSTOM:
        ret = "[自定义]";
        break;
    }
    return ret;
  }

  String get createTs {
    return AgoraTimeTool.timeStrByMs(serverTime);
  }
}

class AgoraTimeTool {
  static String timeStrByMs(int ms, {bool showTime = false}) {
    String ret = '';
    // 是否当天
    // HH:mm
    if (DateUtil.isToday(ms)) {
      ret = DateUtil.formatDateMs(ms, format: 'HH:mm');
    }
    // // 是否本周
    // // 周一、周二、周三...
    // else if (DateUtil.isWeek(ms)) {
    //   ret = DateUtil.getWeekdayByMs(ms);
    // }

    // 是否本年
    // MM/dd
    else if (DateUtil.yearIsEqualByMs(ms, DateUtil.getNowDateMs())) {
      if (showTime) {
        ret = DateUtil.formatDateMs(ms, format: 'MM月dd日 HH:mm');
      } else {
        ret = DateUtil.formatDateMs(ms, format: 'MM月dd日');
      }
    }
    // yyyy/MM/dd
    else {
      if (showTime) {
        ret = DateUtil.formatDateMs(ms, format: 'yyyy年MM月dd日 HH:mm');
      } else {
        ret = DateUtil.formatDateMs(ms, format: 'yyyy年MM月dd日');
      }
    }

    return ret;
  }
}
