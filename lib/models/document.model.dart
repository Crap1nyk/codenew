import 'package:dmtransport/utils/utils.dart';

enum DocumentState {
  none,
  markedForResend,
  resent,
}

class DocumentModel {
  DocumentModel({
    required this.id,
    required this.docUrl,
    required this.path,
    required this.seen,
    required this.docType,
    required this.note,
    required this.date,
    required this.state,
    required this.allowedToView,
    required this.acknowledgedment,
  });

  final String id;
  final String docUrl;
  final String path;
  final bool seen;
  final String docType;
  final String note;
  final DateTime date;
  final DocumentState state;
  final bool allowedToView;
  final String acknowledgedment;

  factory DocumentModel.fromJson(Map<String, dynamic> data) {
    String id = data["id"] ?? "";
    String path = data["path"] ?? "";
    String docUrl = data["document_url"] ?? "";
    bool seen = data["seen"] ?? false;
    String type = data["type"] ?? "";
    String note = data["note"] ?? "";
    String date = data["date"]!;
    DocumentState state = DocumentState.none;
    bool allowedToView = data["allowed_to_view"] ?? true;
    String acknowledgedment = data["acknowledgedment"] ?? "";

    return DocumentModel(
      id: id,
      docUrl: docUrl,
      path: path,
      seen: seen,
      docType: type,
      note: note,
      state: state,
      date: parseDateTime(date),
      allowedToView: allowedToView,
      acknowledgedment: acknowledgedment,
    );
  }
}
