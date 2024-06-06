import 'package:dmtransport/pages/home_page/pages/messages_page/widgets/contacts_widget.dart';
import 'package:flutter/material.dart';

import '../messages_page_router.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  static const route = "${MessagesPageRouter.baseRoute}/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: const ContactsWidget(),
    );
  }
}
