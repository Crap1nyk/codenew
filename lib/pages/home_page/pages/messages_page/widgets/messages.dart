import 'package:dmtransport/models/message.modal.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatelessWidget {
  const Messages({
    super.key,
    required this.messages,
  });

  final List<MessageModel> messages;

  @override
  Widget build(BuildContext context) {
    var finalMessages = messages;
    finalMessages.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Group messages by date
    List<List<MessageModel>> groupedMessages =
        groupMessagesByDate(finalMessages);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  finalMessages.isEmpty ? "Start Chating" : "Chat Started",
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              // ...finalMessages.map<Widget>((message) {
              //   return message.recieved
              //       ? MessageTileRecieved(
              //           message: message,
              //         )
              //       : MessageTileSent(message: message);
              // }).toList()

              ...groupedMessages
                  .expand((messageGroup) => [
                        DateHeader(date: messageGroup.first.dateTime),
                        ...messageGroup.map<Widget>((message) {
                          return message.recieved
                              ? MessageTileRecieved(message: message)
                              : MessageTileSent(message: message);
                        })
                      ])
                  .toList(),
            ],
          )),
    );
  }

  List<List<MessageModel>> groupMessagesByDate(List<MessageModel> messages) {
    Map<DateTime, List<MessageModel>> groupedMessages = {};

    for (MessageModel message in messages) {
      DateTime date = DateTime(
          message.dateTime.year, message.dateTime.month, message.dateTime.day);

      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }

      groupedMessages[date]!.add(message);
    }

    return groupedMessages.values.toList();
  }
}

class DateHeader extends StatelessWidget {
  final DateTime date;

  const DateHeader({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          formatDate(date),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class MessageTileRecieved extends StatelessWidget {
  const MessageTileRecieved({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Tooltip(
            message: message.sendername,
            child: CircleAvatar(
              radius: 16,
              child: (message.sendername.isNotEmpty)
                  ? Text(
                      message.sendername[0],
                      style: const TextStyle(fontSize: 12),
                    )
                  : const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 8),
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 100.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.3,
                  maxHeight: 200.0,
                ),
                child: IntrinsicHeight(
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              message.message,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "${getDate(message.dateTime)} ${getTime(message.dateTime)}",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTileSent extends StatelessWidget {
  const MessageTileSent({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateNotifier>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Tooltip(
          message: appState.user.name,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).highlightColor,
            radius: 16,
            child: (appState.user.name.isNotEmpty)
                ? Text(
                    appState.user.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  )
                : const Icon(Icons.person),
          ),
        ),
        const SizedBox(width: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).highlightColor,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 100.0,
                maxWidth: MediaQuery.of(context).size.width * 0.6,
                maxHeight: 200.0,
              ),
              child: IntrinsicHeight(
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            message.message,
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            message.status == MessageStatus.sending
                                ? const SizedBox(
                                    height: 8,
                                    width: 8,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : Icon(
                                    Icons.done_all_rounded,
                                    size: 15,
                                    color: message.status == MessageStatus.seen
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${getDate(message.dateTime)} ${getTime(message.dateTime)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
