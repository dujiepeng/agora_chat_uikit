class RequestModel {
  factory RequestModel.fromMap(Map<String, String> map) {
    return RequestModel(
      userId: map["userId"] ?? "",
      showName: map["showName"],
      avatarURL: map["avatarURL"],
      ts: int.parse((map["ts"] ?? 0).toString()),
      requestMsg: map["requestMsg"],
    );
  }

  Map<String, String> toMap() {
    Map<String, String> map = {};
    map["userId"] = userId;
    map["showName"] = showName ?? "";
    map["avatarURL"] = avatarURL ?? "";
    map["ts"] = ts.toString();
    map["requestMsg"] = requestMsg ?? "";
    map.removeWhere((key, value) => value == "");
    return map;
  }

  RequestModel(
      {required this.userId,
      this.showName,
      this.avatarURL,
      this.ts = 0,
      this.requestMsg});

  final String? showName;
  final String? avatarURL;
  final String userId;
  final int ts;
  final String? requestMsg;
}
