import 'package:dmtransport/external/pdf.handle.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/pdf_preview_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/DmtWSForm_controller.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DmtWSForm extends StatefulWidget {
  const DmtWSForm({super.key});
  static const String route = "dmt_work_sheet_form";
  @override
  State<DmtWSForm> createState() => _DmtWSFormState();
}

class _DmtWSFormState extends State<DmtWSForm> {
  final _formKey = GlobalKey<FormState>();
  late ScreenshotController screenshotController;
  late String formType;
  late DmtWSFormController dmtWSFormController;

  @override
  void initState() {
    dmtWSFormController = DmtWSFormController();

    screenshotController = ScreenshotController();
    dmtWSformDataload();
    super.initState();
  }

  Future<void> onDmtWSFormsave() async {
    dmtWSFormController.DmtWSFormsave(DmtWSFormData(
      tripNumber: dmtWSFormController.tripNumberController.text,
      date: dmtWSFormController.dateController.text,
      driverName: dmtWSFormController.driverNameController.text,
      truckNumber: dmtWSFormController.truckNumberController.text,
      startDistance: dmtWSFormController.startDistanceController.text,
      endDistance: dmtWSFormController.endDistanceController.text,
      startTime: dmtWSFormController.startTimeController.text,
      endTime: dmtWSFormController.endTimeController.text,
      totalDuration: dmtWSFormController.totalDurationController.text,
      extraComment: dmtWSFormController.extraCommentController.text,
      expenseNote: dmtWSFormController.expenseNoteController.text,
      selectedEventtype1: dmtWSFormController.selectedEventtype1, //
      trailerNumber: dmtWSFormController.trailerNumberController.text,
      weight: dmtWSFormController.weightController.text,
      probillNumber: dmtWSFormController.probillNumberController.text,
      location: dmtWSFormController.locationController.text,
      comments: dmtWSFormController.commentsController.text,
      selectedEventtype2: dmtWSFormController.selectedEventtype2,
      fuelDate: dmtWSFormController.fuelDateController.text,
      locationFuel: dmtWSFormController.locationFuelController.text,
      quantity: dmtWSFormController.quantityController.text,
      amount: dmtWSFormController.amountController.text,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form data saved')),
    );
  }

  Future<void> dmtWSformDataload() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dmtWSFormController.tripNumberController.text =
          prefs.getString('1tripNumber') ?? '';
      dmtWSFormController.dateController.text = prefs.getString('1date') ?? '';
      dmtWSFormController.driverNameController.text =
          prefs.getString('1driverName') ?? '';
      dmtWSFormController.truckNumberController.text =
          prefs.getString('1truckNumber') ?? '';
      dmtWSFormController.startDistanceController.text =
          prefs.getString('1startDistance') ?? '';
      dmtWSFormController.endDistanceController.text =
          prefs.getString('1endDistance') ?? '';
      dmtWSFormController.startTimeController.text =
          prefs.getString('1startTime') ?? '';
      dmtWSFormController.endTimeController.text =
          prefs.getString('1endTime') ?? '';
      dmtWSFormController.totalDurationController.text =
          prefs.getString('1totalDuration') ?? '';
      dmtWSFormController.extraCommentController.text =
          prefs.getString('1extraComment') ?? '';
      dmtWSFormController.expenseNoteController.text =
          prefs.getString('1expenseNote') ?? '';
      dmtWSFormController.selectedEventtype1 =
          prefs.getString('1selectedEventtype1') ?? 'Flatbed';

      dmtWSFormController.trailerNumberController.text =
          prefs.getString('1trailerNumber') ?? '';
      dmtWSFormController.weightController.text =
          prefs.getString('1weight') ?? '';
      dmtWSFormController.probillNumberController.text =
          prefs.getString('1probillNumber') ?? '';
      dmtWSFormController.locationController.text =
          prefs.getString('1location') ?? '';
      dmtWSFormController.commentsController.text =
          prefs.getString('1comments') ?? '';
      dmtWSFormController.selectedEventtype2 =
          prefs.getString('1selectedEventtype2') ?? 'Pickup';

      dmtWSFormController.fuelDateController.text =
          prefs.getString('1fuelDate') ?? '';
      dmtWSFormController.locationFuelController.text =
          prefs.getString('1locationFuel') ?? '';
      dmtWSFormController.quantityController.text =
          prefs.getString('1quantity') ?? '';
      dmtWSFormController.amountController.text =
          prefs.getString('1amount') ?? '';
    });
  }

  bool screenShotMode = false;

  void onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.remove('odometerType');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );
    setState(() {
      screenShotMode = true;
    });

    screenshotController.capture().then((value) {
      setState(() {
        screenShotMode = false;
      });
      PdfHandle.rawImagesToPdf([value!]).then(
        (file) => Navigator.of(context).pushNamed(
          PdfPreviewPage.route,
          arguments: PdfPreviewPageArgs(
            file: file,
            docType: formType,
          ),
        ),
      );
    });
  }

  double distance = 0.0;
  final trailerDetails = {0: const ValueKey("trailer0")};

  void deleteTrailer(int ind) {
    setState(() {
      trailerDetails.remove(ind);
    });
  }

  void onAddTrailerDetails() {
    setState(() {
      int ind = trailerDetails.keys.last + 1;
      trailerDetails[ind] = ValueKey("trailer$ind");
    });
  }

  final fuelLocations = {};

  void deleteFuelDetail(int ind) {
    setState(() {
      fuelLocations.remove(ind);
    });
  }

  void onAddFuelLocationDetails() {
    int ind = 0;
    if (fuelLocations.isNotEmpty) ind = fuelLocations.keys.last + 1;
    setState(() {
      fuelLocations[ind] = ValueKey("fuel$ind");
    });
  }

  final TextEditingController _startDisController = TextEditingController();
  final TextEditingController _endDisController = TextEditingController();

  void _onDisChange(_) {
    if (_startDisController.text.isEmpty || _endDisController.text.isEmpty) {
      return;
    }
    double end = double.parse(_endDisController.text);
    double start = double.parse(_startDisController.text);
    if (end < start) return;
    setState(() {
      distance = end - start;
    });
  }

  final TextEditingController _startTime = TextEditingController();
  final TextEditingController _endTime = TextEditingController();

  String timeDiff = "";

  void onTimeChange(_) {
    if (!isTimeValid(_startTime.text) || !isTimeValid(_endTime.text)) {
      return;
    }

    DateTime startDateTime = DateTime.parse("2023-01-01 ${_startTime.text}");
    DateTime endDateTime = DateTime.parse("2023-01-01 ${_endTime.text}");

    Duration difference = endDateTime.difference(startDateTime);

    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    setState(() {
      timeDiff =
          "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    formType = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill the following form"),
        actions: [
          TextButton.icon(
            onPressed: () {
              onDmtWSFormsave();
            },
            icon: const Icon(Icons.save),
            label: const Text("Save"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dmtWSFormController.tripNumberController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("Trip Number"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: dmtWSFormController.dateController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("Date(mm/dd/yy)"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dmtWSFormController.driverNameController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("Driver Name"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: dmtWSFormController.truckNumberController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("Truck Number"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const MyRadioField(
                    sharedPreferencesKey: '1OdometerType',
                    label: "Odometer Type",
                    fields: ["KM", "MILES"],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller:
                              dmtWSFormController.startDistanceController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          onChanged: _onDisChange,
                          // controller: _startDisController,
                          decoration: const InputDecoration(
                            label: Text("Starting Distance"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: dmtWSFormController.endDistanceController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          onChanged: _onDisChange,
                          // controller: _endDisController,
                          decoration: const InputDecoration(
                            label: Text("Ending Distance"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total Distance $distance",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dmtWSFormController.startTimeController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          onChanged: onTimeChange,
                          // controller: _startTime,
                          decoration: const InputDecoration(
                            label: Text("Start Time(hh/mm)"),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: MyRadioField(
                          label: "",
                          fields: ["AM", "PM"],
                          sharedPreferencesKey: '1time1',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dmtWSFormController.endTimeController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          onChanged: onTimeChange,
                          // controller: _endTime,
                          decoration: const InputDecoration(
                            label: Text("Finish Time(hh/mm)"),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: MyRadioField(
                          label: "",
                          fields: ["AM", "PM"],
                          sharedPreferencesKey: '1time2',
                        ),
                      ),
                    ],
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Text(
                  //     "Total Time: $timeDiff",
                  //     style: Theme.of(context).textTheme.bodyLarge,
                  //   ),
                  // ),
                  TextFormField(
                    controller: dmtWSFormController.totalDurationController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Can't be empty";
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("Total Duration (hours)"),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // ------ Trailer Details -------
                  Text(
                    "Trailer Details",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...(trailerDetails.keys
                      .map(
                        (key) => TrailerDetails(
                          key: trailerDetails[key],
                          isDeleteable: key != 0,
                          onDelete: deleteTrailer,
                          ind: key,
                          screenShotMode: screenShotMode,
                          dmtWSFormController: dmtWSFormController,
                        ),
                      )
                      .toList()),
                  if (!screenShotMode)
                    TextButton.icon(
                      onPressed: onAddTrailerDetails,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text("Add Trailer Details"),
                    ),
                  // TextFormField(
                  //   key: const ValueKey(
                  //       "layover-tf"), // this key is there to maintain its value when form is changed during screenshot
                  //   validator: (v) {
                  //     if (v == null || v.isEmpty) return "Can't be empty";
                  //     return null;
                  //   },
                  //   decoration: const InputDecoration(
                  //     label: Text("Layover"),
                  //   ),
                  // ),
                  TextFormField(
                    controller: dmtWSFormController.extraCommentController,
                    key: const ValueKey("extra-comment-tf"),
                    decoration: const InputDecoration(
                      label: Text("Extra Comment"),
                    ),
                  ),
                  TextFormField(
                    controller: dmtWSFormController.expenseNoteController,
                    key: const ValueKey("expense-note-tf"),
                    decoration: const InputDecoration(
                      label: Text("Expense Note"),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // ------ Fuel Details -------
                  if (!screenShotMode || fuelLocations.isNotEmpty)
                    Text(
                      "Fuel Details",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  if (!screenShotMode || fuelLocations.isNotEmpty)
                    ...(fuelLocations.keys
                        .map(
                          (key) => FuelLocationDetails(
                            key: fuelLocations[key],
                            isDeleteable: true,
                            onDelete: deleteFuelDetail,
                            ind: key,
                            screenShotMode: screenShotMode,
                            dmtWSFormController: dmtWSFormController,
                          ),
                        )
                        .toList()),
                  if (!screenShotMode)
                    TextButton.icon(
                      onPressed: onAddFuelLocationDetails,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text("Add Fuel Details"),
                    ),
                  if (!screenShotMode)
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: onSubmit,
                        icon: const Icon(Icons.done_rounded),
                        label: const Text("Submit"),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FuelLocationDetails extends StatefulWidget {
  const FuelLocationDetails({
    super.key,
    required this.isDeleteable,
    this.onDelete,
    required this.ind,
    required this.screenShotMode,
    required this.dmtWSFormController,
  });

  final bool isDeleteable;
  final void Function(int ind)? onDelete;
  final int ind;
  final bool screenShotMode;
  final DmtWSFormController dmtWSFormController;

  @override
  State<FuelLocationDetails> createState() => _FuelLocationDetailsState();
}

class _FuelLocationDetailsState extends State<FuelLocationDetails> {
  // final TextEditingController _startTime = TextEditingController();
  // final TextEditingController _endTime = TextEditingController();

  // String timeDiff = "";

  // void onTimeChange(_) {
  //   if (!isTimeValid(_startTime.text) || !isTimeValid(_endTime.text)) {
  //     return;
  //   }
  //   var tokens = _startTime.text.split("/");
  //   int hh = int.parse(tokens[0]);
  //   int mm = int.parse(tokens[0]);
  //   int start = (hh * 60) + mm;
  //   tokens = _endTime.text.split("/");
  //   hh = int.parse(tokens[0]);
  //   mm = int.parse(tokens[0]);
  //   int end = (hh * 60) + mm;
  //   int diff = (end - start).abs();
  //   setState(() {
  //     timeDiff =
  //         "${"${diff ~/ 60}".padLeft(2, "0")}:${"${diff % 60}".padLeft(2, "0")}";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.dmtWSFormController.fuelDateController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Fuel Date (mm/dd/yy)"),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.dmtWSFormController.locationFuelController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Location"),
                  ),
                ),
              ),
            ],
          ),
          const MyRadioField(
            sharedPreferencesKey: '1QuantityType',
            label: "Quantity Type",
            fields: ["Gallon", "Litre"],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.dmtWSFormController.quantityController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Quantity"),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.dmtWSFormController.amountController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Amount"),
                  ),
                ),
              ),
            ],
          ),
          if (widget.isDeleteable && !widget.screenShotMode)
            IconButton(
              onPressed: () => widget.onDelete?.call(widget.ind),
              icon: const Icon(Icons.delete_rounded),
            ),
        ],
      ),
    );
  }
}

class TrailerDetails extends StatefulWidget {
  TrailerDetails({
    super.key,
    required this.isDeleteable,
    this.onDelete,
    required this.ind,
    required this.screenShotMode,
    required this.dmtWSFormController,
  });

  final bool isDeleteable;
  final void Function(int ind)? onDelete;
  final int ind;
  final bool screenShotMode;
  late DmtWSFormController dmtWSFormController;

  @override
  State<TrailerDetails> createState() => _TrailerDetailsState();
}

class _TrailerDetailsState extends State<TrailerDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller:
                      widget.dmtWSFormController.trailerNumberController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Trailer Number"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Event",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: widget.dmtWSFormController.selectedEventtype1,
                  onChanged: (value) {
                    setState(() {
                      widget.dmtWSFormController.selectedEventtype1 = value!;
                    });
                  },
                  validator: (v) {
                    if (v == null) {
                      return "Select One";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(value: "Flatbed", child: Text("Flatbed")),
                    DropdownMenuItem(value: "Reefer", child: Text("Reefer")),
                    DropdownMenuItem(value: "Dryvan", child: Text("Dryvan")),
                  ],
                  // onChanged: (String? value) {},
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.dmtWSFormController.weightController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Weight in pounds(lbs)"),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller:
                      widget.dmtWSFormController.probillNumberController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Probill Number"),
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: widget.dmtWSFormController.locationController,
            validator: (v) {
              if (v == null || v.isEmpty) return "Can't be empty";
              return null;
            },
            decoration: const InputDecoration(
              label: Text("Location"),
            ),
          ),
          TextFormField(
            controller: widget.dmtWSFormController.commentsController,
            validator: (v) {
              if (v == null || v.isEmpty) return "Can't be empty";
              return null;
            },
            decoration: const InputDecoration(
              label: Text("Comments"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Event",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: widget.dmtWSFormController.selectedEventtype2,
                  onChanged: (value) {
                    setState(() {
                      widget.dmtWSFormController.selectedEventtype2 = value!;
                    });
                  },
                  validator: (v) {
                    if (v == null) {
                      return "Select One";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(value: "Pickup", child: Text("Pickup")),
                    DropdownMenuItem(value: "Hook", child: Text("Hook")),
                    DropdownMenuItem(value: "Deliver", child: Text("Deliver")),
                    DropdownMenuItem(value: "Drop", child: Text("Drop")),
                  ],
                ),
              ),
            ],
          ),
          if (widget.isDeleteable && !widget.screenShotMode)
            IconButton(
              onPressed: () => widget.onDelete?.call(widget.ind),
              icon: const Icon(Icons.delete_rounded),
            ),
        ],
      ),
    );
  }
}

// class MyRadioField extends FormField<bool> {
//   final String label;
//   final List<String> fields;

//   MyRadioField({
//     super.key,
//     required this.label,
//     required this.fields,
//     super.onSaved,
//     super.validator,
//     super.initialValue,
//   }) : super(
//           builder: (FormFieldState<bool> state) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         label,
//                         softWrap: true,
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: state.hasError ? Colors.red : null),
//                       ),
//                       const SizedBox(
//                         width: 16,
//                       ),
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Expanded(
//                               child: RadioListTile<bool>.adaptive(
//                                 contentPadding: EdgeInsets.zero,
//                                 value: true,
//                                 dense: true,
//                                 groupValue: state.value,
//                                 onChanged: state.didChange,
//                                 title: Text(
//                                   fields[0],
//                                   style: TextStyle(
//                                     color: state.hasError ? Colors.red : null,
//                                   ),
//                                 ),
//                                 fillColor: state.hasError
//                                     ? const MaterialStatePropertyAll(Colors.red)
//                                     : null,
//                               ),
//                             ),
//                             Expanded(
//                               child: RadioListTile<bool>.adaptive(
//                                 contentPadding: EdgeInsets.zero,
//                                 dense: true,
//                                 value: false,
//                                 groupValue: state.value,
//                                 onChanged: state.didChange,
//                                 title: Text(
//                                   fields[1],
//                                   style: TextStyle(
//                                     color: state.hasError ? Colors.red : null,
//                                   ),
//                                 ),
//                                 fillColor: state.hasError
//                                     ? const MaterialStatePropertyAll(Colors.red)
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (state.hasError)
//                     Text(
//                       state.errorText ?? "",
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                 ],
//               ),
//             );
//           },
//         );
// }

class MyRadioField extends StatefulWidget {
  final String label;
  final List<String> fields;
  final String sharedPreferencesKey;

  const MyRadioField({
    super.key,
    required this.label,
    required this.fields,
    required this.sharedPreferencesKey,
  });

  @override
  _MyRadioFieldState createState() => _MyRadioFieldState();
}

class _MyRadioFieldState extends State<MyRadioField> {
  bool? _value;

  @override
  void initState() {
    super.initState();
    _loadValueFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                softWrap: true,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: RadioListTile<bool>.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: true,
                        dense: true,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value!;
                            _saveValueToSharedPreferences(_value!);
                          });
                        },
                        title: Text(widget.fields[0]),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>.adaptive(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        value: false,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value!;
                            _saveValueToSharedPreferences(_value!);
                          });
                        },
                        title: Text(widget.fields[1]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadValueFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getBool(widget.sharedPreferencesKey) ?? true;
    });
  }

  void _saveValueToSharedPreferences(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.sharedPreferencesKey, value);
  }
}
