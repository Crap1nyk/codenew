import 'dart:math';

import 'package:dmtransport/external/file_picker_handle.dart';
import 'package:dmtransport/pages/home_page/pages/about_page/notifications_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/load_images_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/pdf_preview_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope_forms.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firstpage.dart';
import '../dashboard_router.dart';
import '../models/dashboard_item.dart';
import 'package:document_scanner/document_scanner.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  static const route = "${DashboardRouter.baseRoute}/";

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  final List<DashboardItem> _items = const [
    DashboardItem(
      MAssetImage.scanIcon,
      "Scan Documents",
      id: DashboardButtonId.scanDocuments,
    ),
    DashboardItem(
      MAssetImage.imageUploadIcon,
      "Load Images",
      path: LoadImagesPage.route,
      id: DashboardButtonId.loadImages,
    ),
    DashboardItem(
      MAssetImage.pfdIcon,
      "Upload PDF",
      id: DashboardButtonId.uploadPdf,
    ),
    DashboardItem(
      MAssetImage.ctpatIcon,
      "Forms",
      id: DashboardButtonId.moreForms,
      path: MoreFormsPage.route,
    ),
    DashboardItem(
      MAssetImage.emailIcon,
      "Email Us",
      id: DashboardButtonId.emailUs,
    ),
    DashboardItem(
      MAssetImage.phoneIcon,
      "Call Us",
      id: DashboardButtonId.callUs,
    ),
  ];
  void _onDashboardItemPressed(BuildContext context, DashboardItem item) {
    switch (item.id) {
      case DashboardButtonId.scanDocuments:
        _onScanDocumentsPressed(context);
      case DashboardButtonId.uploadPdf:
        _onSelectPdfPressed(context);
      case DashboardButtonId.emailUs:
        _onEmailUsPressed();
      case DashboardButtonId.callUs:
        _onCallUsPressed();
      case DashboardButtonId.loadImages:
        Navigator.pushNamed(context, item.path!);
        break;
      case DashboardButtonId.moreForms:
        Navigator.pushNamed(context, item.path!);
        break;
    }
  }

  void _onSelectPdfPressed(BuildContext context) {
    FilePickerHandle.pickPdf().then((file) {
      if (file == null) return;
      Navigator.pushNamed(context, PdfPreviewPage.route,
          arguments: PdfPreviewPageArgs(file: file));
    });
  }

  void _onScanDocumentsPressed(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Firstpage();
      // DocumentScanner(onScanDone: (file) {
      //   Navigator.popAndPushNamed(context, PdfPreviewPage.route,
      //       arguments: PdfPreviewPageArgs(file: file));
      // });
    }));
  }

  void _onEmailUsPressed() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'custom@dmtransport.ca',
      query: 'subject=Any Query&body=Hello Sir', //add subject and body here
    );
    launchUrl(params).catchError((err) {
      debugPrint("failed to launch uri to send email\n\t$err");
      return false;
    });
  }

  void _onCallUsPressed() {
    launchUrl(Uri.parse("tel:+18448203434"));
  }

  final int initialNotificationCount = 4;
  final double _itemSpacing = 16.0;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: AppBarTitle(
          name: appState.user.name,
          phone: appState.user.phone,
          image: appState.user.image,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: ((context) {
              return [
                ...(appState.notifications
                    .getRange(
                      0,
                      min(
                        initialNotificationCount,
                        appState.notifications.length,
                      ),
                    )
                    .map(
                      (e) => PopupMenuItem(
                        value: e,
                        enabled: false,
                        child: Text(
                          e.body,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ),
                    )
                    .toList()),
                if (appState.notifications.length > initialNotificationCount)
                  PopupMenuItem(
                    value: "see all",
                    onTap: () => Navigator.of(context)
                        .pushNamed(NotificationsPage.route),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "See All",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .decorationColor,
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        const Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                if (appState.notifications.isEmpty)
                  PopupMenuItem(
                    value: "no norifications",
                    enabled: false,
                    child: Text(
                      "No Notifications",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
              ];
            }),
            icon: const Icon(Icons.notifications_rounded),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          mainAxisSpacing: _itemSpacing,
          crossAxisSpacing: _itemSpacing,
          crossAxisCount: 2,
          children: _items
              .map((e) => DashboardItemWidget(
                    data: e,
                    onPressed: () => _onDashboardItemPressed(context, e),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.name,
    required this.phone,
    required this.image,
  });

  final String name;
  final String phone;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          image,
          width: 50,
          height: 50,
        ),
        const SizedBox(
          width: 8,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            phone,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ]),
      ],
    );
  }
}

class DashboardItemWidget extends StatelessWidget {
  const DashboardItemWidget({
    super.key,
    required this.data,
    this.onPressed,
  });

  final DashboardItem data;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          side: BorderSide(color: Color.fromARGB(255, 220, 220, 220)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              MAssets.image(data.image),
              height: 80,
            ),
            Text(
              data.title,
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        ),
      ),
    );
  }
}
