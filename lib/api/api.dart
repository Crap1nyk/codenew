import 'dart:convert';
import 'dart:developer';
import 'package:dmtransport/api/types.dart';
import 'package:dmtransport/models/document.model.dart';
import 'package:dmtransport/models/notification.model.dart';
import 'package:dmtransport/models/user.model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl =
      "northamerica-northeast1-dmtransport-1.cloudfunctions.net";
// https://northamerica-northeast1-dmtransport-1.cloudfunctions.net/api
  static Future<LoginResponse?> login(String id, String password) async {
    String path = "/api/user/login";

    // making request
    var url = Uri.https(baseUrl, path);
    var response = await http.post(
      url,
      body: {"phone": id, "password": password},
    );

    // decoding respponse
    var body = jsonDecode(response.body);

    log('Body: $body');

    if (response.statusCode == 200) {
      String token = body["token"] as String;
      var userData = body["user"];

      return LoginResponse(User.fromJson(userData), token);
    } else {
      String msg = (body["message"] ?? "Unknown Error") as String;
      throw Exception(msg);
    }
  }

  static Future<DocumentModel?> uploadDocument(
    String driverName,
    String driverImage,
    String docUrl,
    String docPath,
    String docType,
    String note,
    String driverEmail, // Add driver email parameter
    String bearer,
  ) async {
    String path = "/api/user/uploadDocument";

    // making request
    var url = Uri.https(baseUrl, path);

    var reqBody = {
      "driver_name": driverName,
      "driver_image": driverImage,
      "path": docPath,
      "document_url": docUrl,
      "type": docType,
      "note": note,
      "driver_email": driverEmail, // Include driver email in the request body
    };

    String _t = await FirebaseAppCheck.instance.getToken() ?? '';

    var response = await http.post(
      url,
      body: reqBody,
      headers: {"Authorization": "Bearer $bearer", 'X-Firebase-AppCheck': _t},
    );

    // decoding response
    var body = jsonDecode(response.body);
    if (response.statusCode != 200) {
      String msg = (body["message"] ?? "Unkown Error") as String;
      throw Exception(msg);
    } else {
      return DocumentModel.fromJson(body["document"]);
    }
  }

  static Future<List<DocumentModel>> getDocuments(
    String startDate,
    String endDate,
    String bearer,
  ) async {
    String path = "/api/user/fetchDocumentByDate";

    // making request
    var params = {
      "start_date": startDate,
      "end_date": endDate,
    };

    var url = Uri.https(baseUrl, path, params);

    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $bearer"},
    );

    // decoding response
    var body = jsonDecode(response.body);

    List<DocumentModel> docs = [];

    if (response.statusCode == 200) {
      for (var doc in body["documents"]) {
        docs.add(DocumentModel.fromJson(doc));
      }
    } else {
      String msg = (body["message"] ?? "Unkown Error") as String;
      throw Exception(msg);
    }

    return docs;
  }

  static Future<User?> isLoginTokenValid(String token) async {
    String path = "/api/user/checkToken";
    log('token: $token');
    var url = Uri.https(baseUrl, path);
    String _t = await FirebaseAppCheck.instance.getToken() ?? '';
    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", 'X-Firebase-AppCheck': _t},
    );

    // decoding response
    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return User.fromJson(body["user"]);
    } else {
      return null;
    }
  }

  static Future<void> logout(String bearer) async {
    String path = "/api/user/logout";

    var url = Uri.https(baseUrl, path);
    await http.get(
      url,
      headers: {"Authorization": "Bearer $bearer"},
    );
  }

  static Future<void> updateFcmToken(String token, String bearer) async {
    String path = "/api/user/saveFcmToken";
    var url = Uri.https(baseUrl, path);
    await http.post(
      url,
      headers: {"Authorization": "Bearer $bearer"},
      body: {"fcm_token": token},
    );
  }

  static Future<(List<NotificationModel>?, String)> fetchNotifications(
    String bearer,
    String nextNotificationToken,
  ) async {
    String path = "/api/user/fetchNotifications";

    var params = {"nextPageToken": nextNotificationToken};

    var url = Uri.https(baseUrl, path, params);
    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $bearer"},
    );

    // decoding response
    var body = jsonDecode(response.body);

    if (response.statusCode != 200) return (null, body["message"] as String);

    List<NotificationModel> notifications = [];
    final rawNotifaications = body["notifications"];

    for (var notification in rawNotifaications) {
      notifications.add(NotificationModel.fromJson(notification));
    }

    return (notifications, body["nextPageToken"] as String);
  }
}
