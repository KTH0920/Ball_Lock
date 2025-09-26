import 'package:flutter/material.dart';

class AppTheme {
  // ✅ 라이트 테마
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1E6F6A), // #1E6F6A (청록색)
      secondary: Color(0xFF1E6F6A),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E6F6A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    cardColor: Colors.white,
  );

  // ✅ 다크 테마
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1E6F6A), // ✅ 연두 → 청록으로 교체
      secondary: Color(0xFF1E6F6A),
      surface: Color(0xFF121212),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E6F6A), // ✅ 상단바도 청록
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    cardColor: Color(0xFF1E1E1E), // ✅ 카드 배경도 다크 톤
  );
}
