import 'package:dmtransport/api/api.dart';
import 'package:dmtransport/external/shared_prefs_names.dart';
import 'package:dmtransport/pages/home_page/home_page.dart';
import 'package:dmtransport/pages/home_page/pages/about_page/notifications_page.dart';
import 'package:dmtransport/pages/login_page/login_page.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/assets.dart';
import 'package:dmtransport/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CardItem {
  final String title;
  final IconData icon;
  final void Function()? onPress;

  CardItem(this.title, this.icon, this.onPress);
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const List<String> tileNames = [
    "About App",
    "About DM Transport",
    "Notifications",
    "Call Us",
    "Help",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: AccountInfo(),
            ),
            SizedBox(
              height: 16,
            ),
            MCard()
          ],
        ),
      ),
    );
  }
}

class MCard extends StatefulWidget {
  const MCard({
    super.key,
  });

  @override
  State<MCard> createState() => _MCardState();
}

class _MCardState extends State<MCard> {
  void onLogoutPressed(String bearer) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: false,
        enableDrag: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    SharedPreferences.getInstance().then((prefs) {
      Api.logout(bearer).then((v) {
        prefs.remove(SharedPrefsNames.loginToken);
        var snackBar = const SnackBar(
          content: Text(
            'Successfully Logged Out',
            style: TextStyle(color: Colors.green),
          ),
        );

        SharedPreferences.getInstance().then((prefs) {
          prefs.remove(SharedPrefsNames.loginToken);
          prefs.remove(SharedPrefsNames.fcmToken);

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).popUntil(
            ModalRoute.withName(HomePage.id),
          );
          Navigator.popAndPushNamed(context, LoginPage.id);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<CardItem> cardItems = [
      CardItem("About App", Icons.info_rounded, () {
        PackageInfo.fromPlatform().then((packageInfo) {
          String version = packageInfo.version;
          String buildNumber = packageInfo.buildNumber;
          showAboutDialog(
              context: context,
              applicationIcon: Image.asset(
                MAssets.image(MAssetImage.icon),
                height: 38,
              ),
              applicationVersion: version,
              children: [
                Row(
                  children: [
                    Text(
                      "Build Number",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(buildNumber),
                  ],
                ),
              ]);
        });
      }),
      CardItem("Notifications", Icons.notifications_rounded, () {
        Navigator.of(context).pushNamed(NotificationsPage.route);
      }),
      CardItem("Call Us", Icons.call_rounded, () {
        launchUrl(Uri.parse("tel:+18448203434"));
      }),
      CardItem("Help", Icons.help_rounded, () {
        final Uri params = Uri(
          scheme: 'mailto',
          path: 'custom@dmtransport.ca',
          query: 'subject=Any Query&body=Hello Sir', //add subject and body here
        );
        launchUrl(params).catchError((err) {
          debugPrint("failed to launch uri to send email\n\t$err");
          return false;
        });
      }),
    ];
    var appState = Provider.of<AppStateNotifier>(context);
    return Card(
      child: Column(
        children: [
          CardItemWidget(
            title: "About DM Transport",
            icon: Image.asset(
              MAssets.image(MAssetImage.icon),
              height: 24,
            ),
            onPress: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const BottomSheetWidget();
                  });
            },
          ),
          ...cardItems
              .map(
                (e) => CardItemWidget(
                  title: e.title,
                  icon: Icon(e.icon),
                  onPress: e.onPress,
                ),
              )
              .toList(),
          const Divider(),
          CardItemWidget(
            title: "Logout",
            icon: const Icon(Icons.logout_rounded),
            onPress: () => onLogoutPressed(appState.loginToken),
          ),
        ],
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "About DM Transport",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            Data.aboutDmTransport,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class CardItemWidget extends StatelessWidget {
  const CardItemWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onPress,
  });

  final String title;
  final Widget icon;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      leading: icon,
    );
  }
}

class AccountInfo extends StatelessWidget {
  const AccountInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateNotifier>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appState.user.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              appState.user.phone,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Image.network(
          appState.user.image,
          width: 50,
          height: 50,
          cacheHeight: 50,
          cacheWidth: 50,
          errorBuilder: (context, error, statckTrace) {
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
