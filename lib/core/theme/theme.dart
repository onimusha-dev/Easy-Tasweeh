import 'package:flutter/material.dart';

// ─── Custom color extension ───────────────────────────────────────────────────
// For colors Material's ColorScheme doesn't cover (counter, progress, etc.)
class AppColors extends ThemeExtension<AppColors> {
  final Color counterText;
  final Color progressActive;
  final Color progressTrack;
  final Color tapButtonFill;
  final Color tapButtonShadow;
  final Color cardBorder;
  final Color subtleText;

  const AppColors({
    required this.counterText,
    required this.progressActive,
    required this.progressTrack,
    required this.tapButtonFill,
    required this.tapButtonShadow,
    required this.cardBorder,
    required this.subtleText,
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
  }) => AppColors(
    counterText: counterText ?? this.counterText,
    progressActive: progressActive ?? this.progressActive,
    progressTrack: progressTrack ?? this.progressTrack,
    tapButtonFill: tapButtonFill ?? this.tapButtonFill,
    tapButtonShadow: tapButtonShadow ?? this.tapButtonShadow,
    cardBorder: cardBorder ?? this.cardBorder,
    subtleText: subtleText ?? this.subtleText,
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
    );
  }
}

// ─── AppTheme ─────────────────────────────────────────────────────────────────
class AppTheme {
  // ── Raw palette ─────────────────────────────────────────────────────────────
  // Light
  static const _green900 = Color(0xFF1B5E20);
  static const _green700 = Color(0xFF2E7D32);
  static const _green500 = Color(0xFF4CAF50);
  static const _green200 = Color(0xFFA5D6A7);
  static const _green50 = Color(0xFFF1F8F1);

  // Dark
  static const _greenD400 = Color(0xFF81C784);
  static const _greenD200 = Color(0xFFA5D6A7);
  static const _surfaceD = Color(0xFF0D120D);
  static const _surfaceD2 = Color(0xFF141A14);
  static const _surfaceD3 = Color(0xFF1C241C);

  // Neutral
  static const _white = Color(0xFFFFFFFF);
  static const _black = Color(0xFF0A0A0A);
  static const _errorColor = Color(0xFFB00020);
  static const _errorDark = Color(0xFFCF6679);

