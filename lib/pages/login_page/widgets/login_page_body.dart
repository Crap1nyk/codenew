// import 'dart:developer';

import 'package:dmtransport/api/api.dart';
import 'package:dmtransport/external/shared_prefs_names.dart';
import 'package:dmtransport/pages/fetching_data.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String isoCode = "IN";

  bool loading = false;

  String errorMessage = "";

  void onPhoneNumberChanged(PhoneNumber data) {
    if (isoCode == data.isoCode) return;

    setState(() {
      isoCode = data.isoCode ?? "IN";
    });
  }

  void onLoginPressed(BuildContext context) {
    setState(() {
      loading = true;
      errorMessage = "";
    });
    //goes ahead only if phone number is valid
    if (phoneNumberController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        loading = false;
        errorMessage = passwordController.text.isEmpty
            ? 'Please enter your password.'
            : 'Please enter your phone number.';
      });
      return;
    }
    var phone = sanitizePhoneNumber(phoneNumberController.text);
    // log('Pass: ${passwordController.text} Phone:$phone');
    Api.login(phone, passwordController.text).then((res) {
      if (res == null) return;

      // save the login token
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(SharedPrefsNames.loginToken, res.loginToken);
      });

      // update the app state
      var appState = Provider.of<AppStateNotifier>(context, listen: false);
      appState.setLoginToken(res.loginToken);
      appState.setUser(res.user);

      // navigate to home page
      Navigator.of(context).popAndPushNamed(FetchingData.id);
    }).catchError((err) {
      debugPrint("error while logging in: $err");
      setState(() {
        errorMessage = err.toString();
        loading = false;
      });
    });
  }

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 32.0,
            ),
            // Welcome Back Heading
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                Text(
                  "Welcome back",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  "Login into your account",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(
              height: 64.0,
            ),
            // Text Boxes
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200]!.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              child: InternationalPhoneNumberInput(
                onInputChanged: onPhoneNumberChanged,
                initialValue: PhoneNumber(isoCode: "IN"),
                textFieldController: phoneNumberController,
                countries: const ["US", "IN", "CA"],
                inputDecoration: const InputDecoration(
                  hintText: 'Phone Number',
                  border: InputBorder.none,
                ),
                textStyle: const TextStyle(color: Colors.white),
                selectorTextStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                hintText: 'Password',
                fillColor: Colors.grey[200]!.withOpacity(0.3),
                focusColor: Colors.grey[200]!.withOpacity(0.3),
                contentPadding: const EdgeInsets.only(left: 20.0),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Container(
              padding: EdgeInsets.zero,
              height: 48.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.1, 0.5, 0.9],
                  colors: [
                    Colors.blue[300]!.withOpacity(0.8),
                    Colors.blue[500]!.withOpacity(0.8),
                    Colors.blue[800]!.withOpacity(0.8),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: !loading ? () => onLoginPressed(context) : null,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  fixedSize: Size(
                    MediaQuery.of(context).size.width - 32,
                    48.0,
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ),
                child: loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text("Submit"),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              errorMessage,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
