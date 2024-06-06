import 'package:dmtransport/models/message.modal.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/models/contact.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/pages/chat_page.dart';
import 'package:dmtransport/states/chat.state.dart';
import 'package:dmtransport/utils/data.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsWidget extends StatelessWidget {
  const ContactsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var chatState = Provider.of<ChatStateNotifier>(context);

    return ListView.builder(
      itemBuilder: (context, ind) {
        Contact contact = Data.contacts[ind];
        return ContactWidget(ind: ind, name: contact.name);
      },
      itemCount: chatState.showMaintenanceChat
          ? Data.contacts.length
          : Data.contacts.length - 1,
    );
  }
}

class ContactWidget extends StatelessWidget {
  const ContactWidget({super.key, required this.name, required this.ind});

  final String name;
  final int ind;

  @override
  Widget build(BuildContext context) {
    var chatState = Provider.of<ChatStateNotifier>(context);
    MessageModel? lastMessage = (name == "Admin")
        ? chatState.lastAdminMessage
        : chatState.lastMaintenanceMessage;

    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          ChatPage.route,
          arguments: Data.contacts[ind],
        );
      },
      leading: Icon(
        Data.contacts[ind].icon,
        size: 50,
      ),
      title: Text(name),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      subtitle: lastMessage != null
          ? Text(
              lastMessage.message,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          : Text("Start Chating with $name"),
      trailing: lastMessage != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${getDate(lastMessage.dateTime)} ${getTime(lastMessage.dateTime)}",
                ),
                if (lastMessage.type == MessageType.sent)
                  lastMessage.status == MessageStatus.sending
                      ? const SizedBox(
                          height: 8,
                          width: 8,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey,
                          ),
                        )
                      : Icon(
                          Icons.done_all_rounded,
                          size: 15,
                          color: lastMessage.status == MessageStatus.seen
                              ? Colors.blue
                              : Colors.grey,
                        ),
              ],
            )
          : null,
      subtitleTextStyle: Theme.of(context).textTheme.titleSmall,
    );
  }
}
