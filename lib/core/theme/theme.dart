import 'package:flutter/material.dart';

class AppTheme {
  // Use a softer, premium Emerald Green palette
  static const Color _primaryColor = Color(0xFF1B5E20);
  static const Color _secondaryColor = Color(0xFF2E7D32);

  static final TextTheme _textTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, letterSpacing: -1.5),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      primary: _primaryColor,
      secondary: _secondaryColor,
      surface: const Color(0xFFF1F5F1),
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w800),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        // fontWeight: FontWeight.bold,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      primary: Color(0xFF81C784),
      secondary: Color(0xFFA5D6A7),
      surface: const Color(0xFF101410),
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        // fontWeight: FontWeight.bold,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
    ),
  );
}
