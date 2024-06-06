import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/ctpat.page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/dmt_form.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/dmt_w_s_form.dart';
import 'package:dmtransport/utils/data.dart';
import 'package:flutter/material.dart';

class MoreFormsPage extends StatefulWidget {
  const MoreFormsPage({super.key});

  static const String route = "trip_envolope_forms_page";
  @override
  State<MoreFormsPage> createState() => _MoreFormsPageState();
}

class _MoreFormsPageState extends State<MoreFormsPage> {
  final List<String> _formRoutes = [
    CtpatPage.route,
    DmtFormPage.route,
    DmtFormPage.route,
    DmtWSForm.route,
  ];

  final List<String> _formTypes = [
    "CTPAT",
    "dm_transport_trip_envelope",
    "dm_trans_inc_trip_envelope",
    "dm_transport_city_worksheet_trip_envelope",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More Forms"),
      ),
      body: ListView.builder(
        itemCount: _formTypes.length,
        itemBuilder: (context, ind) {
          return ListTile(
            onTap: () => Navigator.of(context).pushNamed(
              _formRoutes[ind],
              arguments: _formTypes[ind],
            ),
            title: Text(Data.documentTypeIdsToName[_formTypes[ind]]!),
            trailing: const Icon(Icons.arrow_forward_rounded),
          );
        },
      ),
    );
  }
}
