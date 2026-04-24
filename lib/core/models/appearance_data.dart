import 'package:easy_tasbeeh/core/service/settings_provider.dart';

// ── Backgrounds ─────────────────────────────────────────────────────────────

class BackgroundItem {
  final String name;
  final String path;

  const BackgroundItem({required this.name, required this.path});
}

const List<BackgroundItem> availableBackgrounds = [
  BackgroundItem(name: 'None', path: ''),
  BackgroundItem(name: 'Spiral Text', path: 'assets/images/bg/spiral-text.png'),
  BackgroundItem(name: 'Paper Mint', path: 'assets/images/bg/paper-mint.png'),
  BackgroundItem(name: 'Lamon', path: 'assets/images/bg/lamon.png'),
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