  // ── Text theme (color-aware per brightness) ──────────────────────────────
  static TextTheme _buildTextTheme(Color primary, Color secondary) => TextTheme(
    displayLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w900,
      letterSpacing: -1,
      color: primary,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      color: primary,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: primary,
    ),
    // Used for the big counter number
    headlineMedium: TextStyle(
      fontSize: 56,
      fontWeight: FontWeight.w900,
      letterSpacing: -1.5,
      color: primary,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: primary,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: primary,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: primary,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: secondary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: primary,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.4,
      color: secondary,
    ),
  );

  // ── Light Theme ──────────────────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Full manual ColorScheme — nothing auto-generated
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _green900,
      onPrimary: _white,
      primaryContainer: _green200,
      onPrimaryContainer: _green900,
      secondary: _green700,
      onSecondary: _white,
      secondaryContainer: _green50,
      onSecondaryContainer: _green900,
      tertiary: _green500,
      onTertiary: _white,
      tertiaryContainer: _green50,
      onTertiaryContainer: _green700,
      error: _errorColor,
      onError: _white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: _green50,
      onSurface: _black,
      onSurfaceVariant: Color(0xFF444746),
      outline: Color(0xFF74796E),
      outlineVariant: Color(0xFFC4C9BE),
      shadow: Color(0x1A000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2D3130),
      onInverseSurface: Color(0xFFEFF1ED),
      inversePrimary: _greenD400,
    ),

    textTheme: _buildTextTheme(
      const Color(0xFF1A1C1A), // primary text
      const Color(0xFF6B6E6A), // secondary/muted text
    ),

    // ── AppBar ──────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: _black,
      iconTheme: IconThemeData(color: _green900, size: 24),
      actionsIconTheme: IconThemeData(color: _green900, size: 24),
    ),

    // ── Cards ───────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      elevation: 0,
      color: _white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE0E5E0), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // ── Buttons ─────────────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _green900,
        foregroundColor: _white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _green900,
        foregroundColor: _white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _green900,
        side: const BorderSide(color: _green900, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _green900,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),

    // ── IconButton ───────────────────────────────────────────────────────────
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: _green900,
        highlightColor: _green200.withOpacity(0.3),
      ),
    ),

    // ── SnackBar ─────────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1A1C1A),
      contentTextStyle: const TextStyle(
        color: _white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),

    // ── BottomSheet ──────────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      backgroundColor: _white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    // ── Dialog ───────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: _white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titleTextStyle: const TextStyle(
        color: _black,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      contentTextStyle: TextStyle(color: const Color(0xFF444746), fontSize: 15),
    ),

    // ── Chips ────────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: _green50,
      selectedColor: _green200,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _green900,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: const BorderSide(color: Color(0xFFD0D5CF), width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // ── Divider ──────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE8EDE8),
      thickness: 1,
      space: 1,
    ),

    // ── ListTile ─────────────────────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      iconColor: _green900,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _black,
      ),
      subtitleTextStyle: TextStyle(fontSize: 13, color: Color(0xFF6B6E6A)),
    ),

    // ── Custom extension ─────────────────────────────────────────────────────
    extensions: const [
      AppColors(
        counterText: _green900,
        progressActive: _green700,
        progressTrack: _green200,
        tapButtonFill: _green900,
        tapButtonShadow: Color(0x331B5E20),
        cardBorder: Color(0xFFE0E5E0),
        subtleText: Color(0xFF6B6E6A),
      ),
    ],
  );

  // ── Dark Theme ───────────────────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _greenD400,
      onPrimary: Color(0xFF003910),
      primaryContainer: _green700,
      onPrimaryContainer: _green200,
      secondary: _greenD200,
      onSecondary: Color(0xFF1B3A1F),
      secondaryContainer: _surfaceD3,
      onSecondaryContainer: _greenD200,
      tertiary: _greenD400,
      onTertiary: Color(0xFF003910),
      tertiaryContainer: _surfaceD3,
      onTertiaryContainer: _greenD200,
      error: _errorDark,
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: _surfaceD,
      onSurface: Color(0xFFE1E3DF),
      onSurfaceVariant: Color(0xFFC2C9BF),
      outline: Color(0xFF8C9388),
      outlineVariant: Color(0xFF424940),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE1E3DF),
      onInverseSurface: Color(0xFF2D3130),
      inversePrimary: _green900,
    ),

    textTheme: _buildTextTheme(
      const Color(0xFFE1E3DF), // primary text
      const Color(0xFFA0A5A0), // muted text
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFE1E3DF),
      iconTheme: IconThemeData(color: _greenD400, size: 24),
      actionsIconTheme: IconThemeData(color: _greenD400, size: 24),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: _surfaceD2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF2A322A), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _greenD400,
        foregroundColor: const Color(0xFF003910),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _greenD400,
        foregroundColor: const Color(0xFF003910),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _greenD400,
        side: const BorderSide(color: _greenD400, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _greenD400,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: _greenD400,
        highlightColor: _greenD400.withOpacity(0.15),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: _surfaceD3,
      contentTextStyle: const TextStyle(
        color: Color(0xFFE1E3DF),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      backgroundColor: _surfaceD2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: _surfaceD2,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titleTextStyle: const TextStyle(
        color: Color(0xFFE1E3DF),
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      contentTextStyle: const TextStyle(color: Color(0xFFC2C9BF), fontSize: 15),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _surfaceD3,
      selectedColor: _green700,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _greenD200,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: const BorderSide(color: Color(0xFF2A322A), width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A322A),
      thickness: 1,
      space: 1,
    ),

    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      iconColor: _greenD400,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE1E3DF),
      ),
      subtitleTextStyle: TextStyle(fontSize: 13, color: Color(0xFFA0A5A0)),
    ),

    extensions: const [
      AppColors(
        counterText: _greenD400,
        progressActive: _greenD400,
        progressTrack: _surfaceD3,
        tapButtonFill: _greenD400,
        tapButtonShadow: Color(0x4481C784),
        cardBorder: Color(0xFF2A322A),
        subtleText: Color(0xFFA0A5A0),
      ),
    ],
  );
}
