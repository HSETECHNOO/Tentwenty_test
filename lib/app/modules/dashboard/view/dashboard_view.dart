import 'package:flutter/material.dart';
import 'package:tentwenty_test/app/modules/dashboard/widgets/custom_navbar.dart';
import 'package:tentwenty_test/app/modules/home/view/home.dart';

class DashboardViewPage extends StatelessWidget {
  const DashboardViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: HomeView(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
