import 'package:dmtransport/external/pdf.handle.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/pdf_preview_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope/ctpatformcontroller.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard_router.dart';

class CtpatPage extends StatefulWidget {
  const CtpatPage({super.key});

  static const String route = "${DashboardRouter.baseRoute}/ctpat_form";

  @override
  State<CtpatPage> createState() => _CtpatPageState();
}

class _CtpatPageState extends State<CtpatPage> {
  late CtpatFormController ctpatformcontroller;

  @override
  void initState() {
    ctpatformcontroller = CtpatFormController();

    ctpatFormloadData();
    super.initState();
  }

  void ctpatFormloadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ctpatformcontroller.tripOrderNoController.text =
          prefs.getString('2tripOrderNo') ?? '';
      ctpatformcontroller.trailerLoadingPointController.text =
          prefs.getString('2trailerLoadingPoint') ?? '';
      ctpatformcontroller.addressController.text =
          prefs.getString('2address') ?? '';
      ctpatformcontroller.billNumberController.text =
          prefs.getString('2billNumber') ?? '';
      ctpatformcontroller.trailerIdController.text =
          prefs.getString('2trailerId') ?? '';
      ctpatformcontroller.sealNumberOneController.text =
          prefs.getString('2sealNumberOne') ?? '';
      ctpatformcontroller.sealNumberTwoController.text =
          prefs.getString('2sealNumberTwo') ?? '';
      ctpatformcontroller.sealRemovedController.text =
          prefs.getString('2sealRemoved') ?? '';
      ctpatformcontroller.commentsController.text =
          prefs.getString('2comments') ?? '';
      ctpatformcontroller.selectedlocationType =
          prefs.getString('2selectedLocationType') ?? 'Shipper';
      ctpatformcontroller.selectedagree =
          prefs.getString('2selectedAgree') ?? 'false';
    });
  }

  void onCtpatFormsave() async {
    ctpatformcontroller.CtpatFormsave(CtpatFormData(
        tripOrderNo: ctpatformcontroller.tripOrderNoController.text,
        trailerLoadingPoint:
            ctpatformcontroller.trailerLoadingPointController.text,
        address: ctpatformcontroller.addressController.text,
        billNumber: ctpatformcontroller.billNumberController.text,
        trailerId: ctpatformcontroller.trailerIdController.text,
        sealNumberOne: ctpatformcontroller.sealNumberOneController.text,
        sealNumberTwo: ctpatformcontroller.sealNumberTwoController.text,
        sealRemoved: ctpatformcontroller.sealRemovedController.text,
        comments: ctpatformcontroller.commentsController.text,
        selectedLocationType: ctpatformcontroller.selectedlocationType,
        selectedAgree: ctpatformcontroller.selectedagree));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form data saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CTPAT Form'),
        actions: [
          TextButton.icon(
            onPressed: () {
              onCtpatFormsave();
            },
            icon: const Icon(Icons.save),
            label: const Text("Save"),
          ),
        ],
      ),
      body: CtpatForm(
        ctpatformcontroller: ctpatformcontroller,
      ),
    );
  }
}

class CtpatForm extends StatefulWidget {
  const CtpatForm({
    super.key,
    required this.ctpatformcontroller,
  });
  final CtpatFormController ctpatformcontroller;

  @override
  State<CtpatForm> createState() => _CtpatFormState();
}

class _CtpatFormState extends State<CtpatForm> {
  final _formKey = GlobalKey<FormState>();

