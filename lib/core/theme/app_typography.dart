import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // ─── Font Sizes ────────────────────────────────────────────────────────────
  static const double sizeDisplayLarge = 34.0;
  static const double sizeDisplayMedium = 28.0;
  static const double sizeDisplaySmall = 24.0;
  static const double sizeHeadlineMedium = 80.0;
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
      displayLarge: GoogleFonts.outfit(
        fontSize: sizeDisplayLarge,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        color: primary,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: sizeDisplayMedium,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: primary,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: sizeDisplaySmall,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: primary,
      ),
      // Big counter number
      headlineMedium: GoogleFonts.outfit(
        fontSize: sizeHeadlineMedium,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.0,
        color: primary,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: sizeHeadlineSmall,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        color: primary,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: sizeTitleLarge,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: primary,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: sizeTitleMedium,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: primary,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: sizeTitleSmall,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primary,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: sizeBodyLarge,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: sizeBodyMedium,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: sizeBodySmall,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: sizeLabelLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: primary,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: sizeLabelMedium,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: secondary,
      ),
      // Section headers (ALL-CAPS small label above card groups)
      labelSmall: GoogleFonts.outfit(
        fontSize: sizeLabelSmall,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: secondary,
      ),
    );
  }

  // Helper for AppBar titles
  static TextStyle appBarTitle(Color color) => GoogleFonts.outfit(
    fontSize: sizeTitleMedium,
    fontWeight: FontWeight.w700,
    color: color,
    letterSpacing: 0.5,
  );
}
