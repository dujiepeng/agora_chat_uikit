import 'package:agora_chat_demo/tools/tool.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'request_model.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    DemoDataStore.shared.requestCount.addListener(_requestCountChanged);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<RequestModel> list = DemoDataStore.shared.requests();

    return ListView.separated(
      itemBuilder: (ctx, index) {
        RequestModel model = list[index];
        Widget content = ListTile(
          leading: FadeInImage.assetNetwork(
            placeholder: "placeholder",
            placeholderErrorBuilder: (context, error, stackTrace) {
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(40)),
              );
            },
            image: model.avatarURL ?? "",
            imageErrorBuilder: (context, error, stackTrace) {
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(40)),
              );
            },
          ),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 17, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.showName ?? model.userId,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  AgoraTimeTool.timeStrByMs(model.ts),
                  style: const TextStyle(
                      color: Color.fromRGBO(117, 130, 138, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          subtitle: Text(
            model.requestMsg ?? "",
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(70, 78, 83, 1)),
          ),
        );
        content = Column(
          children: [
            content,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    _acceptRequest.call(model.userId);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(17, 77, 255, 1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    _declineRequest.call(model.userId);
                  },
                  child: const Center(
                    child: Icon(
                      Icons.close,
                    ),
                  ),
                ),
                const SizedBox(width: 18)
              ],
            )
          ],
        );

        return content;
      },
      separatorBuilder: (ctx, index) {
        return const Divider(height: 0.3);
      },
      itemCount: list.length,
    );
  }

  void _acceptRequest(String userId) async {
    EasyLoading.show(status: 'login...');
    try {
      await ChatClient.getInstance.contactManager.acceptInvitation(userId);
      DemoDataStore.shared.removeRequest(userId);
      setState(() {});
    } on ChatError catch (e) {
      EasyLoading.showError(e.description);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _declineRequest(String userId) async {
    await ChatClient.getInstance.contactManager.declineInvitation(userId);
    DemoDataStore.shared.removeRequest(userId);
    setState(() {});
  }

  void _requestCountChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    DemoDataStore.shared.requestCount.removeListener(_requestCountChanged);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
