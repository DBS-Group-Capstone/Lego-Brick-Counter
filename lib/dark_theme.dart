import 'package:flutter/material.dart';

class AppDarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,

      colorScheme: ColorScheme.dark(
        primary: const Color.fromARGB(255, 13, 207, 255),
        secondary: Colors.tealAccent,
        surface: const Color(0xFF121212),
      ),

      scaffoldBackgroundColor: const Color(0xFF121212),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 13, 207, 255),
        foregroundColor: Colors.white,
      ),

      cardColor: const Color(0xFF1E1E1E),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 13, 207, 255),
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}