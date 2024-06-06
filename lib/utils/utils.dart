import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

File platformFileToFile(PlatformFile platformFile) {
  return File(platformFile.path!);
}

String sanitizePhoneNumber(String data) {
  return data.replaceAll(" ", "").replaceAll("-", "");
}

String getDate(DateTime date) {
  date = date.toLocal();
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String getTime(DateTime date) {
  date = date.toLocal();
  return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
}

DateTime parseDateTime(String date) {
  var parsedDate = DateTime.parse(date).toLocal();
  return DateTime(
    parsedDate.year,
    parsedDate.month,
    parsedDate.day,
    parsedDate.hour,
    parsedDate.minute,
  );
}

DateTime sanitizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime sanitizeTime(DateTime date) {
  return DateTime(date.hour, date.minute);
}

bool isTimeValid(String time) {
  if (time.isEmpty) return false;
  debugPrint("time $time");
  // final regex = RegExp(r"^[\d{1,2}]\/[\d{1,2}$]");
  if (!time.contains("/")) return false;
  final tokens = time.split("/");
  debugPrint(tokens.toString());
  if (tokens.length != 2) return false;
  int hh = int.parse(tokens[0]);
  if (hh > 12 || hh <= 0) return false;
  int mm = int.parse(tokens[0]);
  if (mm > 12 || mm <= 0) return false;
  return true;
}
