import 'package:dmtransport/api/api.dart';
import 'package:dmtransport/external/shared_prefs_names.dart';
import 'package:dmtransport/pages/fetching_data.dart';
import 'package:dmtransport/pages/login_page/login_page.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String route = "splash_page";

  void _freshLogin(BuildContext context, SharedPreferences prefs) {
    prefs.clear();
    Navigator.of(context).popAndPushNamed(LoginPage.id);
  }

  void makeChecks(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      var token = prefs.getString(SharedPrefsNames.loginToken) ?? "";
      if (token == "") {
        _freshLogin(context, prefs);
        return;
      }
      Api.isLoginTokenValid(token).then((user) {
        if (user == null) {
          _freshLogin(context, prefs);
          return;
        }
        var appState = Provider.of<AppStateNotifier>(context, listen: false);
        appState.setLoginToken(token);
        appState.setUser(user);
        Navigator.of(context).popAndPushNamed(FetchingData.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (TickerMode.of(context)) {
      Future.delayed(Duration.zero, () {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
          ),
        );
        makeChecks(context);
      });
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            MAssets.image(MAssetImage.icon),
            width: 140,
            height: 140,
          ),
          const SizedBox(
            height: 16,
            width: double.infinity,
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
