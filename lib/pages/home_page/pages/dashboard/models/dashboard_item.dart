import 'package:dmtransport/utils/assets.dart';

enum DashboardButtonId {
  scanDocuments,
  loadImages,
  uploadPdf,
  emailUs,
  callUs,
  moreForms,
}

class DashboardItem {
  final DashboardButtonId id;
  final MAssetImage image;
  final String title;
  final String? path;

  const DashboardItem(this.image, this.title, {required this.id, this.path});
}
