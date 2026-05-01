import 'package:flutter/material.dart';

class AppLayout {
  // ─── Border Radii ──────────────────────────────────────────────────────────
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 24.0;
  static const double radiusSheet = 32.0;
  static const double radiusDialog = 24.0;
  static const double radiusFull = 100.0;

  static final BorderRadius brSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius brMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius brLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius brExtraLarge = BorderRadius.circular(radiusExtraLarge);
  static final BorderRadius brSheet = BorderRadius.vertical(top: Radius.circular(radiusSheet));
  static final BorderRadius brDialog = BorderRadius.circular(radiusDialog);
  static final BorderRadius brChip = BorderRadius.circular(8.0);

  // ─── Shapes ────────────────────────────────────────────────────────────────
  static final OutlinedBorder shapeSmall = RoundedRectangleBorder(borderRadius: brSmall);
  static final OutlinedBorder shapeMedium = RoundedRectangleBorder(borderRadius: brMedium);
  static final OutlinedBorder shapeLarge = RoundedRectangleBorder(borderRadius: brLarge);
  static final OutlinedBorder shapeExtraLarge = RoundedRectangleBorder(borderRadius: brExtraLarge);
  static final OutlinedBorder shapeChip = RoundedRectangleBorder(borderRadius: brChip);
  static final OutlinedBorder shapeSheet = RoundedRectangleBorder(borderRadius: brSheet);
  static final OutlinedBorder shapeDialog = RoundedRectangleBorder(borderRadius: brDialog);

  // ─── Padding & Margins ──────────────────────────────────────────────────────
  static const double spaceXS = 4.0;
  static const double spaceTileGap = 4.0;
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 12.0; // Standard card padding
  static const double spaceLarge = 16.0; // Standard screen padding
  static const double spaceXL = 24.0;
  static const double spaceXXL = 32.0;

  // Common edge insets
  static const EdgeInsets screenPadding = EdgeInsets.all(spaceLarge);
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceMedium);
  static const EdgeInsets sheetPadding = EdgeInsets.fromLTRB(spaceLarge, spaceMedium, spaceLarge, spaceLarge);
  
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spaceXL,
    vertical: spaceLarge,
  );
  
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(
    horizontal: spaceMedium,
    vertical: 4.0,
  );
  
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 10.0,
    vertical: 6.0,
  );

  // ─── Border & Dividers ──────────────────────────────────────────────────────
  static const double borderWidth = 1.0;
  static const double borderOpacity = 0.1;
  static const double dividerIndent = 56.0;

  // ─── Icon Sizes ─────────────────────────────────────────────────────────────
  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 22.0;
  static const double iconSizeLarge = 28.0;
  static const double iconContainerSize = 44.0;
}
