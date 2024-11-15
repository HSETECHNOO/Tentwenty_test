import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true);

  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(primary: Colors.deepPurple),
    useMaterial3: true,
  );
}
