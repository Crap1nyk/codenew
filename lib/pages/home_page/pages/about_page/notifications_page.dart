import 'package:dmtransport/api/api.dart';
import 'package:dmtransport/pages/home_page/home_page.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const String route = "${HomePage.id}/dashboard/notifications_page_id";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: const LazyLoaderWidget(),
    );
  }
}

class LazyLoaderWidget extends StatefulWidget {
  const LazyLoaderWidget({
    super.key,
  });

  @override
  State<LazyLoaderWidget> createState() => _LazyLoaderWidgetState();
}

class _LazyLoaderWidgetState extends State<LazyLoaderWidget> {
  bool loading = false;

  final ScrollController controller = ScrollController();

  void _scrollListener() {
    if (controller.position.extentAfter < 500 && !loading) {
      final appState = Provider.of<AppStateNotifier>(context, listen: false);

      if (appState.nextNotificationPageToken.isEmpty) return;

      setState(() {
        loading = true;
      });

      Api.fetchNotifications(
        appState.loginToken,
        appState.nextNotificationPageToken,
      ).then((value) {
        final (notifications, message) = value;
        if (notifications != null) {
          appState.addNotifications(notifications);
          appState.setNextNotificationPageToken(message);
        } else {
          debugPrint(message);
        }
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  void initState() {
    controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateNotifier>(context);

    return ListView.builder(
      controller: controller,
      itemBuilder: (context, ind) {
        if (appState.notifications.length <= ind) {
          debugPrint(ind.toString());
          if (!loading) return const SizedBox();

          return const LinearProgressIndicator();
        }

        final notification = appState.notifications[ind];
        return ListTile(
          title: Text(notification.title),
          subtitle: Text(appState.notifications[ind].body),
          trailing: Text("${notification.date} ${notification.time}"),
        );
      },
      itemCount: appState.notifications.length + 1,
    );
  }
}
