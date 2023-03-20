import 'package:agora_chat_demo/tools/image_loader.dart';
import 'package:flutter/material.dart';

class ChoiceAvatarPage extends StatefulWidget {
  const ChoiceAvatarPage({super.key});

  @override
  State<ChoiceAvatarPage> createState() => _ChoiceAvatarPageState();
}

class _ChoiceAvatarPageState extends State<ChoiceAvatarPage> {
  List<String> imageList = [
    "avatar0.png",
    "avatar1.png",
    "avatar2.png",
    "avatar3.png",
    "avatar4.png",
    "avatar5.png",
    "avatar6.png",
    "avatar7.png",
  ];
  int _selected = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile Picture",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(_selected);
              },
              child: const UnconstrainedBox(
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    "Done",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.black,
            child: GridView.custom(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              childrenDelegate: SliverChildBuilderDelegate((context, position) {
                return InkWell(
                  onTap: () {
                    if (_selected == position) {
                      _selected = -1;
                    } else {
                      _selected = position;
                    }
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                        margin: const EdgeInsets.all(10),
                        child: Image.asset(
                          fit: BoxFit.fill,
                          ImageLoader.getImg(imageList[position]),
                        ),
                      ),
                      Positioned.fill(
                        child: Offstage(
                          offstage: _selected != position,
                          child: Image.asset(
                            fit: BoxFit.fill,
                            ImageLoader.getImg("avatar_selected.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }, childCount: imageList.length),
            ),
          ),
        ));
  }
}
