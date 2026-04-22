import 'package:easy_tasweeh/core/service/settings_provider.dart';

// ── Backgrounds ─────────────────────────────────────────────────────────────

class BackgroundItem {
  final String name;
  final String path;

  const BackgroundItem({required this.name, required this.path});
}

const List<BackgroundItem> availableBackgrounds = [
  BackgroundItem(name: 'None', path: ''),
  BackgroundItem(name: 'Ocean Mist', path: 'assets/images/bg/bg-1.png'),
  BackgroundItem(name: 'Emerald Forest', path: 'assets/images/bg/bg-2.png'),
  BackgroundItem(name: 'Dusk Rose', path: 'assets/images/bg/bg-3.png'),
  BackgroundItem(name: 'Manhattan', path: 'assets/images/bg/bg-4.png'),
  BackgroundItem(name: 'Firecracker', path: 'assets/images/bg/bg-5.png'),
  BackgroundItem(name: 'Firecracker', path: 'assets/images/bg/bg-5.png'),
];

// ── Button Styles ───────────────────────────────────────────────────────────

class ButtonStyleItem {
  final String name;
  final PressButtonStyle style;

  const ButtonStyleItem({required this.name, required this.style});
}

const List<ButtonStyleItem> availableButtonStyles = [
  ButtonStyleItem(name: 'Classic Wavy', style: PressButtonStyle.first),
  ButtonStyleItem(name: 'Modern Ring', style: PressButtonStyle.second),
  ButtonStyleItem(name: 'Glass Square', style: PressButtonStyle.third),
  ButtonStyleItem(name: 'Teal Circular', style: PressButtonStyle.tealCircular),
  ButtonStyleItem(name: 'Slate Rounded', style: PressButtonStyle.slateRounded),
  ButtonStyleItem(
    name: 'Amber Gradient',
    style: PressButtonStyle.amberGradient,
  ),
  ButtonStyleItem(
    name: 'Purple Outlined',
    style: PressButtonStyle.purpleOutlined,
  ),
  ButtonStyleItem(name: 'Coral Soft', style: PressButtonStyle.coralSoft),
  ButtonStyleItem(
    name: 'Midnight Glass',
    style: PressButtonStyle.midnightGlass,
  ),
  ButtonStyleItem(name: 'Neon Glow', style: PressButtonStyle.neonGlow),
  ButtonStyleItem(
    name: 'Emerald Minimal',
    style: PressButtonStyle.emeraldMinimal,
  ),
  ButtonStyleItem(name: 'Royal Gold', style: PressButtonStyle.royalGold),
];
