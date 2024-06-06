import 'package:dmtransport/api/api.dart';
import 'package:dmtransport/external/shared_prefs_names.dart';
import 'package:dmtransport/models/notification.model.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FbMessaging {
  static Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        )
        .then(
          (settings) => debugPrint(
            "User granted permission: ${settings.authorizationStatus}",
          ),
        );
  }

  static Future<void> registerDeviceToken(String loginToken) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      debugPrint("fcmToken is null");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final oldFcmToken = prefs.getString(SharedPrefsNames.fcmToken) ?? "";
    if (fcmToken == oldFcmToken) return;
    await Api.updateFcmToken(fcmToken, loginToken);
    prefs.setString(SharedPrefsNames.fcmToken, fcmToken);
  }

  static void registerCallbacks(BuildContext context) {
    final appState = Provider.of<AppStateNotifier>(context, listen: false);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final gotNotification = message.notification!;

      String imageUrl = "";
      if (TargetPlatform.iOS == Theme.of(context).platform) {
        imageUrl = gotNotification.apple!.imageUrl ?? "";
      } else {
        imageUrl = gotNotification.android!.imageUrl ?? "";
      }

      final notification = NotificationModel(
        id: "uid",
        title: gotNotification.title ?? "",
        body: gotNotification.body ?? "",
        image: imageUrl,
        dateTime: message.sentTime ?? DateTime.now(),
      );

      InAppNotification.show(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: ListTile(
              title: Text(notification.title),
              subtitle: Text(notification.body),
            ),
          ),
        ),
        context: context,
      );

      appState.addNotification(notification);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
  }
}
