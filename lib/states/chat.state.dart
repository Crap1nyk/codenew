import 'package:dmtransport/external/fb_realtime_db.dart';
import 'package:dmtransport/models/message.modal.dart';
import 'package:flutter/material.dart';

class ChatStateNotifier with ChangeNotifier {
  final List<MessageModel> _adminMessages = [];
  final List<MessageModel> _maintenanceMessages = [];
  bool? adminContactExists;

  List<MessageModel> get adminMessages => _adminMessages;
  List<MessageModel> get maintenanceMessages => _maintenanceMessages;

  bool showMaintenanceChat = false;

  get lastAdminMessage =>
      _adminMessages.isNotEmpty ? _adminMessages.last : null;

  get lastMaintenanceMessage =>
      _maintenanceMessages.isNotEmpty ? _maintenanceMessages.last : null;

  void addAdminMessageFb(BuildContext context, MessageModel message) {
    _adminMessages.add(message);
    notifyListeners();
    FbRealTimeDb.pushGeneralMessage(context, message);
  }

  void setShowMaintenanceChat(bool value) {
    showMaintenanceChat = value;
    notifyListeners();
  }

  void addAdminMessage(MessageModel message) {
    print('Adding message :${message.toJson()}');
    if (_adminMessages
        .where((element) => element.id == message.id)
        .isNotEmpty) {
      return;
    }

    _adminMessages.add(message);
    notifyListeners();
  }

  void setAdminMessages(List<MessageModel> messages) {
    _adminMessages.clear();
    _adminMessages.addAll(messages);
    notifyListeners();
  }

  ///deletes admin message
  void deleteAdminMessage(MessageModel message) {
    print('Deleting messages');
    final index =
        _adminMessages.indexWhere((element) => element.id == message.id);
    if (index == -1) {
      return;
    }
    _adminMessages.removeAt(index);
    notifyListeners();
  }

  void updateAdminMessage(MessageModel message) {
    print('Updating messages');
    final index =
        _adminMessages.indexWhere((element) => element.id == message.id);
    if (index == -1) {
      return;
    }
    _adminMessages[index] = message;
    notifyListeners();
  }

  void addMaintenanceMessageFb(BuildContext context, MessageModel message) {
    _maintenanceMessages.add(message);
    notifyListeners();
    FbRealTimeDb.pushMaintenanceMessage(context, message);
  }

  void addMaintenanceMessage(MessageModel message) {
    if (_maintenanceMessages
        .where((element) => element.id == message.id)
        .isNotEmpty) {
      return;
    }

    _maintenanceMessages.add(message);
    notifyListeners();
  }

  void setMaintenanceMessages(List<MessageModel> messages) {
    _maintenanceMessages.clear();
    _maintenanceMessages.addAll(messages);
    notifyListeners();
  }

  void updateMaintenanceMessage(MessageModel message) {
    final index = _maintenanceMessages.indexWhere(
      (element) => element.id == message.id,
    );

    if (index == -1) return;

    _maintenanceMessages[index] = message;
    notifyListeners();
  }

  void sortMessages() {
    _adminMessages.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _maintenanceMessages.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }
}
