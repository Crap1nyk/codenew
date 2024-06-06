import 'package:dmtransport/models/document.model.dart';
import 'package:dmtransport/models/notification.model.dart';
import 'package:dmtransport/models/user.model.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:flutter/material.dart';

class AppStateNotifier with ChangeNotifier {
  User user = const User("none", "none", "none", "country", "image");
  String loginToken = "";

  List<NotificationModel> notifications = [];
  String nextNotificationPageToken = "";

  Map<String, List<DocumentModel>> documents = {};

  void setNextNotificationPageToken(String value) {
    if (value == nextNotificationPageToken) return;

    nextNotificationPageToken = value;
    notifyListeners();
  }

  void setNotifications(List<NotificationModel> value) {
    if (notifications == value) return;

    notifications = value;
    notifyListeners();
  }

  void addNotifications(List<NotificationModel> value) {
    notifications.addAll(value);
    notifyListeners();
  }

  void setUser(User data) {
    user = data;
    notifyListeners();
  }

  void setLoginToken(String value) {
    if (value == loginToken) return;

    loginToken = value;
    notifyListeners();
  }

  void setDocuments(Map<String, List<DocumentModel>> docs) {
    if (documents == docs) return;
    documents = docs;
    notifyListeners();
  }

  void addDocument(DateTime date, DocumentModel doc) {
    documents[getDate(date)] = [...(documents[getDate(date)] ?? []), doc];
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    if (notifications.contains(notification)) return;

    notifications.insert(0, notification);
    notifyListeners();
  }
}
