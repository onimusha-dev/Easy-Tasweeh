import 'package:flutter/material.dart';

// ─── Custom color extension ────────────────────────────────────────────────────
// Holds semantic colors that Material ColorScheme doesn't cover
class AppColors extends ThemeExtension<AppColors> {
  final Color counterText;
  final Color progressActive;
  final Color progressTrack;
  final Color tapButtonFill;
  final Color tapButtonShadow;
  final Color cardBorder;
  final Color subtleText;
  final Color sectionHeaderBg; // the grey grouped-list section background
  final Color sectionLabelText; // ALL-CAPS section label colour
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
      sectionLabelText: Color.lerp(
        sectionLabelText,
        other.sectionLabelText,
        t,
      )!,
      iconBgTeal: Color.lerp(iconBgTeal, other.iconBgTeal, t)!,
      iconBgPurple: Color.lerp(iconBgPurple, other.iconBgPurple, t)!,
      iconBgAmber: Color.lerp(iconBgAmber, other.iconBgAmber, t)!,
      iconBgBlue: Color.lerp(iconBgBlue, other.iconBgBlue, t)!,
      iconBgCoral: Color.lerp(iconBgCoral, other.iconBgCoral, t)!,
      iconBgPink: Color.lerp(iconBgPink, other.iconBgPink, t)!,
      iconBgGray: Color.lerp(iconBgGray, other.iconBgGray, t)!,
      iconBgGreen: Color.lerp(iconBgGreen, other.iconBgGreen, t)!,
      toggleActiveTrack: Color.lerp(
        toggleActiveTrack,
        other.toggleActiveTrack,
        t,
      )!,
      destructiveColor: Color.lerp(
        destructiveColor,
        other.destructiveColor,
        t,
      )!,
    );
  }
}

// ─── Icon colour helpers ───────────────────────────────────────────────────────
// Use these pairs when building settings tiles:
//   Container(color: appColors.iconBgTeal, child: Icon(color: AppTheme.iconTeal))
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

  // Dark variants (same hue, lighter)
  static const iconTealDark = Color(0xFF5DCAA5);
  static const iconPurpleDark = Color(0xFFAFA9EC);
  static const iconAmberDark = Color(0xFFFAC775);
  static const iconBlueDark = Color(0xFF85B7EB);
  static const iconCoralDark = Color(0xFFF0997B);
  static const iconPinkDark = Color(0xFFED93B1);
  static const iconGrayDark = Color(0xFFB4B2A9);
  static const iconGreenDark = Color(0xFF97C459);
}

// ─── AppTheme ──────────────────────────────────────────────────────────────────
class AppTheme {
  // ── Teal palette (primary brand) ──────────────────────────────────────────
  // Maps to the mockup's teal ramp: 50→900
  static const _teal50 = Color(0xFFE1F5EE);
  static const _teal100 = Color(0xFF9FE1CB);
  static const _teal400 = Color(0xFF1D9E75);
  static const _teal600 = Color(0xFF0F6E56);
  static const _teal800 = Color(0xFF085041);
  static const _teal900 = Color(0xFF04342C);

  // Dark surface teal tints
  static const _tealD400 = Color(0xFF5DCAA5);
  static const _tealD200 = Color(0xFF9FE1CB);

  // ── Icon palette backgrounds ───────────────────────────────────────────────
  static const _purple50 = Color(0xFFEEEDFE);
  static const _purple600 = Color(0xFF534AB7);
  static const _amber50 = Color(0xFFFAEEDA);
  static const _amber600 = Color(0xFF854F0B);
  static const _blue50 = Color(0xFFE6F1FB);
  static const _blue600 = Color(0xFF185FA5);
  static const _coral50 = Color(0xFFFAECE7);
  static const _coral600 = Color(0xFF993C1D);
  static const _pink50 = Color(0xFFFBEAF0);
  static const _pink600 = Color(0xFF993556);
  static const _gray50 = Color(0xFFF1EFE8);
  static const _gray600 = Color(0xFF5F5E5A);
  static const _green50Palette = Color(0xFFEAF3DE);
  static const _green600 = Color(0xFF3B6D11);

  // Dark icon bg variants
  static const _purple800 = Color(0xFF3C3489);
  static const _amber800 = Color(0xFF633806);
  static const _blue800 = Color(0xFF0C447C);
  static const _coral800 = Color(0xFF712B13);
  static const _pink800 = Color(0xFF72243E);
  static const _gray800 = Color(0xFF444441);
  static const _green800 = Color(0xFF27500A);
  static const _teal800bg = Color(0xFF085041);

