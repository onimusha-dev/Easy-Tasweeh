import 'package:easy_tasbeeh/core/service/settings_provider.dart';

// ── Backgrounds ─────────────────────────────────────────────────────────────

class BackgroundItem {
  final String name;
  final String path;

  const BackgroundItem({required this.name, required this.path});
}

const List<BackgroundItem> availableBackgrounds = [
  BackgroundItem(name: 'None', path: ''),
  BackgroundItem(
    name: 'Whisper Light',
    path: 'assets/images/bg/whisper-light.png',
  ),
  BackgroundItem(
    name: 'Whisper Dark',
    path: 'assets/images/bg/whisper-dark.png',
  ),
  BackgroundItem(name: 'Lamon', path: 'assets/images/bg/lamon.png'),
  BackgroundItem(name: 'Paper Mint', path: 'assets/images/bg/paper-mint.png'),
  BackgroundItem(
    name: 'Journey to Allah',
    path: 'assets/images/bg/journey-to-allah.png',
  ),
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
