import 'dart:io';

import 'package:dmtransport/pages/home_page/pages/dashboard/models/document_upload_page_data.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/document_upload_page.dart';
import 'package:dmtransport/utils/data.dart';
import 'package:flutter/material.dart';

import '../dashboard_router.dart';

class DcocumentTypeSelectorPage extends StatefulWidget {
  const DcocumentTypeSelectorPage({super.key});
  static const route = "${DashboardRouter.baseRoute}/select_doc_type";

  @override
  State<DcocumentTypeSelectorPage> createState() =>
      _DcocumentTypeSelectorPageState();
}

class _DcocumentTypeSelectorPageState extends State<DcocumentTypeSelectorPage> {
  void onUploadClick(BuildContext context) {
    final file = ModalRoute.of(context)!.settings.arguments as File;

    Navigator.of(context).pushNamed(
      DocumentUploadPage.route,
      arguments: DocumentUploadPageData(
        file,
        Data.documentTypeIds[Data.documentTypeNames[selectedInd]]!,
      ),
    );
  }

  int selectedInd = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Document Type"),
      ),
      floatingActionButton: selectedInd != -1
          ? FloatingActionButton.extended(
              onPressed: () => onUploadClick(context),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(
                "Continue",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : null,
      body: ListView.builder(
        itemBuilder: (context, ind) => ListTile(
          selectedTileColor: const Color.fromARGB(255, 240, 240, 240),
          selected: selectedInd == ind,
          onTap: () {
            setState(() {
              selectedInd = ind;
            });
          },
          title: Text(
            Data.documentTypeNames[ind],
            // style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Icon(
            selectedInd == ind ? Icons.circle : Icons.circle_outlined,
          ),
        ),
        itemCount: Data.documentTypeNames.length,
      ),
    );
  }
}
