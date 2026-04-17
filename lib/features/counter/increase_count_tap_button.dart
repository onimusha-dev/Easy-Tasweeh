import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter_btn_style/counter_button_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncreaseCountTapButton extends ConsumerWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final PressButtonStyle? previewStyle;

  const IncreaseCountTapButton({
    super.key,
    required this.onTap,
    this.onTapDown,
    this.previewStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final activeStyle = previewStyle ?? settings.pressButtonStyle;

    switch (activeStyle) {
      case PressButtonStyle.first:
        return ClassicWavyStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.second:
        return ModernRingStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.third:
        return GlassSquareStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.tealCircular:
        return TealCircularStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.slateRounded:
        return SlateRoundedStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.amberGradient:
        return AmberGradientStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.purpleOutlined:
        return PurpleOutlinedStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.coralSoft:
        return CoralSoftStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.midnightGlass:
        return MidnightGlassStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.neonGlow:
        return NeonGlowStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.emeraldMinimal:
        return EmeraldMinimalStyle(onTap: onTap, onTapDown: onTapDown);
      case PressButtonStyle.royalGold:
        return RoyalGoldStyle(onTap: onTap, onTapDown: onTapDown);
    }
  }
}
