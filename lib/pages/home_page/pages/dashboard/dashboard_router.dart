import 'package:dmtransport/pages/home_page/home_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/ctpat.page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/dmt_form.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/dmt_w_s_form.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope_forms.dart';
import 'pages/dashboard_home_page.dart';
import 'pages/document_upload_page.dart';
import 'pages/load_images_page.dart';
import 'pages/document_type_selector_page.dart';
import 'pages/pdf_preview_page.dart';
import 'package:flutter/material.dart';

class DashboardRouter {
  static const String baseRoute = "${HomePage.id}/dashboard";
  static final Map<String, Widget Function(BuildContext)> routes = {
    DashboardHomePage.route: (context) => const DashboardHomePage(),
    LoadImagesPage.route: (context) => const LoadImagesPage(),
    DcocumentTypeSelectorPage.route: (context) =>
        const DcocumentTypeSelectorPage(),
    PdfPreviewPage.route: (context) => const PdfPreviewPage(),
    DocumentUploadPage.route: (context) => const DocumentUploadPage(),
    MoreFormsPage.route: (context) => const MoreFormsPage(),
    DmtFormPage.route: (context) => const DmtFormPage(),
    DmtWSForm.route: (context) => const DmtWSForm(),
    CtpatPage.route: (context) => const CtpatPage(),
  };
}
