import 'package:dmtransport/utils/utils.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String image;
  final DateTime dateTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.dateTime,
  });

  String get date => getDate(dateTime);
  String get time => getTime(dateTime);

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String id = json["id"] ?? "";
    String title = json["title"] ?? "";
    String body = json["message"] ?? "";
    String image = json["image"] ?? "";
    DateTime dateTime = DateTime.parse(json["createdAt"]);

    return NotificationModel(
      id: id,
      title: title,
      body: body,
      image: image,
      dateTime: dateTime,
    );
  }
}
