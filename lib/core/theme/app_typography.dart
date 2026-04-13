import 'package:flutter/material.dart';

class AppTypography {
  // ─── Font Sizes ────────────────────────────────────────────────────────────
  static const double sizeDisplayLarge = 34.0;
  static const double sizeDisplayMedium = 28.0;
  static const double sizeDisplaySmall = 24.0;
  static const double sizeHeadlineMedium = 72.0;
  static const double sizeHeadlineSmall = 48.0;
  static const double sizeTitleLarge = 22.0;
  static const double sizeTitleMedium = 17.0;
  static const double sizeTitleSmall = 15.0;
  static const double sizeBodyLarge = 17.0;
  static const double sizeBodyMedium = 15.0;
  static const double sizeBodySmall = 13.0;
  static const double sizeLabelLarge = 15.0;
  static const double sizeLabelMedium = 13.0;
  static const double sizeLabelSmall = 12.0;

  // ─── Text Theme Factory ─────────────────────────────────────────────────────
  static TextTheme buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: sizeDisplayLarge,
        fontWeight: FontWeight.w900,
        letterSpacing: -1,
        color: primary,
      ),
      displayMedium: TextStyle(
        fontSize: sizeDisplayMedium,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: primary,
      ),
      displaySmall: TextStyle(
        fontSize: sizeDisplaySmall,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      // Big counter number
      headlineMedium: TextStyle(
        fontSize: sizeHeadlineMedium,
        fontWeight: FontWeight.w900,
        letterSpacing: -2,
        color: primary,
      ),
      headlineSmall: TextStyle(
        fontSize: sizeHeadlineSmall,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: sizeTitleLarge,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: sizeTitleMedium,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontSize: sizeTitleSmall,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: sizeBodyLarge,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: sizeBodyMedium,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: TextStyle(
        fontSize: sizeBodySmall,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: sizeLabelLarge,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: sizeLabelMedium,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
      // Section headers (ALL-CAPS small label above card groups)
      labelSmall: TextStyle(
        fontSize: sizeLabelSmall,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: secondary,
      ),
    );
  }

  // Helper for AppBar titles
  static TextStyle appBarTitle(Color color) => TextStyle(
    fontSize: sizeTitleMedium,
    fontWeight: FontWeight.w600,
    color: color,
    letterSpacing: -0.2,
  );
}
