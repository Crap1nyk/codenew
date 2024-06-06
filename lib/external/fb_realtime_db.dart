import 'dart:developer';

import 'package:dmtransport/models/message.modal.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/states/chat.state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ChatType {
  admin,
  maintenance,
}

class FbRealTimeDb {
  static const dbUrl =
      "https://dmtransport-1-default-rtdb.asia-southeast1.firebasedatabase.app";

  static DatabaseReference get rootRef => FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dbUrl,
      ).ref();

  /// Initialize firebase realtime database
  static Future<void> init(BuildContext context) async {
    var appState = Provider.of<AppStateNotifier>(context, listen: false);
    var chatState = Provider.of<ChatStateNotifier>(context, listen: false);

    final adminMessagesRef = rootRef.child(
      "chat/users/${appState.user.phone}/admin/",
    );

    final maintenanceMessagesRef = rootRef.child(
      "chat/users/${appState.user.phone}/maintenance/",
    );

    final configurationRef =
        rootRef.child("configuration/${appState.user.phone}");

    adminMessagesRef.onChildAdded.listen((event) {
      Map<Object?, Object?> snapshot =
          event.snapshot.value as Map<Object?, Object?>;
      var value = snapshot.cast<String, dynamic>();
      final message = MessageModel.fromJson(value);
      log('Value after add :$value');
      chatState.addAdminMessage(message);
    });

    adminMessagesRef.onChildRemoved.listen((event) {
      log('removed children');
      Map<Object?, Object?> snaapshot =
          event.snapshot.value as Map<Object?, Object?>;
      var value = snaapshot.cast<String, dynamic>();
      log('Value after rem :$value');
      chatState.deleteAdminMessage(MessageModel.fromJson(value));
    });

    adminMessagesRef.onChildChanged.listen((event) {
      log('Updated children');
      Map<Object?, Object?> snaapshot =
          event.snapshot.value as Map<Object?, Object?>;
      var value = snaapshot.cast<String, dynamic>();
      log('Value after upd :$value');
      chatState.updateAdminMessage(MessageModel.fromJson(value));
    });

    maintenanceMessagesRef.onChildAdded.listen((event) {
      Map<Object?, Object?> snapshot =
          event.snapshot.value as Map<Object?, Object?>;
      var value = snapshot.cast<String, dynamic>();
      final message = MessageModel.fromJson(value);
      chatState.addMaintenanceMessage(message);
    });

    maintenanceMessagesRef.onChildChanged.listen((event) {
      Map<Object?, Object?> snaapshot =
          event.snapshot.value as Map<Object?, Object?>;
      var value = snaapshot.cast<String, dynamic>();
      chatState.updateMaintenanceMessage(MessageModel.fromJson(value));
    });

    configurationRef.onChildChanged.listen((event) {
      chatState.setShowMaintenanceChat(event.snapshot.value == true);
    });
  }

  /// Push the general message
  static Future<void> pushGeneralMessage(
    BuildContext context,
    MessageModel message,
  ) async {
    var appState = Provider.of<AppStateNotifier>(context, listen: false);

    await _pushForAdminGeneralMessage(context, message);

    var messageRef = rootRef.child(
      _getMessagePath(message, appState.user.phone, ChatType.admin),
    );
    messageRef.set(message.json);
  }

  /// Push the maintenance message
  static void pushMaintenanceMessage(
    BuildContext context,
    MessageModel message,
  ) async {
    var appState = Provider.of<AppStateNotifier>(context, listen: false);

    await _pushForAdminMaintenanceMessage(context, message);

    var messageRef = rootRef.child(
      _getMessagePath(message, appState.user.phone, ChatType.maintenance),
    );
    messageRef.set(message.json);
  }

  /// push the general message on admin side
  static Future<void> _pushForAdminGeneralMessage(
    BuildContext context,
    MessageModel message,
  ) async {
    var appState = Provider.of<AppStateNotifier>(context, listen: false);
    var chatState = Provider.of<ChatStateNotifier>(context, listen: false);

    await rootRef
        .child(
          _getAdminMessagePath(message, appState.user.phone, ChatType.admin),
        )
        .set(message.toAdminJson(
          appState.user.phone,
        ))
        .then((value) {
      message.status = MessageStatus.sent;
      chatState.updateAdminMessage(message);
    });
  }

  /// push the maintenance message on admin side
  static Future<void> _pushForAdminMaintenanceMessage(
    BuildContext context,
    MessageModel message,
  ) {
    var appState = Provider.of<AppStateNotifier>(context, listen: false);
    var chatState = Provider.of<ChatStateNotifier>(context, listen: false);

    return rootRef
        .child(
          _getAdminMessagePath(
            message,
            appState.user.phone,
            ChatType.maintenance,
          ),
        )
        .set(message.toAdminJson(
          appState.user.phone,
        ))
        .then((value) {
      message.status = MessageStatus.sent;
      chatState.updateMaintenanceMessage(message);
    });
  }

  static String _getMessagePath(
    MessageModel message,
    String contactId,
    ChatType chatType,
  ) {
    var chatTypeName = chatType == ChatType.admin ? "admin" : "maintenance";
    return "chat/users/$contactId/$chatTypeName/${message.id}";
  }

  static String _getAdminMessagePath(
    MessageModel message,
    String contactId,
    ChatType chatType,
  ) {
    var chatTypeName = chatType == ChatType.admin ? "general" : "maintenance";
    return "chat/users/admin/$chatTypeName/$contactId/${message.id}";
  }
}
