import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // ─── Font Families ────────────────────────────────────────────────────────
  static String get englishFont => GoogleFonts.outfit().fontFamily!;
  static String get arabicFont => GoogleFonts.amiri().fontFamily!;

  // ─── Font Sizes ────────────────────────────────────────────────────────────
  static const double sizeDisplayLarge = 36.0;
  static const double sizeDisplayMedium = 30.0;
  static const double sizeDisplaySmall = 24.0;

  static const double sizeHeadlineLarge = 32.0;
  static const double sizeHeadlineMedium = 28.0;
  static const double sizeHeadlineSmall = 24.0;

  static const double sizeTitleLarge = 20.0;
  static const double sizeTitleMedium = 16.0;
  static const double sizeTitleSmall = 14.0;

  static const double sizeBodyLarge = 16.0;
  static const double sizeBodyMedium = 14.0;
  static const double sizeBodySmall = 12.0;

  static const double sizeLabelLarge = 14.0;
  static const double sizeLabelMedium = 12.0;
  static const double sizeLabelSmall = 11.0;

  // ─── Text Theme Factory ─────────────────────────────────────────────────────
  static TextTheme buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      // DISPLAY: Large, expressive headers
      displayLarge: GoogleFonts.outfit(
        fontSize: sizeDisplayLarge,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        color: primary,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: sizeDisplayMedium,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: primary,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: sizeDisplaySmall,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: primary,
      ),

      // HEADLINE: Page titles and prominent sections
      headlineLarge: GoogleFonts.outfit(
        fontSize: sizeHeadlineLarge,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: primary,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: sizeHeadlineMedium,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: primary,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: sizeHeadlineSmall,
        fontWeight: FontWeight.w600,
        color: primary,
      ),

      // TITLE: UI components, card titles
      titleLarge: GoogleFonts.outfit(
        fontSize: sizeTitleLarge,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: sizeTitleMedium,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: sizeTitleSmall,
        fontWeight: FontWeight.w600,
        color: primary,
      ),

      // BODY: Main content, translations
      bodyLarge: GoogleFonts.outfit(
        fontSize: sizeBodyLarge,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primary,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: sizeBodyMedium,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primary,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: sizeBodySmall,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: secondary,
      ),

      // LABEL: Small metadata, buttons, section headers
      labelLarge: GoogleFonts.outfit(
        fontSize: sizeLabelLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: primary,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: sizeLabelMedium,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: secondary,
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: sizeLabelSmall,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: secondary,
      ),
    );
  }

  // ─── Arabic Specific Styles ───────────────────────────────────────────────

  static TextStyle arabicDisplay(Color color) => GoogleFonts.amiri(
    fontSize: 36,
    fontWeight: FontWeight.w300,
    height: 1.2,
    color: color,
  );

  static TextStyle arabicTitle(Color color) => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    height: 1.3,
    color: color,
  );

  static TextStyle arabicBody(Color color) => GoogleFonts.amiri(
    fontSize: 20,
    fontWeight: FontWeight.w200,
    height: 1.5,
    color: color,
  );

  static TextStyle arabicLabel(Color color) => GoogleFonts.amiri(
    fontSize: 16,
    fontWeight: FontWeight.w200,
    color: color,
  );

  // Helper for AppBar titles
  static TextStyle appBarTitle(Color color) => GoogleFonts.outfit(
    fontSize: 17,
    fontWeight: FontWeight.w300,
    color: color,
    letterSpacing: 0.2,
  );
}
