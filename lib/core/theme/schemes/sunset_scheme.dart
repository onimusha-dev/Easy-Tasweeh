import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'base_scheme.dart';

class SunsetColorScheme extends BaseColorScheme {
  @override
  final Brightness brightness;

  SunsetColorScheme(this.brightness);

  // ── Palette (Sunset Glow) ──────────────────────────────────────────────
  static const _yellow = Color(0xFFFFF085);
  static const _lightOrange = Color(0xFFFCB454);
  static const _deepOrange = Color(0xFFFF9B17);
  static const _coral = Color(0xFFF16767);
  
  static const _white = Color(0xFFFFFFFF);
  static const _cream = Color(0xFFFFFDF5);
  static const _darkBrown = Color(0xFF1A0F00);
  static const _deepBrown = Color(0xFF2D1B00);

  @override
  Color get textPrimary => brightness == Brightness.light ? const Color(0xFF3D2600) : const Color(0xFFFFFAF0);
  
  @override
  Color get textSecondary => brightness == Brightness.light ? const Color(0xFF8B5E00) : const Color(0xFFFFD599);

  @override
  Color get surface => brightness == Brightness.light ? _cream : _darkBrown;

  @override
  Color get card => brightness == Brightness.light ? _white : _deepBrown;

  @override
  Color get border => brightness == Brightness.light ? _lightOrange.withValues(alpha: 0.2) : _deepOrange.withValues(alpha: 0.15);

  @override
  Color get divider => brightness == Brightness.light ? _yellow.withValues(alpha: 0.3) : _deepBrown;

  @override
  ColorScheme get colorScheme {
    if (brightness == Brightness.light) {
      return const ColorScheme(
        brightness: Brightness.light,
        primary: _deepOrange,
        onPrimary: _white,
        primaryContainer: _yellow,
        onPrimaryContainer: Color(0xFF3D2600),
        secondary: _lightOrange,
        onSecondary: _white,
        secondaryContainer: Color(0xFFFFF9E6),
        onSecondaryContainer: _deepOrange,
        tertiary: _coral,
        onTertiary: _white,
        tertiaryContainer: Color(0xFFFFEBEB),
        onTertiaryContainer: _coral,
        surface: _cream,
        onSurface: Color(0xFF3D2600),
        onSurfaceVariant: Color(0xFF8B5E00),
        error: Color(0xFFB00020),
        onError: _white,
        outline: _lightOrange,
        shadow: Color(0x14FF9B17),
      );
    } else {
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: _deepOrange,
        onPrimary: Color(0xFF3D2600),
        primaryContainer: Color(0xFF4D3200),
        onPrimaryContainer: _yellow,
        secondary: _lightOrange,
        onSecondary: Color(0xFF3D2600),
        secondaryContainer: Color(0xFF3D2600),
        onSecondaryContainer: _lightOrange,
        tertiary: _coral,
        onTertiary: _white,
        tertiaryContainer: Color(0xFF4D1A1A),
        onTertiaryContainer: _coral,
        surface: _darkBrown,
        onSurface: Color(0xFFFFFAF0),
        onSurfaceVariant: Color(0xFFFFD599),
        error: Color(0xFFCF6679),
        onError: Color(0xFF690005),
        outline: Color(0xFF4D3200),
        shadow: Color(0xFF000000),
      );
    }
  }

  @override
  AppColors get appColors {
    if (brightness == Brightness.light) {
      return AppColors(
        counterText: _deepOrange,
        progressActive: _deepOrange,
        progressTrack: _yellow.withValues(alpha: 0.5),
        tapButtonFill: _deepOrange,
        tapButtonShadow: _deepOrange.withValues(alpha: 0.25),
        cardBorder: _lightOrange.withValues(alpha: 0.3),
        subtleText: const Color(0xFF8B5E00),
        sectionHeaderBg: _yellow.withValues(alpha: 0.2),
        sectionLabelText: const Color(0xFF8B5E00),
        iconBgSage: const Color(0xFFE1F5EE),
        iconBgPurple: const Color(0xFFEEEDFE),
        iconBgAmber: _yellow.withValues(alpha: 0.3),
        iconBgBlue: const Color(0xFFE6F1FB),
        iconBgCoral: _coral.withValues(alpha: 0.1),
        iconBgPink: const Color(0xFFFBEAF0),
        iconBgGray: const Color(0xFFF1EFE8),
        iconBgGreen: const Color(0xFFEAF3DE),
        toggleActiveTrack: _lightOrange,
        destructiveColor: const Color(0xFFDC2626),
      );
    } else {
      return AppColors(
        counterText: _deepOrange,
        progressActive: _deepOrange,
        progressTrack: _deepBrown,
        tapButtonFill: _deepOrange,
        tapButtonShadow: const Color(0x40000000),
        cardBorder: _deepBrown,
        subtleText: const Color(0xFFFFD599),
        sectionHeaderBg: _darkBrown,
        sectionLabelText: const Color(0xFFFFD599),
        iconBgSage: const Color(0xFF085041),
        iconBgPurple: const Color(0xFF3C3489),
        iconBgAmber: _deepOrange.withValues(alpha: 0.2),
        iconBgBlue: const Color(0xFF0C447C),
        iconBgCoral: _coral.withValues(alpha: 0.2),
        iconBgPink: const Color(0xFF72243E),
        iconBgGray: const Color(0xFF444441),
        iconBgGreen: const Color(0xFF27500A),
        toggleActiveTrack: _deepOrange,
        destructiveColor: const Color(0xFFF87171),
      );
    }
  }
}