  void onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );

    screenshotController.capture().then((value) {
      PdfHandle.rawImagesToPdf([value!]).then(
        (file) => Navigator.of(context).pushNamed(
          PdfPreviewPage.route,
          arguments: PdfPreviewPageArgs(
            file: file,
            docType: "CTPAT",
          ),
        ),
      );
    });
  }

  late ScreenshotController screenshotController;

  @override
  void initState() {
    screenshotController = ScreenshotController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Screenshot(
        controller: screenshotController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YesNoRadioField(
                  sharedPreferencesKey: 'radioInspection',
                  label: "Inspection Complete",
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget.ctpatformcontroller.tripOrderNoController,
                  decoration: const InputDecoration(
                    labelText: 'Trip No or Order No',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Inspection Completed By",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller:
                      widget.ctpatformcontroller.trailerLoadingPointController,
                  decoration: const InputDecoration(
                    labelText: 'Trailer Loading Point',
                  ),
                ),
                TextFormField(
                  controller: widget.ctpatformcontroller.addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),
                TextFormField(
                  controller: widget.ctpatformcontroller.billNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Bill of Lading Number',
                  ),
                ),
                TextFormField(
                  controller: widget.ctpatformcontroller.trailerIdController,
                  decoration: const InputDecoration(
                    labelText: 'Trailer Id',
                  ),
                ),
                // ...textFields
                //     .getRange(0, 4)
                //     .map(
                //       (e) => TextFormField(
                //                         controller: widget.ctpatformcontroller.tripOrderNoController,

                //         decoration: InputDecoration(
                //           labelText: e,
                //         ),
                //       ),
                //     )
                //     .toList(),
                const SizedBox(
                  height: 8,
                ),
                YesNoRadioField(
                  sharedPreferencesKey: 'radiosealnumber',
                  label: "Viewd Trailer Loading",
                ),
                const SizedBox(
                  height: 8,
                ),
                YesNoRadioField(
                  sharedPreferencesKey: 'radiobillload',
                  label: "BOL Load and Piece Count Verified",
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller:
                      widget.ctpatformcontroller.sealNumberOneController,
                  decoration: const InputDecoration(
                    labelText: 'Seal Number One',
                  ),
                ),
                TextFormField(
                  controller:
                      widget.ctpatformcontroller.sealNumberTwoController,
                  decoration: const InputDecoration(
                    labelText: 'Seal Number Two',
                  ),
                ),
                // ...textFields
                // .getRange(4, 6)
                // .map(
                //   (e) => TextFormField(
                //     decoration: InputDecoration(
                //       labelText: e,
                //     ),
                //   ),
                // )
                // .toList(),
                const SizedBox(
                  height: 8,
                ),
                YesNoRadioField(
                  sharedPreferencesKey: 'radiosealintact',
                  label: "Seal Intact",
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget.ctpatformcontroller.sealRemovedController,
                  decoration: const InputDecoration(
                    labelText: 'Seal Removed In Transit By',
                  ),
                ),

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: textFields[6],
                //   ),
                // ),
                const SizedBox(
                  height: 8,
                ),
                YesNoRadioField(
                  sharedPreferencesKey: 'radiosealnumber',
                  label: "Seal Number and Location Same as BOL",
                ),
                const SizedBox(
                  height: 8,
                ),
                YesNoRadioField(
                  sharedPreferencesKey: 'radiosealchange',
                  label: "Seal Change Reported to Dispatch",
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget.ctpatformcontroller.commentsController,
                  decoration: const InputDecoration(
                    labelText: 'Comments',
                  ),
                ),

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: textFields[7],
                //   ),
                // ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Location Type"),
                    SizedBox(
                      width: 55,
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.ctpatformcontroller.selectedlocationType,
                        onChanged: (value) {
                          setState(() {
                            widget.ctpatformcontroller.selectedlocationType =
                                value!;
                          });
                        },
                        validator: (v) {
                          if (v == null) {
                            return "Select One";
                          }
                          return null;
                        },
                        items: const [
                          DropdownMenuItem(
                              value: "Shipper", child: Text("Shipper")),
                          DropdownMenuItem(
                              value: "Consignee", child: Text("Consignee")),
                          DropdownMenuItem(
                              value: "Border", child: Text("Border")),
                          DropdownMenuItem(
                              value: "Other", child: Text("Other")),
                        ],
                        // onChanged: (String? value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxFormField(
                  ctpatformcontroller:
                      widget.ctpatformcontroller, // Add this line

                  title: const Text(
                    "I agree that I have inspected the equipment(s) in accordance with the applicable regulation(s)",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                OutlinedButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.done_rounded),
                  label: const Text("Sumbit"),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<String> textFields = [
  "Trailer Loading Point",
  "Address",
  "Bill of Lading Number",
  "Trailer Id",
  "Seal Number One",
  "Seal Number Two",
  "Seal Removed In Transit By",
  "Comments",
];

class TimePicker extends StatelessWidget {
  const TimePicker({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Select Time'),
        ),
      ],
    );
  }
}

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Select Date')),
      ],
    );
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    Widget? title,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    bool autovalidate = false,
    required CtpatFormController ctpatformcontroller, // Add this line
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              dense: true,
              title: title,
              value: ctpatformcontroller.selectedagree ==
                  'true', // Update this line
              onChanged: (bool? value) {
                state.didChange(value);
                ctpatformcontroller.selectedagree = value.toString();
              },
              subtitle: state.hasError
                  ? Builder(
                      builder: (BuildContext context) => Text(
                        state.errorText ?? "",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    )
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        );
}

class YesNoRadioField extends StatefulWidget {
  final String label;
  final String sharedPreferencesKey;

  const YesNoRadioField({
    Key? key,
    required this.label,
    required this.sharedPreferencesKey,
  }) : super(key: key);

  @override
  _YesNoRadioFieldState createState() => _YesNoRadioFieldState();
}

class _YesNoRadioFieldState extends State<YesNoRadioField> {
  late bool _value = true;
  @override
  void initState() {
    super.initState();
    _loadValueFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget.label,
              softWrap: true,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: RadioListTile<bool>.adaptive(
              contentPadding: EdgeInsets.zero,
              value: true,
              dense: true,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value!;
                  _saveValueToSharedPreferences(_value);
                });
              },
              title: const Text("Yes"),
            ),
          ),
          Expanded(
            child: RadioListTile<bool>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: false,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value!;
                  _saveValueToSharedPreferences(_value);
                });
              },
              title: const Text("No"),
            ),
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
