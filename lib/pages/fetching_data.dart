import 'package:dmtransport/api/api.dart';
import 'package:dmtransport/external/fb_messaging.dart';
import 'package:dmtransport/external/fb_realtime_db.dart';
import 'package:dmtransport/models/document.model.dart';
import 'package:dmtransport/pages/home_page/home_page.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/states/chat.state.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FetchingData extends StatefulWidget {
  const FetchingData({super.key});

  static const String id = "fetching_data_id";

  @override
  State<FetchingData> createState() => _FetchingDataState();
}

class _FetchingDataState extends State<FetchingData> {
  Future<void> loadData() async {
    var appState = Provider.of<AppStateNotifier>(context, listen: false);
    var chatState = Provider.of<ChatStateNotifier>(context, listen: false);

    // initialize realtime db and fetch data from it
    await FbRealTimeDb.init(context);
    chatState.sortMessages();

    // fetch documents for last months
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 31));

    List<DocumentModel> docs = await Api.getDocuments(
      getDate(start),
      getDate(end),
      appState.loginToken,
    );

    Map<String, List<DocumentModel>> documents = {};

    for (var element in docs) {
      documents[getDate(element.date)] = [
        ...(documents[getDate(element.date)] ?? []),
        element
      ];
    }

    appState.setDocuments(documents);

    var (notifications, message) = await Api.fetchNotifications(
      appState.loginToken,
      "",
    );

    if (notifications != null) {
      appState.setNotifications(notifications);
      appState.setNextNotificationPageToken(message);
    } else {
      debugPrint(message);
    }

    // deal with firebase messaging
    await FbMessaging.registerDeviceToken(appState.loginToken);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData()
          .then((value) => Navigator.of(context).popAndPushNamed(HomePage.id));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
