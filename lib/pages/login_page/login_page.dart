import 'package:dmtransport/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/login_page_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String id = "login_page_id";

  @override
  Widget build(BuildContext context) {
    // log(MediaQuery.of(context).viewInsets.bottom.toString());
    // log(MediaQuery.of(context).size.height.toString());
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
      ),
    );
    return Scaffold(
      //prevents background image from shrinking
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  MAssets.image(MAssetImage.truck),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(1.0),
                ],
              ),
            ),
            child: const Body(),
          ),
        ],
      ),
    );
  }
}
