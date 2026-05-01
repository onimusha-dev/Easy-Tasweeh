import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // ─── Font Families ────────────────────────────────────────────────────────
  static String get englishFont => GoogleFonts.outfit().fontFamily!;
  static String get arabicFont => GoogleFonts.amiri().fontFamily!;

  // ─── Font Weights ──────────────────────────────────────────────────────────
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;
  static const FontWeight weightBlack = FontWeight.w900;

  // ─── Font Sizes ────────────────────────────────────────────────────────────
  static const double sizeDisplayLarge = 36.0;
  static const double sizeDisplayMedium = 30.0;
  static const double sizeDisplaySmall = 24.0;

  static const double sizeHeadlineLarge = 32.0;
  static const double sizeHeadlineMedium = 28.0;
  static const double sizeHeadlineSmall = 24.0;

  static const double sizeTitleLarge = 20.0;
  static const double sizeTitleMedium = 17.0;
  static const double sizeTitleSmall = 15.0;

  static const double sizeBodyLarge = 16.0;
  static const double sizeBodyMedium = 14.0;
  static const double sizeBodySmall = 12.0;

  static const double sizeLabelLarge = 14.0;
  static const double sizeLabelMedium = 12.0;
  static const double sizeLabelSmall = 10.0;

  // ─── Text Theme Factory ─────────────────────────────────────────────────────
  static TextTheme buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      // DISPLAY: Large, expressive headers
      displayLarge: GoogleFonts.outfit(
        fontSize: sizeDisplayLarge,
        fontWeight: weightSemiBold,
        letterSpacing: -1.0,
        color: primary,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: sizeDisplayMedium,
        fontWeight: weightMedium,
        letterSpacing: -0.8,
        color: primary,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: sizeDisplaySmall,
        fontWeight: weightMedium,
        letterSpacing: -0.5,
        color: primary,
      ),

      // HEADLINE: Page titles and prominent sections
      headlineLarge: GoogleFonts.outfit(
        fontSize: sizeHeadlineLarge,
        fontWeight: weightMedium,
        letterSpacing: -0.5,
        color: primary,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: sizeHeadlineMedium,
        fontWeight: weightMedium,
        letterSpacing: -0.2,
        color: primary,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: sizeHeadlineSmall,
        fontWeight: weightRegular,
        color: primary,
      ),

      // TITLE: UI components, card titles
      titleLarge: GoogleFonts.outfit(
        fontSize: sizeTitleLarge,
        fontWeight: weightBold,
        color: primary,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: sizeTitleMedium,
        fontWeight: weightBold,
        color: primary,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: sizeTitleSmall,
        fontWeight: weightBold,
        color: primary,
      ),

      // BODY: Main content, translations
      bodyLarge: GoogleFonts.outfit(
        fontSize: sizeBodyLarge,
        fontWeight: weightRegular,
        height: 1.5,
        color: primary,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: sizeBodyMedium,
        fontWeight: weightRegular,
        height: 1.5,
        color: primary,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: sizeBodySmall,
        fontWeight: weightMedium,
        height: 1.4,
        color: secondary,
      ),

      // LABEL: Small metadata, buttons, section headers
      labelLarge: GoogleFonts.outfit(
        fontSize: sizeLabelLarge,
        fontWeight: weightMedium,
        letterSpacing: 0.2,
        color: primary,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: sizeLabelMedium,
        fontWeight: weightMedium,
        letterSpacing: 0.5,
        color: secondary,
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: sizeLabelSmall,
        fontWeight: weightBlack,
        letterSpacing: 1.2,
        color: secondary,
      ),
    );
  }

  // ─── Arabic Specific Styles ───────────────────────────────────────────────

  static TextStyle arabicDisplay(Color color) => GoogleFonts.amiri(
    fontSize: 36,
    fontWeight: weightRegular,
    height: 1.2,
    color: color,
  );

  static TextStyle arabicTitle(Color color) => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: weightRegular,
    height: 1.3,
    color: color,
  );

  static TextStyle arabicBody(Color color) => GoogleFonts.amiri(
    fontSize: 20,
    fontWeight: weightRegular,
    height: 1.5,
    color: color,
  );

  static TextStyle arabicLabel(Color color) => GoogleFonts.amiri(
    fontSize: 16,
    fontWeight: weightRegular,
    color: color,
  );

  // Helper for AppBar titles
  static TextStyle appBarTitle(Color color) => GoogleFonts.outfit(
    fontSize: 17,
    fontWeight: weightSemiBold,
    color: color,
    letterSpacing: -0.2,
  );
}
