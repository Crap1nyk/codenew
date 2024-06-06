import 'dart:io';

import 'package:dmtransport/utils/utils.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerHandle {
  static Future<File?> pickPdf() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      dialogTitle: "Select PDF",
      allowMultiple: false,
    );
    if (result == null) return null;
    if (result.files.isNotEmpty) return platformFileToFile(result.files[0]);
    return null;
  }
}
