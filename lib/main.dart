import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tentwenty_test/app/commons/global_errorwidget.dart';
import 'package:tentwenty_test/app/core/services/service_locator.dart';
import 'package:tentwenty_test/app/core/theme/app_theme.dart';
import 'package:tentwenty_test/app/core/utils/logger.dart';
import 'package:tentwenty_test/app/core/utils/provider_base.dart';
import 'package:tentwenty_test/app/modules/dashboard/view/dashboard_view.dart';
import 'package:tentwenty_test/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(details.toString());
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('Async error: $error');
    return true;
  };

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return GlobalErrorWidget(errorDetails: errorDetails);
  };
  await _initializeApp();
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  setupServiceLocator();
  AppLogger.info('initialized');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TwentyTestApp(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TenTwenty Movie App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const DashboardViewPage(),
        onGenerateRoute: RoutesManage.onGenerateRoute,
        builder: (context, child) {
          return Scaffold(body: child);
        },
      ),
    );
  }
}
