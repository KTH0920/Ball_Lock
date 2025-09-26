import 'package:flutter/material.dart';

class AppTheme {
  // 라이트 테마
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF11AB69),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF11AB69),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  // 다크 테마
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF11AB69),
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF11AB69),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}
