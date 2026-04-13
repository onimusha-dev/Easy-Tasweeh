import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'base_scheme.dart';

class SlateColorScheme extends BaseColorScheme {
  @override
  final Brightness brightness;

  SlateColorScheme(this.brightness);

  // ── Palette (Slate / Tactical Gray) ────────────────────────────────────────
  static const _white = Color(0xFFFFFFFF);
  static const _slate50 = Color(0xFFF8FAFC);
  static const _slate400 = Color(0xFF94A3B8);
  static const _slate600 = Color(0xFF475569);
  static const _slate800 = Color(0xFF1E293B);
  static const _slate900 = Color(0xFF0F172A);

  @override
  Color get textPrimary => brightness == Brightness.light ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
  
  @override
  Color get textSecondary => brightness == Brightness.light ? const Color(0xFF475569) : const Color(0xFF94A3B8);

  @override
  Color get surface => brightness == Brightness.light ? const Color(0xFFF1F5F9) : const Color(0xFF020617);

  @override
  Color get card => brightness == Brightness.light ? _white : const Color(0xFF0F172A);

  @override
  Color get border => brightness == Brightness.light ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);

  @override
  Color get divider => brightness == Brightness.light ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B);

  @override
  ColorScheme get colorScheme {
    if (brightness == Brightness.light) {
      return const ColorScheme(
        brightness: Brightness.light,
        primary: _slate600,
        onPrimary: _white,
        primaryContainer: _slate50,
        onPrimaryContainer: _slate900,
        secondary: _slate400,
        onSecondary: _white,
        secondaryContainer: _slate50,
        onSecondaryContainer: _slate800,
        tertiary: _slate400,
        onTertiary: _white,
        tertiaryContainer: _slate50,
        onTertiaryContainer: _slate600,
        surface: Color(0xFFF1F5F9),
        onSurface: Color(0xFF0F172A),
        onSurfaceVariant: Color(0xFF475569),
        error: Color(0xFFB00020),
        onError: _white,
        outline: Color(0xFFCBD5E1),
        shadow: Color(0x14000000),
      );
    } else {
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: _slate400,
        onPrimary: _slate900,
        primaryContainer: _slate800,
        onPrimaryContainer: _slate50,
        secondary: _slate600,
        onSecondary: _white,
        secondaryContainer: Color(0xFF1E293B),
        onSecondaryContainer: _slate400,
        tertiary: _slate400,
        onTertiary: _slate900,
        tertiaryContainer: Color(0xFF1E293B),
        onTertiaryContainer: _slate400,
        surface: Color(0xFF020617),
        onSurface: Color(0xFFF1F5F9),
        onSurfaceVariant: Color(0xFF94A3B8),
        error: Color(0xFFCF6679),
        onError: Color(0xFF690005),
        outline: Color(0xFF334155),
        shadow: Color(0xFF000000),
      );
    }
  }

  @override
  AppColors get appColors {
    // Custom colors for Slate theme
    if (brightness == Brightness.light) {
      return const AppColors(
        counterText: _slate600,
        progressActive: _slate600,
        progressTrack: _slate50,
        tapButtonFill: _slate600,
        tapButtonShadow: Color(0x26475569),
        cardBorder: Color(0xFFE2E8F0),
        subtleText: Color(0xFF475569),
        sectionHeaderBg: Color(0xFFF1F5F9),
        sectionLabelText: Color(0xFF475569),
        iconBgTeal: Color(0xFFE1F5EE),
        iconBgPurple: Color(0xFFEEEDFE),
        iconBgAmber: Color(0xFFFAEEDA),
        iconBgBlue: Color(0xFFE6F1FB),
        iconBgCoral: Color(0xFFFAECE7),
        iconBgPink: Color(0xFFFBEAF0),
        iconBgGray: Color(0xFFF1EFE8),
        iconBgGreen: Color(0xFFEAF3DE),
        toggleActiveTrack: _slate400,
        destructiveColor: Color(0xFFDC2626),
      );
    } else {
      return const AppColors(
        counterText: _slate400,
        progressActive: _slate400,
        progressTrack: Color(0xFF1E293B),
        tapButtonFill: _slate400,
        tapButtonShadow: Color(0x4094A3B8),
        cardBorder: Color(0xFF1E293B),
        subtleText: Color(0xFF94A3B8),
        sectionHeaderBg: Color(0xFF020617),
        sectionLabelText: Color(0xFF94A3B8),
        iconBgTeal: Color(0xFF085041),
        iconBgPurple: Color(0xFF3C3489),
        iconBgAmber: Color(0xFF633806),
        iconBgBlue: Color(0xFF0C447C),
        iconBgCoral: Color(0xFF712B13),
        iconBgPink: Color(0xFF72243E),
        iconBgGray: Color(0xFF444441),
        iconBgGreen: Color(0xFF27500A),
        toggleActiveTrack: _slate400,
        destructiveColor: Color(0xFFF87171),
      );
    }
  }
}
