import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'base_scheme.dart';

class SageColorScheme extends BaseColorScheme {
  @override
  final Brightness brightness;

  SageColorScheme(this.brightness);

  // ── Palette ────────────────────────────────────────────────────────────────
  static const _white = Color(0xFFFFFFFF);
  static const _surfaceLight = Color(0xFFEBF4DD); // #EBF4DD
  static const _sagePrimary = Color(0xFF5A7863); // #5A7863
  static const _sageSecondary = Color(0xFF90AB8B); // #90AB8B
  static const _darkSlate = Color(0xFF3B4953); // #3B4953

  static const _sageLight = Color(0xFFD8E4C0);
  static const _sageDark = Color(0xFF425A4A);
  static const _sageDeep = Color(0xFF2D3C32);

  static const _surfaceDark = Color(0xFF141A17);
  static const _surfaceDark3 = Color(0xFF1E2822);

  @override
  Color get textPrimary =>
      brightness == Brightness.light ? _darkSlate : const Color(0xFFE2EBE5);

  @override
  Color get textSecondary => brightness == Brightness.light
      ? const Color(0xFF5A665E)
      : const Color(0xFFA5B2AA);

  @override
  Color get surface =>
      brightness == Brightness.light ? _surfaceLight : _surfaceDark;

  @override
  Color get card =>
      brightness == Brightness.light ? _white : const Color(0xFF1B2420);

  @override
  Color get border => brightness == Brightness.light
      ? const Color(0xFFD4DEC4)
      : const Color(0xFF2A3630);

  @override
  Color get divider => brightness == Brightness.light
      ? const Color(0xFFDDE6CD)
      : const Color(0xFF2A3630);

  @override
  ColorScheme get colorScheme {
    if (brightness == Brightness.light) {
      return const ColorScheme(
        brightness: Brightness.light,
        primary: _sagePrimary,
        onPrimary: _white,
        primaryContainer: _sageLight,
        onPrimaryContainer: _sageDeep,
        secondary: _sageSecondary,
        onSecondary: _white,
        secondaryContainer: _sageLight,
        onSecondaryContainer: _sageDark,
        tertiary: _darkSlate,
        onTertiary: _white,
        tertiaryContainer: Color(0xFFD0D7DE),
        onTertiaryContainer: Color(0xFF1A2126),
        surface: _surfaceLight,
        onSurface: _darkSlate,
        onSurfaceVariant: Color(0xFF5A665E),
        error: Color(0xFFBA1A1A),
        onError: _white,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        outline: Color(0xFF707973),
        outlineVariant: Color(0xFFC0C9C2),
        shadow: Color(0x14000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF2D312D),
        onInverseSurface: Color(0xFFF1F1E9),
        inversePrimary: Color(0xFFA6CFB6),
      );
    } else {
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFA6CFB6),
        onPrimary: Color(0xFF1A3626),
        primaryContainer: Color(0xFF2D4B39),
        onPrimaryContainer: Color(0xFFC2EBD1),
        secondary: Color(0xFFB8D0C0),
        onSecondary: Color(0xFF22362A),
        secondaryContainer: Color(0xFF384B40),
        onSecondaryContainer: Color(0xFFD4ECD9),
        tertiary: Color(0xFFA6B8D0),
        onTertiary: Color(0xFF10263C),
        tertiaryContainer: Color(0xFF2A3C4B),
        onTertiaryContainer: Color(0xFFD0E1F5),
        surface: _surfaceDark,
        onSurface: Color(0xFFE2EBE5),
        onSurfaceVariant: Color(0xFFC0C9C2),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        outline: Color(0xFF8A938C),
        outlineVariant: Color(0xFF404943),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFE2EBE5),
        onInverseSurface: Color(0xFF2D312D),
        inversePrimary: _sagePrimary,
      );
    }
  }

  @override
  AppColors get appColors {
    if (brightness == Brightness.light) {
      return const AppColors(
        counterText: _sagePrimary,
        progressActive: _sageSecondary,
        progressTrack: _sageLight,
        tapButtonFill: _sagePrimary,
        tapButtonShadow: Color(0x265A7863),
        cardBorder: Color(0xFFD4DEC4),
        subtleText: Color(0xFF5A665E),
        sectionHeaderBg: _surfaceLight,
        sectionLabelText: Color(0xFF5A665E),
        iconBgSage: _sageLight,
        iconBgPurple: Color(0xFFE8E5FF),
        iconBgAmber: Color(0xFFFBF1D5),
        iconBgBlue: Color(0xFFE1F0FF),
        iconBgCoral: Color(0xFFFDECE5),
        iconBgPink: Color(0xFFFCE9F0),
        iconBgGray: Color(0xFFF1F1E9),
        iconBgGreen: Color(0xFFEAF5DE),
        toggleActiveTrack: _sageSecondary,
        destructiveColor: Color(0xFFDC2626),
      );
    } else {
      return AppColors(
        counterText: const Color(0xFFA6CFB6),
        progressActive: const Color(0xFFA6CFB6),
        progressTrack: _surfaceDark3,
        tapButtonFill: const Color(0xFFA6CFB6),
        tapButtonShadow: const Color(0xFFA6CFB6).withValues(alpha: 0.25),
        cardBorder: const Color(0xFF2A3630),
        subtleText: const Color(0xFFA5B2AA),
        sectionHeaderBg: _surfaceDark,
        sectionLabelText: const Color(0xFFA5B2AA),
        iconBgSage: const Color(0xFF2D4B39),
        iconBgPurple: const Color(0xFF342E72),
        iconBgAmber: const Color(0xFF5C4108),
        iconBgBlue: const Color(0xFF083A6B),
        iconBgCoral: const Color(0xFF6B2608),
        iconBgPink: const Color(0xFF6B1D3A),
        iconBgGray: const Color(0xFF3F3F3C),
        iconBgGreen: const Color(0xFF274B08),
        toggleActiveTrack: const Color(0xFFA6CFB6),
        destructiveColor: const Color(0xFFF87171),
      );
    }
  }
}
