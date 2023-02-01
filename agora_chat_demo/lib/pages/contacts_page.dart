import 'package:flutter/widgets.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, this.onUnreadFlagChange});

  final void Function(bool)? onUnreadFlagChange;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
