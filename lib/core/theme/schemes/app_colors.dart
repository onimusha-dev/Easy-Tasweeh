import 'package:flutter/material.dart';

// ─── Custom color extension ──────────────────────────────────────────────────
// Holds semantic colors that Material ColorScheme doesn't cover
class AppColors extends ThemeExtension<AppColors> {
  final Color counterText;
  final Color progressActive;
  final Color progressTrack;
  final Color tapButtonFill;
  final Color tapButtonShadow;
  final Color cardBorder;
  final Color subtleText;
  final Color sectionHeaderBg;
  final Color sectionLabelText;
  final Color iconBgTeal;
  final Color iconBgPurple;
  final Color iconBgAmber;
  final Color iconBgBlue;
  final Color iconBgCoral;
  final Color iconBgPink;
  final Color iconBgGray;
  final Color iconBgGreen;
  final Color toggleActiveTrack;
  final Color destructiveColor;

  const AppColors({
    required this.counterText,
    required this.progressActive,
    required this.progressTrack,
    required this.tapButtonFill,
    required this.tapButtonShadow,
    required this.cardBorder,
    required this.subtleText,
    required this.sectionHeaderBg,
    required this.sectionLabelText,
    required this.iconBgTeal,
    required this.iconBgPurple,
    required this.iconBgAmber,
    required this.iconBgBlue,
    required this.iconBgCoral,
    required this.iconBgPink,
    required this.iconBgGray,
    required this.iconBgGreen,
    required this.toggleActiveTrack,
    required this.destructiveColor,
  });

  @override
  AppColors copyWith({
    Color? counterText,
    Color? progressActive,
    Color? progressTrack,
    Color? tapButtonFill,
    Color? tapButtonShadow,
    Color? cardBorder,
    Color? subtleText,
    Color? sectionHeaderBg,
    Color? sectionLabelText,
    Color? iconBgTeal,
    Color? iconBgPurple,
    Color? iconBgAmber,
    Color? iconBgBlue,
    Color? iconBgCoral,
    Color? iconBgPink,
    Color? iconBgGray,
    Color? iconBgGreen,
    Color? toggleActiveTrack,
    Color? destructiveColor,
  }) => AppColors(
    counterText: counterText ?? this.counterText,
    progressActive: progressActive ?? this.progressActive,
    progressTrack: progressTrack ?? this.progressTrack,
    tapButtonFill: tapButtonFill ?? this.tapButtonFill,
    tapButtonShadow: tapButtonShadow ?? this.tapButtonShadow,
    cardBorder: cardBorder ?? this.cardBorder,
    subtleText: subtleText ?? this.subtleText,
    sectionHeaderBg: sectionHeaderBg ?? this.sectionHeaderBg,
    sectionLabelText: sectionLabelText ?? this.sectionLabelText,
    iconBgTeal: iconBgTeal ?? this.iconBgTeal,
    iconBgPurple: iconBgPurple ?? this.iconBgPurple,
    iconBgAmber: iconBgAmber ?? this.iconBgAmber,
    iconBgBlue: iconBgBlue ?? this.iconBgBlue,
    iconBgCoral: iconBgCoral ?? this.iconBgCoral,
    iconBgPink: iconBgPink ?? this.iconBgPink,
    iconBgGray: iconBgGray ?? this.iconBgGray,
    iconBgGreen: iconBgGreen ?? this.iconBgGreen,
    toggleActiveTrack: toggleActiveTrack ?? this.toggleActiveTrack,
    destructiveColor: destructiveColor ?? this.destructiveColor,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      counterText: Color.lerp(counterText, other.counterText, t)!,
      progressActive: Color.lerp(progressActive, other.progressActive, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      tapButtonFill: Color.lerp(tapButtonFill, other.tapButtonFill, t)!,
      tapButtonShadow: Color.lerp(tapButtonShadow, other.tapButtonShadow, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      subtleText: Color.lerp(subtleText, other.subtleText, t)!,
      sectionHeaderBg: Color.lerp(sectionHeaderBg, other.sectionHeaderBg, t)!,
      sectionLabelText: Color.lerp(sectionLabelText, other.sectionLabelText, t)!,
      iconBgTeal: Color.lerp(iconBgTeal, other.iconBgTeal, t)!,
      iconBgPurple: Color.lerp(iconBgPurple, other.iconBgPurple, t)!,
      iconBgAmber: Color.lerp(iconBgAmber, other.iconBgAmber, t)!,
      iconBgBlue: Color.lerp(iconBgBlue, other.iconBgBlue, t)!,
      iconBgCoral: Color.lerp(iconBgCoral, other.iconBgCoral, t)!,
      iconBgPink: Color.lerp(iconBgPink, other.iconBgPink, t)!,
      iconBgGray: Color.lerp(iconBgGray, other.iconBgGray, t)!,
      iconBgGreen: Color.lerp(iconBgGreen, other.iconBgGreen, t)!,
      toggleActiveTrack: Color.lerp(toggleActiveTrack, other.toggleActiveTrack, t)!,
      destructiveColor: Color.lerp(destructiveColor, other.destructiveColor, t)!,
    );
  }
}

class AppIconColors {
  // Light
  static const iconTeal = Color(0xFF0F6E56);
  static const iconPurple = Color(0xFF534AB7);
  static const iconAmber = Color(0xFF854F0B);
  static const iconBlue = Color(0xFF185FA5);
  static const iconCoral = Color(0xFF993C1D);
  static const iconPink = Color(0xFF993556);
  static const iconGray = Color(0xFF5F5E5A);
  static const iconGreen = Color(0xFF3B6D11);

  // Dark variants
  static const iconTealDark = Color(0xFF5DCAA5);
  static const iconPurpleDark = Color(0xFFAFA9EC);
  static const iconAmberDark = Color(0xFFFAC775);
  static const iconBlueDark = Color(0xFF85B7EB);
  static const iconCoralDark = Color(0xFFF0997B);
  static const iconPinkDark = Color(0xFFED93B1);
  static const iconGrayDark = Color(0xFFB4B2A9);
  static const iconGreenDark = Color(0xFF97C459);
}