  // ── Surfaces ───────────────────────────────────────────────────────────────
  // Light
  static const _white = Color(0xFFFFFFFF);
  static const _surfaceLight = Color(0xFFF2F2F7); // iOS-style grouped bg
  static const _cardLight = Color(0xFFFFFFFF);
  static const _borderLight = Color(0xFFE0E4E0);
  static const _dividerLight = Color(0xFFE8EBE8);

  // Dark
  static const _surfaceDark = Color(0xFF0E110E);
  static const _surfaceDark2 = Color(0xFF161B16);
  static const _surfaceDark3 = Color(0xFF1E251E);
  static const _cardDark = Color(0xFF161B16);
  static const _borderDark = Color(0xFF262E26);
  static const _dividerDark = Color(0xFF262E26);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const _textPrimaryLight = Color(0xFF0D0F0D);
  static const _textSecondaryLight = Color(0xFF6B6E6A);
  static const _textPrimaryDark = Color(0xFFE2E5E2);
  static const _textSecondaryDark = Color(0xFF9A9E9A);

  static const _black = Color(0xFF0A0A0A);
  static const _errorColor = Color(0xFFB00020);
  static const _errorDark = Color(0xFFCF6679);
  static const _destructiveLight = Color(0xFFDC2626);
  static const _destructiveDark = Color(0xFFF87171);

