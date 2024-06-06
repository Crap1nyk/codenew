import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DmtWSFormController {
  // TripFormController
  final TextEditingController tripNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController truckNumberController = TextEditingController();

  // DistanceController
  final TextEditingController startDistanceController = TextEditingController();
  final TextEditingController endDistanceController = TextEditingController();

  // TimeController
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController totalDurationController = TextEditingController();

  // Additional Form Fields
  final TextEditingController extraCommentController = TextEditingController();
  final TextEditingController expenseNoteController = TextEditingController();
  String selectedEventtype1 = 'Flatbed'; // Provide an initial value

  // Trailer Details Controllers
  final TextEditingController trailerNumberController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController probillNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  String selectedEventtype2 = 'Pickup'; // Provide an initial value

  // Fuel Location Details Controllers
  final TextEditingController fuelDateController = TextEditingController();
  final TextEditingController locationFuelController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  DmtWSFormController();

  Future<void> DmtWSFormsave(DmtWSFormData dmtWSFormData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('1tripNumber', dmtWSFormData.tripNumber);
    prefs.setString('1date', dmtWSFormData.date);
    prefs.setString('1driverName', dmtWSFormData.driverName);
    prefs.setString('1truckNumber', dmtWSFormData.truckNumber);
    prefs.setString('1startDistance', dmtWSFormData.startDistance);
    prefs.setString('1endDistance', dmtWSFormData.endDistance);
    prefs.setString('1startTime', dmtWSFormData.startTime);
    prefs.setString('1endTime', dmtWSFormData.endTime);
    prefs.setString('1totalDuration', dmtWSFormData.totalDuration);
    prefs.setString('1extraComment', dmtWSFormData.extraComment);
    prefs.setString('1expenseNote', dmtWSFormData.expenseNote);
    prefs.setString('1selectedEventtype1', dmtWSFormData.selectedEventtype1);

    prefs.setString('1trailerNumber', dmtWSFormData.trailerNumber);
    prefs.setString('1weight', dmtWSFormData.weight);
    prefs.setString('1probillNumber', dmtWSFormData.probillNumber);
    prefs.setString('1location', dmtWSFormData.location);
    prefs.setString('1comments', dmtWSFormData.comments);
    prefs.setString('1selectedEventtype2', dmtWSFormData.selectedEventtype2);

    prefs.setString('1fuelDate', dmtWSFormData.fuelDate);
    prefs.setString('1locationFuel', dmtWSFormData.locationFuel);
    prefs.setString('1quantity', dmtWSFormData.quantity);
    prefs.setString('1amount', dmtWSFormData.amount);
  }
}

class DmtWSFormData {
  final String tripNumber;
  final String date;
  final String driverName;
  final String truckNumber;
  final String startDistance;
  final String endDistance;
  final String startTime;
  final String endTime;
  final String totalDuration;
  final String extraComment;
  final String expenseNote;
  final String selectedEventtype1;

  final String trailerNumber;
  final String weight;
  final String probillNumber;
  final String location;
  final String comments;
  final String selectedEventtype2;

  final String fuelDate;
  final String locationFuel;
  final String quantity;
  final String amount;

  DmtWSFormData({
    required this.tripNumber,
    required this.date,
    required this.driverName,
    required this.truckNumber,
    required this.startDistance,
    required this.endDistance,
    required this.startTime,
    required this.endTime,
    required this.totalDuration,
    required this.extraComment,
    required this.expenseNote,
    required this.selectedEventtype1,
    required this.trailerNumber,
    required this.weight,
    required this.probillNumber,
    required this.location,
    required this.comments,
    required this.selectedEventtype2,
    required this.fuelDate,
    required this.locationFuel,
    required this.quantity,
    required this.amount,
  });
}
