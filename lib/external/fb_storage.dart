import 'dart:io';

import 'package:dmtransport/external/uuid_handle.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FbStorage {
  static const Map<String, String> _buckets = {
    "US": "gs://dmtransport-1.appspot.com",
    "IN": "gs://dmt-bucket-asia-south",
  };

  static (UploadTask, Reference) uploadDocument(
      File file, Map<String, String> metaData) {
    final metadata = SettableMetadata(
      contentType: "document/pdf",
      customMetadata: metaData,
    );

    final storageRef = FirebaseStorage.instanceFor(
      bucket: _buckets["IN"]!,
    ).ref();

    final uploadRef = storageRef.child(
      "documents/${metaData["document_type"]}/${UuidHandle.generate()}.pdf",
    );

    return (uploadRef.putFile(file, metadata), uploadRef);
  }
}
