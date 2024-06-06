import 'package:dmtransport/external/fb_messaging.dart';
import 'package:dmtransport/pages/home_page/pages/about_page/about_page.dart';
import 'package:dmtransport/pages/home_page/pages/about_page/notifications_page.dart';
import 'package:dmtransport/pages/home_page/pages/documents_page/widgets/view_document.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/messages_page_router.dart';
import 'package:dmtransport/pages/home_page/pages/messages_page/pages/contacts_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/dashboard_home_page.dart';
import 'package:dmtransport/pages/home_page/pages/documents_page/documents_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/dashboard/dashboard_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  static const String id = "home_page_id";
  static Map<String, Widget Function(BuildContext)> getChildRoutes() {
    var routes = DashboardRouter.routes;
    routes.addAll(MessagesPageRouter.routes);
    routes.addAll({
      ViewDocument.route: (context) => const ViewDocument(),
      NotificationsPage.route: (context) => const NotificationsPage(),
    });
    return routes;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedNavPageInd = 0;

  Widget? appBarTitle;

  final List<Widget> _pages = const [
    DashboardHomePage(),
    DocumentsPage(),
    ContactsPage(),
    AboutPage()
  ];

  final PageController _pageController = PageController();

  void onNavPageIndChange(int value) {
    setState(() {
      _pageController.animateToPage(
        value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceOut,
      );
      selectedNavPageInd = value;
    });
  }

  @override
  void initState() {
    FbMessaging.requestPermission();
    FbMessaging.registerCallbacks(context);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (TickerMode.of(context)) {
      Future.delayed(Duration.zero, () {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            systemNavigationBarColor: Color.fromARGB(255, 232, 244, 236),
          ),
        );
      });
    }
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => onNavPageIndChange(value),
        selectedIndex: selectedNavPageInd,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.file_present_outlined),
            selectedIcon: Icon(Icons.file_present_rounded),
            label: "Documents",
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat_rounded),
            label: "Chat",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle_rounded),
            label: "Account",
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            selectedNavPageInd = value;
          });
        },
        children: _pages,
      ),
    );
  }
}
