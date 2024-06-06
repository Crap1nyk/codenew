import 'package:dmtransport/external/pdf.handle.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/pdf_preview_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/formcontroller.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DmtFormPage extends StatefulWidget {
  const DmtFormPage({super.key});

  static const String route = "dmt_form_page";

  @override
  State<DmtFormPage> createState() => _DmtFormPageState();
}

class _DmtFormPageState extends State<DmtFormPage> {
  final _formKey = GlobalKey<FormState>();
  late ScreenshotController screenshotController;
  late String formType;
  late FormController formController;

  @override
  void initState() {
    formController = FormController();
    populateForm();
    screenshotController = ScreenshotController();
    super.initState();
  }

  Future<void> onSave() async {
    formController.save(FormData(
      tripNumber: formController.tripNumberController.text,
      date: formController.dateController.text,
      truckNumber: formController.truckNumberController.text,
      driverName1: formController.driverName1Controller.text,
      driverName2: formController.driverName2Controller.text,
      totalDuration: formController.totalDurationController.text,
      startDistance: formController.startDisController.text,
      endDistance: formController.endDisController.text,
      extraComment: formController.extraCommentController.text,
      expenseNote: formController.expenseNoteController.text,
      selectedTrailerType: formController.selectedTrailertype,
      trailerNumber: formController.trailerNumberController.text,
      companyName: formController.companyNameController.text,
      cityName: formController.cityNameController.text,
      province: formController.provinceController.text,
      reeferTemperature: formController.reeferTemperatureController.text,
      selectedEventtype: formController.selectedEventtype,
      fuelDate: formController.fuelDateController.text,
      location: formController.locationController.text,
      quantity: formController.quantityController.text,
      amount: formController.amountController.text,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form data saved')),
    );
  }

  Future<void> populateForm() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      formController.tripNumberController.text =
          prefs.getString('tripNumber') ?? '';
      formController.dateController.text = prefs.getString('date') ?? '';
      formController.truckNumberController.text =
          prefs.getString('truckNumber') ?? '';
      formController.driverName1Controller.text =
          prefs.getString('driverName1') ?? '';
      formController.driverName2Controller.text =
          prefs.getString('driverName2') ?? '';
      formController.totalDurationController.text =
          prefs.getString('totalDuration') ?? '';
      formController.startDisController.text =
          prefs.getString('startDistance') ?? '';
      formController.endDisController.text =
          prefs.getString('endDistance') ?? '';

      formController.extraCommentController.text =
          prefs.getString('extraComment') ?? '';
      formController.expenseNoteController.text =
          prefs.getString('expenseNote') ?? '';

      formController.selectedTrailertype =
          prefs.getString('selectedTrailerType') ?? 'Flatbed';

      formController.trailerNumberController.text =
          prefs.getString('trailerNumber') ?? '';

      formController.companyNameController.text =
          prefs.getString('companyName') ?? '';

      formController.cityNameController.text =
          prefs.getString('cityName') ?? '';

      formController.provinceController.text =
          prefs.getString('province') ?? '';

      formController.reeferTemperatureController.text =
          prefs.getString('reeferTemperature') ?? '';

      formController.selectedEventtype =
          prefs.getString('selectedEventtype') ?? 'Pickup';

      formController.fuelDateController.text =
          prefs.getString('fuelDate') ?? '';
      formController.locationController.text =
          prefs.getString('location') ?? '';
      formController.quantityController.text =
          prefs.getString('quantity') ?? '';
      formController.amountController.text = prefs.getString('amount') ?? '';
    });
  }

  bool screenShotMode = false;

  Future<void> onSubmit() async {
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

  void _onDisChange(_) {
    if (formController.startDisController.text.isEmpty ||
        formController.endDisController.text.isEmpty) {
      if (formController.startDisController.text.isEmpty &&
          formController.endDisController.text.isEmpty) {
        setState(() {
          distance = 0.0;
        });
      }
      return;
    }
    double end = double.parse(formController.endDisController.text);
    double start = double.parse(formController.startDisController.text);
    setState(() {
      distance = end - start;
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
              onSave();
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Trailer Type",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: formController.selectedTrailertype,
                          onChanged: (value) {
                            setState(() {
                              formController.selectedTrailertype = value!;
                            });
                          },
                          validator: (v) {
                            if (v == null) {
                              return "Please select a trailer type";
                            }
                            return null;
                          },
                          items: const [
                            DropdownMenuItem(
                                value: "Flatbed", child: Text("Flatbed")),
                            DropdownMenuItem(
                                value: "Reefer", child: Text("Reefer")),
                            DropdownMenuItem(
                                value: "Dryvan", child: Text("Dryvan")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: formController
                              .tripNumberController, // Add this line

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
                          controller: formController.truckNumberController,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          decoration: const InputDecoration(
                              label: Text("Truck Number")),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: formController.driverName1Controller,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          decoration: const InputDecoration(
                              label: Text("Driver Name 1")),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: formController.driverName2Controller,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          decoration: const InputDecoration(
                              label: Text("Driver Name 2")),
                        ),
                      ),
                    ],
                  ),
                  const MyRadioField(
                    sharedPreferencesKey:
                        'odometerType', // Unique key for this radio field

                    // validator: (v) {
                    //   if (v == null) return "Can't be empty";
                    //   return null;
                    // },
                    label: "Odometer Type",
                    fields: ["KM", "MILES"],
                  ),

                  TextFormField(
                    controller: formController.totalDurationController,
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: formController.startDisController,

                          validator: (v) {
                            if (v == null || v.isEmpty) return "Can't be empty";
                            return null;
                          },
                          onChanged: _onDisChange,
                          // controller: startDisController,
                          decoration: const InputDecoration(
                            label: Text("Starting Distance"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller:
                              formController.endDisController, // Add this line

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
                      "Total Distance ${distance < 0 ? "Invalid" : distance}",
                      style: Theme.of(context).textTheme.bodyLarge,
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
                          formController:
                              formController, // Pass the formController
                        ),
                      )
                      .toList()),
                  if (!screenShotMode)
                    TextButton.icon(
                      onPressed: onAddTrailerDetails,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text("Add Trailer Details"),
                    ),
                  TextFormField(
                    controller:
                        formController.extraCommentController, // Add this line
                    key: const ValueKey("extra-comment-tf"),
                    decoration: const InputDecoration(
                      label: Text("Extra Comment"),
                    ),
                  ),
                  TextFormField(
                    controller:
                        formController.expenseNoteController, // Add this line
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
                            isDeleteable: key != 0,
                            onDelete: deleteFuelDetail,
                            ind: key,
                            screenShotMode: screenShotMode,
                            formController:
                                formController, // Pass the formController
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

class FuelLocationDetails extends StatelessWidget {
  FuelLocationDetails({
    super.key,
    required this.isDeleteable,
    this.onDelete,
    required this.ind,
    required this.screenShotMode,
    required this.formController,
  });

  final bool isDeleteable;
  final void Function(int ind)? onDelete;
  final int ind;
  final bool screenShotMode;
  final FormController formController;

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
                      formController.fuelDateController, // Add this line
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
                  controller:
                      formController.locationController, // Add this line
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
            // validator: (v) {
            //   if (v == null) return "Select One";
            //   return null;
            // },
            label: "Quantity Type",
            fields: ["Gallon", "Litre"],
            sharedPreferencesKey:
                'QuantityType', // Unique key for this radio field
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller:
                      formController.quantityController, // Add this line
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
                  controller: formController.amountController, // Add this line
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
          if (isDeleteable && !screenShotMode)
            IconButton(
              onPressed: () => onDelete?.call(ind),
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
    required this.formController,
  });

  final bool isDeleteable;
  final void Function(int ind)? onDelete;
  final int ind;
  final bool screenShotMode;
  // final FormController formController = FormController();
  final FormController formController;

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
                  controller: widget
                      .formController.trailerNumberController, // Add this line
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Trailer Number"),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget
                      .formController.companyNameController, // Add this line
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Company Name"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller:
                      widget.formController.cityNameController, // Add this line
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("City Name"),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller:
                      widget.formController.provinceController, // Add this line
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Can't be empty";
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Province"),
                  ),
                ),
              ),
            ],
          ),
          const MyRadioField(
            // validator: (v) {
            //   if (v == null) return "Select One";
            //   return null;
            // },
            sharedPreferencesKey: 'Picturetaken',

            label: "Picture taken",
            fields: ["Yes", "No"],
          ),
          TextFormField(
            controller: widget
                .formController.reeferTemperatureController, // Add this line
            validator: (v) {
              if (v == null || v.isEmpty) return "Can't be empty";
              return null;
            },
            decoration: const InputDecoration(
              label: Text("Reefer Temperature"),
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
                  value: widget.formController.selectedEventtype,
                  onChanged: (value) {
                    setState(() {
                      widget.formController.selectedEventtype = value!;
                    });
                  },
                  validator: (v) {
                    if (v == null) {
                      return "Please select a trailer type";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(value: "Pickup", child: Text("Pickup")),
                    DropdownMenuItem(value: "Hook", child: Text("Hook")),
                    DropdownMenuItem(value: "Deliver", child: Text("Deliver")),
                    DropdownMenuItem(value: "Drop", child: Text("Drop")),
                    DropdownMenuItem(value: "Switch", child: Text("Switch")),
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