  // ── Text theme ────────────────────────────────────────────────────────────
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
    // Big counter number
    headlineMedium: TextStyle(
      fontSize: 72,
      fontWeight: FontWeight.w900,
      letterSpacing: -2,
      color: primary,
    ),
    headlineSmall: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
      color: primary,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: primary,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: primary,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: primary,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: primary,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: secondary,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: secondary,
    ),
    // Section headers (ALL-CAPS small label above card groups)
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: secondary,
    ),
  );

  // ── Light Theme ────────────────────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      // Primary = teal brand
      primary: _teal600,
      onPrimary: _white,
      primaryContainer: _teal50,
      onPrimaryContainer: _teal900,
      // Secondary = teal mid
      secondary: _teal400,
      onSecondary: _white,
      secondaryContainer: _teal50,
      onSecondaryContainer: _teal800,
      // Tertiary = teal light accent
      tertiary: _teal400,
      onTertiary: _white,
      tertiaryContainer: _teal50,
      onTertiaryContainer: _teal600,
      // Surfaces — grouped list style
      surface: _surfaceLight, // page background (grouped grey)
      onSurface: _textPrimaryLight,
      onSurfaceVariant: _textSecondaryLight,
      // Error
      error: _errorColor,
      onError: _white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      // Outline
      outline: Color(0xFFC0C4BE),
      outlineVariant: Color(0xFFDDE1DC),
      // Misc
      shadow: Color(0x14000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2D312D),
      onInverseSurface: Color(0xFFEFF1ED),
      inversePrimary: _tealD400,
    ),

    scaffoldBackgroundColor: _surfaceLight,

    textTheme: _buildTextTheme(_textPrimaryLight, _textSecondaryLight),

    // ── AppBar ──────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: Colors.transparent,
      foregroundColor: _textPrimaryLight,
      iconTheme: IconThemeData(color: _teal600, size: 24),
      actionsIconTheme: IconThemeData(color: _teal600, size: 24),
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: _textPrimaryLight,
        letterSpacing: -0.2,
      ),
    ),

    // ── Cards ───────────────────────────────────────────────────────────────
    // Used for the white grouped-list card blocks
    cardTheme: CardThemeData(
      elevation: 0,
      color: _cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _borderLight, width: 0.5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    ),

    // ── Buttons ─────────────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _teal600,
        foregroundColor: _white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _teal600,
        foregroundColor: _white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _teal600,
        side: const BorderSide(color: _teal600, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _teal600,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: _teal600,
        highlightColor: _teal50.withOpacity(0.5),
      ),
    ),

    // ── Switch (Toggle) ──────────────────────────────────────────────────────
    // Matches the teal toggles in the settings mockup
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return _white;
        return const Color(0xFFBDBDBD);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return _teal400;
        return const Color(0xFFE0E0E0);
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),

    // ── SnackBar ─────────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1A1D1A),
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
      backgroundColor: _cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    // ── Dialog ───────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: _cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titleTextStyle: const TextStyle(
        color: _textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      contentTextStyle: const TextStyle(
        color: _textSecondaryLight,
        fontSize: 15,
      ),
    ),

    // ── Chips ────────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: _teal50,
      selectedColor: _teal100,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _teal800,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: const BorderSide(color: _borderLight, width: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),

    // ── Divider ──────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: _dividerLight,
      thickness: 0.5,
      space: 0.5,
      indent: 56, // aligns with tile text (icon 34px + 12px gap + 10px padding)
    ),

    // ── ListTile ─────────────────────────────────────────────────────────────
    // Matches the settings mockup tile style exactly
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      minLeadingWidth: 0,
      iconColor: _teal600,
      titleTextStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _textPrimaryLight,
        letterSpacing: -0.1,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _textSecondaryLight,
      ),
    ),

    // ── Custom extension ──────────────────────────────────────────────────────
    extensions: const [
      AppColors(
        counterText: _teal600,
        progressActive: _teal400,
        progressTrack: _teal50,
        tapButtonFill: _teal600,
        tapButtonShadow: Color(0x260F6E56),
        cardBorder: _borderLight,
        subtleText: _textSecondaryLight,
        sectionHeaderBg: _surfaceLight,
        sectionLabelText: _textSecondaryLight,
        // Icon container backgrounds (light ramp 50)
        iconBgTeal: _teal50,
        iconBgPurple: _purple50,
        iconBgAmber: _amber50,
        iconBgBlue: _blue50,
        iconBgCoral: _coral50,
        iconBgPink: _pink50,
        iconBgGray: _gray50,
        iconBgGreen: _green50Palette,
        toggleActiveTrack: _teal400,
        destructiveColor: _destructiveLight,
      ),
    ],
  );

  // ── Dark Theme ─────────────────────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme(
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
      onSurface: _textPrimaryDark,
      onSurfaceVariant: _textSecondaryDark,
      error: _errorDark,
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
    ),

    scaffoldBackgroundColor: _surfaceDark,

    textTheme: _buildTextTheme(_textPrimaryDark, _textSecondaryDark),

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: Colors.transparent,
      foregroundColor: _textPrimaryDark,
      iconTheme: IconThemeData(color: _tealD400, size: 24),
      actionsIconTheme: IconThemeData(color: _tealD400, size: 24),
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: _textPrimaryDark,
        letterSpacing: -0.2,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: _cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _borderDark, width: 0.5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _tealD400,
        foregroundColor: _teal900,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _tealD400,
        foregroundColor: _teal900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _tealD400,
        side: const BorderSide(color: _tealD400, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _tealD400,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: _tealD400,
        highlightColor: _tealD400.withOpacity(0.15),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return _teal900;
        return const Color(0xFF9E9E9E);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return _tealD400;
        return _surfaceDark3;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return _borderDark;
      }),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: _surfaceDark3,
      contentTextStyle: const TextStyle(
        color: _textPrimaryDark,
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
      backgroundColor: _surfaceDark2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: _surfaceDark2,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titleTextStyle: const TextStyle(
        color: _textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      contentTextStyle: const TextStyle(
        color: _textSecondaryDark,
        fontSize: 15,
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _surfaceDark3,
      selectedColor: _teal800,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _tealD200,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: const BorderSide(color: _borderDark, width: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),

    dividerTheme: const DividerThemeData(
      color: _dividerDark,
      thickness: 0.5,
      space: 0.5,
      indent: 56,
    ),

    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      minLeadingWidth: 0,
      iconColor: _tealD400,
      titleTextStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _textPrimaryDark,
        letterSpacing: -0.1,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _textSecondaryDark,
      ),
    ),

    extensions: [
      AppColors(
        counterText: _tealD400,
        progressActive: _tealD400,
        progressTrack: _surfaceDark3,
        tapButtonFill: _tealD400,
        tapButtonShadow: _tealD400.withOpacity(0.25),
        cardBorder: _borderDark,
        subtleText: _textSecondaryDark,
        sectionHeaderBg: _surfaceDark,
        sectionLabelText: _textSecondaryDark,
        // Dark icon container backgrounds (dark ramp 800)
        iconBgTeal: _teal800bg,
        iconBgPurple: _purple800,
        iconBgAmber: _amber800,
        iconBgBlue: _blue800,
        iconBgCoral: _coral800,
        iconBgPink: _pink800,
        iconBgGray: _gray800,
        iconBgGreen: _green800,
        toggleActiveTrack: _tealD400,
        destructiveColor: _destructiveDark,
      ),
    ],
  );
}

// ─── Usage example for a settings tile icon container ─────────────────────────
//
// Widget _settingsIcon(BuildContext context, IconData icon, Color bg, Color fg) {
//   return Container(
//     width: 34,
//     height: 34,
//     decoration: BoxDecoration(
//       color: bg,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Icon(icon, color: fg, size: 18),
//   );
// }
//
// Example inside a ListTile:
//   leading: _settingsIcon(
//     context,
//     Icons.palette_outlined,
//     appColors.iconBgTeal,
//     AppIconColors.iconTeal,   // light  — or AppIconColors.iconTealDark for dark
//   ),
//
// ─── Retrieve extension anywhere ──────────────────────────────────────────────
//
// final appColors = Theme.of(context).extension<AppColors>()!;
