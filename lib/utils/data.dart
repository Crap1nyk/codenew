import 'package:flutter/material.dart';

import '../pages/home_page/pages/messages_page/models/contact.dart';

class Data {
  static const List<String> _chatContactNames = ["Admin", "Maintenance Team"];
  static const List<IconData> _chatContacticons = [
    Icons.admin_panel_settings,
    Icons.settings
  ];

  static const List<String> documentTypeNames = [
    "Pickup Doc",
    "Delivery Proof",
    "Load Image",
    "Fuel Recipt",
    "Stamp Paper", // paper_logs <Name was changed later but backend person was too lazy to change so name was not changed there>
    "Driver expense",
    "DM Transport Trip Envelope",
    "DM Transport City Worksheet",
    "DM Trans Inc Trip Envelope",
    "Repair and maintenance",
    "CTPAT",
  ];

  static const List<String> documentTypes = [
    "pick_up",
    "delivery",
    "load_image",
    "fuel_recipt",
    "paper_logs",
    "driver_expense_sheet",
    "dm_transport_trip_envelope",
    "dm_transport_city_worksheet_trip_envelope",
    "dm_trans_inc_trip_envelope",
    "trip_envelope",
    "CTPAT",
  ];

  static Map<String, String> documentTypeIds = Map.fromIterables(
    documentTypeNames,
    documentTypes,
  );

  static Map<String, String> documentTypeIdsToName = Map.fromIterables(
    documentTypes,
    documentTypeNames,
  );

  static final List<Contact> contacts = List.generate(
    2,
    (index) => Contact(_chatContactNames[index], _chatContacticons[index]),
  );

  static const String aboutDmTransport =
      "Welcome to the DM Transport, we are a complete supply chain network who are fired & geared up to provide you with the customised logistics solutions per your requirements.DM Transport is making a headway in providing innovative freight solutions and taking utmost care when it comes to transportation of your goods. As we understand that while moving your goods there is quite a lot of sentimental value stringed to it. So we deal with the logistic needs very efficiently. We have a wide network to provide our clients with flawless logistic services across North America and along with assuring the most competitive pricing. Our services cover an array of requirements like temperature controlled transfers, flatbed trucking services, less-than-truckload (LTL) and truckload (TL) shipping needs. Our team who has accrued the freight industry knowledge over the years is dedicated to delivering you the most efficient and professional freight services.";
}
