import 'package:flutter/material.dart';

class AppLightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 13, 207, 255),
      ),
    );
  }
}