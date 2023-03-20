import 'package:agora_chat_demo/pages/ContactPage/request_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DemoDataStore {
  static DemoDataStore? _store;
  factory DemoDataStore._() {
    return _store ??= DemoDataStore();
  }
  static DemoDataStore get shared => DemoDataStore._();

  ValueNotifier<int> requestCount = ValueNotifier(0);

  void addRequest(RequestModel model) {
    List<String>? list = prefers?.getStringList("requestKey") ?? [];
    int index = list.indexWhere((element) {
      Map<String, String> map = json.decode(element).cast<String, String>();
      RequestModel tmpModel = RequestModel.fromMap(map);
      if (tmpModel.userId == model.userId) {
        return true;
      }
      return false;
    });
    if (index > -1) {
      list.removeAt(index);
    }

    list = list + List.from([json.encode(model.toMap())]);
    prefers?.setStringList("requestKey", list);
    requestCount.value = list.length;
  }

  void removeRequest(String userId) {
    List<String>? list = prefers?.getStringList("requestKey") ?? [];
    int index = list.indexWhere((element) {
      Map<String, String> map = json.decode(element).cast<String, String>();
      RequestModel tmpModel = RequestModel.fromMap(map);
      if (tmpModel.userId == userId) {
        return true;
      }
      return false;
    });
    if (index > -1) {
      list.removeAt(index);
    }

    prefers?.setStringList("requestKey", list);
    requestCount.value = list.length;
  }

  List<RequestModel> requests() {
    List<RequestModel> ret = [];
    List<String>? list = prefers?.getStringList("requestKey") ?? [];
    ret = list.map((element) {
      Map<String, String> map = json.decode(element).cast<String, String>();
      return RequestModel.fromMap(map);
    }).toList();
    requestCount.value = ret.length;
    return ret;
  }

  DemoDataStore();

  SharedPreferences? prefers;

  Future<void> init() async {
    prefers = await SharedPreferences.getInstance();
    requests();
    return;
  }
}
