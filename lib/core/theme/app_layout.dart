import 'package:flutter/material.dart';

class AppLayout {
  // ─── Border Radii ──────────────────────────────────────────────────────────
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 10.0;
  static const double radiusExtraLarge = 12.0;
  static const double radiusFull = 100.0;

  static final BorderRadius brSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius brMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius brLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius brExtraLarge = BorderRadius.circular(radiusExtraLarge);
  static final BorderRadius brChip = BorderRadius.circular(8.0);

  // ─── Shapes ────────────────────────────────────────────────────────────────
  static final OutlinedBorder shapeSmall = RoundedRectangleBorder(borderRadius: brSmall);
  static final OutlinedBorder shapeMedium = RoundedRectangleBorder(borderRadius: brMedium);
  static final OutlinedBorder shapeLarge = RoundedRectangleBorder(borderRadius: brLarge);
  static final OutlinedBorder shapeExtraLarge = RoundedRectangleBorder(borderRadius: brExtraLarge);
  static final OutlinedBorder shapeChip = RoundedRectangleBorder(borderRadius: brChip);

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
