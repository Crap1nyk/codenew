import 'package:dmtransport/external/uuid_handle.dart';
import 'package:dmtransport/models/message.modal.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/messages_page_router.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/widgets/messages.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/widgets/typing_area.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/states/chat.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static const route = "${MessagesPageRouter.baseRoute}/chat";

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)?.settings.arguments as Contact;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
        ),
      );
    });
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 78,
        leading: IconButton(
          style: IconButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Row(
            children: [
              const Icon(
                Icons.arrow_back_rounded,
                size: 24,
                weight: 800,
              ),
              Icon(
                contact.icon,
                size: 42,
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Message ${contact.name}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: ChatPageBody(contact: contact),
    );
  }
}

class ChatPageBody extends StatefulWidget {
  const ChatPageBody({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  State<ChatPageBody> createState() => _ChatPageBodyState();
}

class _ChatPageBodyState extends State<ChatPageBody> {
  void onSendMessage(
      ChatStateNotifier chatState, MessageContent content, String senderName) {
    final message = MessageModel(
      type: MessageType.sent,
      status: MessageStatus.sending,
      dateTime: DateTime.now().toUtc(),
      content: content,
      id: UuidHandle.generate(),
      sendername: senderName,
    );
    if (widget.contact.name == "Admin") {
      chatState.addAdminMessageFb(context, message);
    } else {
      chatState.addMaintenanceMessageFb(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatSate = Provider.of<ChatStateNotifier>(context);
    var appState = Provider.of<AppStateNotifier>(context);
    final senderName = appState.user.name;

    return Column(
      children: [
        Expanded(
          child: Messages(
            messages: widget.contact.name == "Admin"
                ? chatSate.adminMessages
                : chatSate.maintenanceMessages,
          ),
        ),
        TypingArea(
          onSendMessagePressed: (content) =>
              onSendMessage(chatSate, content, senderName),
        ),
      ],
    );
  }
}
