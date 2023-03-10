import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
