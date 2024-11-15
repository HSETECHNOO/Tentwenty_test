// core/routes.dart
import 'package:flutter/material.dart';
import 'package:tentwenty_test/app/modules/dashboard/view/dashboard_view.dart';
import 'package:tentwenty_test/app/modules/home/view/home.dart';
import 'package:tentwenty_test/app/routes/app_routes.dart';

class RoutesManage {
  static const String initialRoute = Routes.DASHBOARD;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.HOME_OVERVIEW:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.DASHBOARD:
        return MaterialPageRoute(builder: (_) => const DashboardViewPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('404 - Page Not Found'),
              leading: Container(),
            ),
            body: const Center(child: Text('404 - Page Not Found')),
          ),
        );
    }
  }
}
