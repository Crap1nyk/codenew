import 'package:dmtransport/pages/home_page/home_page.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/pages/contacts_page.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/pages/chat_page.dart';
import 'package:flutter/material.dart';

class MessagesPageRouter {
  static const String baseRoute = "${HomePage.id}/messages";
  static final Map<String, Widget Function(BuildContext)> routes = {
    ContactsPage.route: (context) => const ContactsPage(),
    ChatPage.route: (context) => const ChatPage(),
  };
}
