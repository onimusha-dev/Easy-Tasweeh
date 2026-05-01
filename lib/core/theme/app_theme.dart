import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';

class AppTheme {
  static ThemeData createTheme(BaseColorScheme scheme) {
    final bool isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme.colorScheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: AppTypography.buildTextTheme(
        scheme.textPrimary,
        scheme.textSecondary,
      ),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarContrastEnforced: false,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
        iconTheme: IconThemeData(
          color: scheme.colorScheme.primary,
          size: AppLayout.iconSizeMedium,
        ),
        actionsIconTheme: IconThemeData(
          color: scheme.colorScheme.primary,
          size: AppLayout.iconSizeMedium,
        ),
        titleTextStyle: AppTypography.appBarTitle(scheme.textPrimary),
      ),

      // ── Cards ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.card,
        shape: RoundedRectangleBorder(
          borderRadius: AppLayout.brLarge,
          side: BorderSide(
            color: scheme.border.withValues(alpha: AppLayout.borderOpacity),
            width: AppLayout.borderWidth,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Buttons ───────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.colorScheme.primary,
          foregroundColor: scheme.colorScheme.onPrimary,
          padding: AppLayout.buttonPadding,
          minimumSize: const Size(88, 56),
          shape: RoundedRectangleBorder(borderRadius: AppLayout.brMedium),
          elevation: isDark ? 0 : 2,
          shadowColor: scheme.colorScheme.primary.withValues(alpha: 0.3),
          splashFactory: InkSparkle.splashFactory,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: AppTypography.weightBold,
            letterSpacing: 0.2,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.colorScheme.primary,
          foregroundColor: scheme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppLayout.brMedium),
          padding: AppLayout.buttonPadding,
          minimumSize: const Size(88, 56),
          splashFactory: InkSparkle.splashFactory,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: AppTypography.weightBold,
            letterSpacing: 0.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.colorScheme.primary,
          side: BorderSide(
            color: scheme.colorScheme.primary,
            width: AppLayout.borderWidth,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppLayout.brMedium),
          padding: AppLayout.buttonPadding,
          minimumSize: const Size(88, 56),
          splashFactory: InkSparkle.splashFactory,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: AppTypography.weightBold,
            letterSpacing: 0.2,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppLayout.brSmall),
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: AppTypography.weightSemiBold,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // ── Interaction Elements ──────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return isDark ? scheme.colorScheme.onPrimary : Colors.white;
          }
          return const Color(0xFFBDBDBD);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.colorScheme.secondary;
          }
          return isDark ? const Color(0xFF2D3C32) : const Color(0xFFD4DEC4);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1E2822) : const Color(0xFF1A1D1A),
        contentTextStyle: TextStyle(
          color: isDark ? scheme.textPrimary : Colors.white,
          fontSize: 14,
          fontWeight: AppTypography.weightBold,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppLayout.brMedium),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1B2420) : scheme.card,
        shape: RoundedRectangleBorder(borderRadius: AppLayout.brSheet),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF1B2420) : scheme.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppLayout.brDialog),
        titleTextStyle: TextStyle(
          color: scheme.textPrimary,
          fontSize: 18,
          fontWeight: AppTypography.weightExtraBold,
          letterSpacing: -0.3,
        ),
        contentTextStyle: TextStyle(color: scheme.textSecondary, fontSize: 15),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: scheme.colorScheme.primaryContainer,
        selectedColor: isDark
            ? scheme.colorScheme.primary
            : scheme.colorScheme.primaryContainer,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: AppTypography.weightBold,
          color: isDark
              ? scheme.colorScheme.onPrimary
              : scheme.colorScheme.onPrimaryContainer,
        ),
        shape: AppLayout.shapeChip,
        side: BorderSide(
          color: scheme.border.withValues(alpha: AppLayout.borderOpacity),
          width: AppLayout.borderWidth / 2,
        ),
        padding: AppLayout.chipPadding,
      ),

      dividerTheme: DividerThemeData(
        color: scheme.divider,
        thickness: 0.5,
        space: 0.5,
        indent: AppLayout.dividerIndent,
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: AppLayout.listTilePadding,
        minLeadingWidth: 0,
        iconColor: scheme.colorScheme.primary,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: AppTypography.weightBold,
          color: scheme.textPrimary,
          letterSpacing: -0.2,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: AppTypography.weightRegular,
          color: scheme.textSecondary,
        ),
      ),

      extensions: [scheme.appColors],
    );
  }

  // Convenience methods for the default theme
  static ThemeData get light => createTheme(SageColorScheme(Brightness.light));
  static ThemeData get dark => createTheme(SageColorScheme(Brightness.dark));

  // Backward compatibility aliases
  static ThemeData get lightTheme => light;
  static ThemeData get darkTheme => dark;

  // Resolve dynamic scheme from settings
  static BaseColorScheme resolveColorScheme(
    AppColorScheme scheme,
    Brightness brightness,
  ) {
    switch (scheme) {
      case AppColorScheme.sage:
        return SageColorScheme(brightness);
      case AppColorScheme.sunset:
        return SunsetColorScheme(brightness);
    }
  }
}
