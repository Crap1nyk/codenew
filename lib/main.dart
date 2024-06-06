import 'package:dmtransport/pages/fetching_data.dart';
import 'package:dmtransport/pages/home_page/home_page.dart';
import 'package:dmtransport/pages/login_page/login_page.dart';
import 'package:dmtransport/pages/splash_page/splash_page.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/states/chat.state.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Map<String, Widget Function(BuildContext)> _routes = {
    SplashPage.route: (context) => const SplashPage(),
    HomePage.id: (context) => const HomePage(),
    LoginPage.id: (context) => const LoginPage(),
    FetchingData.id: (context) => const FetchingData(),
    ...HomePage.getChildRoutes(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateNotifier()),
        ChangeNotifierProvider(create: (_) => ChatStateNotifier())
      ],
      child: InAppNotification(
        child: MaterialApp(
          title: 'DM Transport',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          ),
          darkTheme: ThemeData.dark().copyWith(),
          themeMode: ThemeMode.light,
          routes: _routes,
          initialRoute: SplashPage.route,
        ),
      ),
    );
  }
}
