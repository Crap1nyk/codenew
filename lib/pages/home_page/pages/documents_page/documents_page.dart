import 'package:dmtransport/models/document.model.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/data.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/calender_widget.dart';
import 'widgets/view_document.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  bool fetchingDocs = false;

  DateTime selectedDay = DateTime.now();

  void onSelectedDayChange(DateTime day) {
    var date = DateTime(day.year, day.month, day.day);
    setState(() {
      selectedDay = date;
    });
  }

  void onDocTilePress(DocumentModel doc) {
    if (doc.allowedToView) {
      Navigator.of(context).pushNamed(
        ViewDocument.route,
        arguments: doc,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Document Not Allowed"),
          content: const Text(
            "This document is not allowed to be viewed by you.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateNotifier>(context);
    final docs = appState.documents[getDate(selectedDay)] ?? [];

    docs.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploaded Documents"),
      ),
      body: Column(
        children: [
          CalenderWidget(
            onSelectedDayChange: onSelectedDayChange,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: fetchingDocs
                ? Text(
                    "Fetching Docs...",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : !appState.documents.containsKey(getDate(selectedDay))
                    ? Text(
                        "No documents found for selected date",
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    : ListView.builder(
                        itemBuilder: (context, ind) {
                          var doc = docs[ind];
                          return ListTile(
                            onTap: () => onDocTilePress(doc),
                            leading: const Icon(Icons.file_present_rounded),
                            title: Text(
                              Data.documentTypeIdsToName[doc.docType] ??
                                  doc.docType,
                            ),
                            subtitle: Text(doc.note),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${getDate(doc.date)} ${getTime(doc.date)}",
                                ),
                                Text(doc.seen ? "Seen" : "Not Seen"),
                              ],
                            ),
                          );
                        },
                        itemCount:
                            appState.documents[getDate(selectedDay)]!.length,
                      ),
          ),
        ],
      ),
    );
  }
}
