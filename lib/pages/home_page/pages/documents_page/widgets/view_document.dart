import 'package:dmtransport/models/document.model.dart';
import 'package:dmtransport/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewDocument extends StatefulWidget {
  const ViewDocument({super.key});
  static const String route = "${HomePage.id}/dashboard/view-document";

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context)!.settings.arguments as DocumentModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Document"),
      ),
      body: SfPdfViewer.network(
        doc.docUrl,
        controller: _pdfViewerController,
      ),
    );
  }
}
