import 'package:easy_tasbeeh/core/service/settings_provider.dart';

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
];

// ── Button Styles ───────────────────────────────────────────────────────────

class ButtonStyleItem {
  final String name;
  final PressButtonStyle style;

  const ButtonStyleItem({required this.name, required this.style});
}

const List<ButtonStyleItem> availableButtonStyles = [
  ButtonStyleItem(name: 'Classic Wavy', style: PressButtonStyle.classicWavy),
  ButtonStyleItem(
    name: 'Midnight Glass',
    style: PressButtonStyle.midnightGlass,
  ),
  ButtonStyleItem(name: 'Glowing Ball', style: PressButtonStyle.glowingBall),
];
