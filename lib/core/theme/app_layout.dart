import 'package:flutter/material.dart';

class AppLayout {
  // ─── Border Radii ──────────────────────────────────────────────────────────
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 14.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 28.0;
  static const double radiusFull = 100.0;

  static final BorderRadius brSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius brMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius brLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius brExtraLarge = BorderRadius.circular(radiusExtraLarge);
  static final BorderRadius brChip = BorderRadius.circular(20.0);

  // ─── Padding & Margins ──────────────────────────────────────────────────────
  static const double spaceXS = 4.0;
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 16.0;
  static const double spaceLarge = 24.0;
  static const double spaceXL = 32.0;

  // Common edge insets
  static const EdgeInsets pagePadding = EdgeInsets.all(spaceMedium);
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceMedium);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spaceLarge,
    vertical: spaceMedium,
  );
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(
    horizontal: spaceMedium,
    vertical: 2.0,
  );
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 10.0,
    vertical: 6.0,
  );

  // ─── Component Specifics ────────────────────────────────────────────────────
  static const double dividerIndent = 56.0;
  static const double iconSizeMedium = 24.0;
  static const double iconContainerSize = 34.0;
  static const double iconInnerSize = 18.0;
}
