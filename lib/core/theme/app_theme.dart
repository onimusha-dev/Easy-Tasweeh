import 'package:flutter/material.dart';
import 'theme.dart';

class AppTheme {
  static ThemeData createTheme(BaseColorScheme scheme) {
    final bool isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'GoogleSansFlex',
      brightness: scheme.brightness,
      colorScheme: scheme.colorScheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: AppTypography.buildTextTheme(scheme.textPrimary, scheme.textSecondary),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.textPrimary,
        iconTheme: IconThemeData(color: scheme.colorScheme.primary, size: AppLayout.iconSizeMedium),
        actionsIconTheme: IconThemeData(color: scheme.colorScheme.primary, size: AppLayout.iconSizeMedium),
        titleTextStyle: AppTypography.appBarTitle(scheme.textPrimary),
      ),

      // ── Cards ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.card,
        shape: RoundedRectangleBorder(
          borderRadius: AppLayout.brLarge,
          side: BorderSide(color: scheme.border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Buttons ───────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.colorScheme.primary,
          foregroundColor: scheme.colorScheme.onPrimary,
          padding: AppLayout.buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: AppLayout.brLarge),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.colorScheme.primary,
          foregroundColor: scheme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppLayout.brLarge),
          padding: AppLayout.buttonPadding,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.colorScheme.primary,
          side: BorderSide(color: scheme.colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AppLayout.brLarge),
          padding: AppLayout.buttonPadding,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.colorScheme.primary,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.colorScheme.primary,
          highlightColor: scheme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),

      // ── Interaction Elements ──────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return isDark ? scheme.colorScheme.onPrimary : Colors.white;
          return const Color(0xFFBDBDBD);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.colorScheme.secondary;
          return isDark ? const Color(0xFF1E251E) : const Color(0xFFE0E0E0);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1E251E) : const Color(0xFF1A1D1A),
        contentTextStyle: TextStyle(
          color: isDark ? scheme.textPrimary : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppLayout.brMedium),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF161B16) : scheme.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppLayout.radiusExtraLarge)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF161B16) : scheme.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppLayout.brExtraLarge),
        titleTextStyle: TextStyle(
          color: scheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
        ),
        contentTextStyle: TextStyle(
          color: scheme.textSecondary,
          fontSize: 15,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: scheme.colorScheme.primaryContainer,
        selectedColor: isDark ? scheme.colorScheme.primary : scheme.colorScheme.primaryContainer,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: isDark ? scheme.colorScheme.onPrimary : scheme.colorScheme.onPrimaryContainer,
        ),
        shape: AppLayout.shapeChip,
        side: BorderSide(color: scheme.border, width: 0.5),
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
          fontWeight: FontWeight.w800,
          color: scheme.textPrimary,
          letterSpacing: -0.1,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: scheme.textSecondary,
        ),
      ),

      extensions: [scheme.appColors],
    );
  }

  // Convenience methods for the default theme
  static ThemeData get light => createTheme(TealColorScheme(Brightness.light));
  static ThemeData get dark => createTheme(TealColorScheme(Brightness.dark));

  // Backward compatibility aliases
  static ThemeData get lightTheme => light;
  static ThemeData get darkTheme => dark;

  // Resolve dynamic scheme from settings
  static BaseColorScheme resolveColorScheme(AppColorScheme scheme, Brightness brightness) {
    switch (scheme) {
      case AppColorScheme.teal:
        return TealColorScheme(brightness);
      case AppColorScheme.slate:
        return SlateColorScheme(brightness);
    }
  }
}
