import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CtpatFormController {
  // TripFormController
  final TextEditingController tripOrderNoController = TextEditingController();
  final TextEditingController trailerLoadingPointController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController trailerIdController = TextEditingController();
  final TextEditingController sealNumberOneController = TextEditingController();
  final TextEditingController sealNumberTwoController = TextEditingController();
  final TextEditingController sealRemovedController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  String selectedlocationType = "Shipper";
  String selectedagree = "false";

  Future<void> CtpatFormsave(CtpatFormData ctpatFormData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('2tripOrderNo', ctpatFormData.tripOrderNo);
    prefs.setString('2trailerLoadingPoint', ctpatFormData.trailerLoadingPoint);
    prefs.setString('2address', ctpatFormData.address);
    prefs.setString('2billNumber', ctpatFormData.billNumber);
    prefs.setString('2trailerId', ctpatFormData.trailerId);
    prefs.setString('2sealNumberOne', ctpatFormData.sealNumberOne);
    prefs.setString('2sealNumberTwo', ctpatFormData.sealNumberTwo);
    prefs.setString('2sealRemoved', ctpatFormData.sealRemoved);
    prefs.setString('2comments', ctpatFormData.comments);
    prefs.setString(
        '2selectedLocationType', ctpatFormData.selectedLocationType);
    prefs.setString('2selectedAgree', ctpatFormData.selectedAgree);
  }
}

class CtpatFormData {
  final String tripOrderNo;
  final String trailerLoadingPoint;
  final String address;
  final String billNumber;
  final String trailerId;
  final String sealNumberOne;
  final String sealNumberTwo;
  final String sealRemoved;
  final String comments;
  final String selectedLocationType;
  final String selectedAgree;

  CtpatFormData({
    required this.tripOrderNo,
    required this.trailerLoadingPoint,
    required this.address,
    required this.billNumber,
    required this.trailerId,
    required this.sealNumberOne,
    required this.sealNumberTwo,
    required this.sealRemoved,
    required this.comments,
    required this.selectedLocationType,
    required this.selectedAgree,
  });
}
