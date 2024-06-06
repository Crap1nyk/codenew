// controllers.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormController {
  // Form Controllers
  final TextEditingController tripNumberController = TextEditingController();
  late TextEditingController dateController = TextEditingController();
  final TextEditingController truckNumberController = TextEditingController();
  final TextEditingController driverName1Controller = TextEditingController();
  final TextEditingController driverName2Controller = TextEditingController();
  final TextEditingController totalDurationController = TextEditingController();
  final TextEditingController startDisController = TextEditingController();
  final TextEditingController endDisController = TextEditingController();
  final TextEditingController extraCommentController = TextEditingController();
  final TextEditingController expenseNoteController = TextEditingController();
  String selectedTrailertype = 'Flatbed'; // Provide an initial value

  // Trailer Details Controllers
  final TextEditingController trailerNumberController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController reeferTemperatureController =
      TextEditingController();
  String selectedEventtype = 'Pickup'; // Provide an initial value

  // Fuel Location Details Controllers
  final TextEditingController fuelDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  Future<void> save(FormData formData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tripNumber', formData.tripNumber);
    prefs.setString('date', formData.date);
    prefs.setString('truckNumber', formData.truckNumber);
    prefs.setString('driverName1', formData.driverName1);
    prefs.setString('driverName2', formData.driverName2);
    prefs.setString('totalDuration', formData.totalDuration);
    prefs.setString('startDistance', formData.startDistance);
    prefs.setString('endDistance', formData.endDistance);
    prefs.setString('extraComment', formData.extraComment);
    prefs.setString('expenseNote', formData.expenseNote);
    prefs.setString('selectedTrailerType', formData.selectedTrailerType);

    prefs.setString('trailerNumber', formData.trailerNumber);
    prefs.setString('companyName', formData.companyName);
    prefs.setString('cityName', formData.cityName);
    prefs.setString('province', formData.province);
    prefs.setString('reeferTemperature', formData.reeferTemperature);
    prefs.setString('selectedEventtype', formData.selectedEventtype);

    // Fuel Location Details Controllers
    prefs.setString('fuelDate', formData.fuelDate);
    prefs.setString('location', formData.location);
    prefs.setString('quantity', formData.quantity);
    prefs.setString('amount', formData.amount);
  }
}

class FormData {
  final String tripNumber;
  final String date;
  final String truckNumber;
  final String driverName1;
  final String driverName2;
  final String totalDuration;
  final String startDistance;
  final String endDistance;
  final String extraComment;
  final String expenseNote;
  final String selectedTrailerType;

  final String trailerNumber;
  final String companyName;
  final String cityName;
  final String province;
  final String reeferTemperature;
  final String selectedEventtype;

  final String fuelDate;
  final String location;
  final String quantity;
  final String amount;

  FormData({
    required this.tripNumber,
    required this.date,
    required this.truckNumber,
    required this.driverName1,
    required this.driverName2,
    required this.totalDuration,
    required this.startDistance,
    required this.endDistance,
    required this.extraComment,
    required this.expenseNote,
    required this.selectedTrailerType,
    required this.trailerNumber,
    required this.companyName,
    required this.cityName,
    required this.province,
    required this.reeferTemperature,
    required this.selectedEventtype,
    required this.fuelDate,
    required this.location,
    required this.quantity,
    required this.amount,
  });
}
