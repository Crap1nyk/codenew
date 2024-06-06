import 'dart:io';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/document_type_selector_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../dashboard_router.dart';
import '../models/document_upload_page_data.dart';
import 'document_upload_page.dart';

class PdfPreviewPageArgs {
  const PdfPreviewPageArgs({required this.file, this.docType});
  final File file;
  final String? docType;
}

class PdfPreviewPage extends StatelessWidget {
  const PdfPreviewPage({super.key});
  static const route = "${DashboardRouter.baseRoute}/pdf_preview";

  void onContinueClick(BuildContext context, PdfPreviewPageArgs args) {
    if (args.docType == null) {
      Navigator.of(context).pushNamed(
        DcocumentTypeSelectorPage.route,
        arguments: args.file,
      );
    } else {
      Navigator.of(context).pushNamed(
        DocumentUploadPage.route,
        arguments: DocumentUploadPageData(
          args.file,
          args.docType!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PdfPreviewPageArgs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("File Preview"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => onContinueClick(context, args),
        icon: const Icon(Icons.arrow_forward_rounded),
        label: Text(
          "Continue",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SfPdfViewer.file(args.file),
    );
  }
}
