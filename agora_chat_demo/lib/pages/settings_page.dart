import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  @override
  Widget build(BuildContext context) {
    const title = 'Dismissing Items';

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Slidable(
            key: ValueKey(item),
            endActionPane: ActionPane(
              dismissible: DismissiblePane(
                confirmDismiss: () {
                  return Future(() => true);
                },
                onDismissed: () {},
              ),
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  icon: Icons.delete,
                  autoClose: true,
                  onPressed: (context) {},
                ),
              ],
            ),
            child: const ListTile(title: Text("Test")),
          );
        },
      ),
    );
  }
}
