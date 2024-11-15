// lib/config/provider_binding.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty_test/app/providers/app_provider/app_base_provider.dart';
import 'package:tentwenty_test/app/providers/booking_provider/booking_provider.dart';
import 'package:tentwenty_test/app/providers/dashboard_provider/dashboard_provider.dart';
import 'package:tentwenty_test/app/providers/home_provider/home_provider.dart';

class TwentyTestApp extends StatelessWidget {
  final Widget child;
  const TwentyTestApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AppBaseProvider()..initializeApp()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ChangeNotifierProvider(
          create: (_) => SeatSelectionProvider(rows: 9, seatsPerRow: 8)),
    ], child: child);
  }
}
