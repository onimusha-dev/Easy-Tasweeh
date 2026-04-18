import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'base_scheme.dart';

class TealColorScheme extends BaseColorScheme {
  @override
  final Brightness brightness;

  TealColorScheme(this.brightness);

  // ── Palette ────────────────────────────────────────────────────────────────
  static const _white = Color(0xFFFFFFFF);
  static const _teal50 = Color(0xFFE1F5EE);
  static const _teal400 = Color(0xFF1D9E75);
  static const _teal600 = Color(0xFF0F6E56);
  static const _teal800 = Color(0xFF085041);
  static const _teal900 = Color(0xFF04342C);

  static const _tealD400 = Color(0xFF5DCAA5);
  static const _tealD200 = Color(0xFF9FE1CB);

  static const _surfaceLight = Color(0xFFF2F2F7);
  static const _surfaceDark = Color(0xFF0E110E);
  static const _surfaceDark3 = Color(0xFF1E251E);

  @override
  Color get textPrimary => brightness == Brightness.light ? const Color(0xFF0D0F0D) : const Color(0xFFE2E5E2);
  
  @override
  Color get textSecondary => brightness == Brightness.light ? const Color(0xFF6B6E6A) : const Color(0xFF9A9E9A);

  @override
  Color get surface => brightness == Brightness.light ? _surfaceLight : _surfaceDark;

  @override
  Color get card => brightness == Brightness.light ? _white : const Color(0xFF161B16);

  @override
  Color get border => brightness == Brightness.light ? const Color(0xFFE0E4E0) : const Color(0xFF262E26);

  @override
  Color get divider => brightness == Brightness.light ? const Color(0xFFE8EBE8) : const Color(0xFF262E26);

  @override
  ColorScheme get colorScheme {
    if (brightness == Brightness.light) {
      return const ColorScheme(
        brightness: Brightness.light,
        primary: _teal600,
        onPrimary: _white,
        primaryContainer: _teal50,
        onPrimaryContainer: _teal900,
        secondary: _teal400,
        onSecondary: _white,
        secondaryContainer: _teal50,
        onSecondaryContainer: _teal800,
        tertiary: _teal400,
        onTertiary: _white,
        tertiaryContainer: _teal50,
        onTertiaryContainer: _teal600,
        surface: _surfaceLight,
        onSurface: Color(0xFF0D0F0D),
        onSurfaceVariant: Color(0xFF6B6E6A),
        error: Color(0xFFB00020),
        onError: _white,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        outline: Color(0xFFC0C4BE),
        outlineVariant: Color(0xFFDDE1DC),
        shadow: Color(0x14000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF2D312D),
        onInverseSurface: Color(0xFFEFF1ED),
        inversePrimary: _tealD200,
      );
    } else {
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: _tealD400,
        onPrimary: _teal900,
        primaryContainer: _teal800,
        onPrimaryContainer: _tealD200,
        secondary: _tealD200,
        onSecondary: _teal900,
        secondaryContainer: _surfaceDark3,
        onSecondaryContainer: _tealD200,
        tertiary: _tealD400,
        onTertiary: _teal900,
        tertiaryContainer: _surfaceDark3,
        onTertiaryContainer: _tealD200,
        surface: _surfaceDark,
        onSurface: Color(0xFFE2E5E2),
        onSurfaceVariant: Color(0xFF9A9E9A),
        error: Color(0xFFCF6679),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        outline: Color(0xFF3A3F3A),
        outlineVariant: Color(0xFF2A302A),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFE2E5E2),
        onInverseSurface: Color(0xFF2D312D),
        inversePrimary: _teal600,
      );
    }
  }

  @override
  AppColors get appColors {
    if (brightness == Brightness.light) {
      return const AppColors(
        counterText: _teal600,
        progressActive: _teal400,
        progressTrack: _teal50,
        tapButtonFill: _teal600,
        tapButtonShadow: Color(0x260F6E56),
        cardBorder: Color(0xFFE0E4E0),
        subtleText: Color(0xFF6B6E6A),
        sectionHeaderBg: _surfaceLight,
        sectionLabelText: Color(0xFF6B6E6A),
        iconBgTeal: _teal50,
        iconBgPurple: Color(0xFFEEEDFE),
        iconBgAmber: Color(0xFFFAEEDA),
        iconBgBlue: Color(0xFFE6F1FB),
        iconBgCoral: Color(0xFFFAECE7),
        iconBgPink: Color(0xFFFBEAF0),
        iconBgGray: Color(0xFFF1EFE8),
        iconBgGreen: Color(0xFFEAF3DE),
        toggleActiveTrack: _teal400,
        destructiveColor: Color(0xFFDC2626),
      );
    } else {
      return AppColors(
        counterText: _tealD400,
        progressActive: _tealD400,
        progressTrack: _surfaceDark3,
        tapButtonFill: _tealD400,
        tapButtonShadow: _tealD400.withValues(alpha: 0.25),
        cardBorder: const Color(0xFF262E26),
        subtleText: const Color(0xFF9A9E9A),
        sectionHeaderBg: _surfaceDark,
        sectionLabelText: const Color(0xFF9A9E9A),
        iconBgTeal: const Color(0xFF085041),
        iconBgPurple: const Color(0xFF3C3489),
        iconBgAmber: const Color(0xFF633806),
        iconBgBlue: const Color(0xFF0C447C),
        iconBgCoral: const Color(0xFF712B13),
        iconBgPink: const Color(0xFF72243E),
        iconBgGray: const Color(0xFF444441),
        iconBgGreen: const Color(0xFF27500A),
        toggleActiveTrack: _tealD400,
        destructiveColor: const Color(0xFFF87171),
      );
    }
  }
}
