import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter/widgets/button_styles/counter_button_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

class CounterButton extends ConsumerStatefulWidget {
  final VoidCallback? onTap;
  final PressButtonStyle? previewStyle;

  const CounterButton({super.key, this.onTap, this.previewStyle});

  @override
  ConsumerState<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends ConsumerState<CounterButton>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  DateTime _lastTapTime = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;

    final settings = ref.read(settingsProvider);
    final now = DateTime.now();

    // Check for tap freeze
    if (settings.tapFreezeEnabled) {
      final difference = now.difference(_lastTapTime).inMilliseconds;
      if (difference < settings.tapFreezeDuration) {
        return; // Ignore tap if it's too soon
      }
    }

    _lastTapTime = now;

    // Trigger animation for the button styles that use it
    _rippleController.forward(from: 0.0);

    // Immediate Haptics for zero latency feel
    if (settings.hapticEnabled) {
      HapticFeedback.mediumImpact();
      Vibration.vibrate(duration: 25);
    }

    // Fire the actual tap callback
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final style = widget.previewStyle ?? settings.pressButtonStyle;

    return GestureDetector(
      onTapDown: _handleTapDown,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: _getButtonStyle(style),
      ),
    );
  }

  Widget _getButtonStyle(PressButtonStyle style) {
    switch (style) {
      case PressButtonStyle.classicWavy:
        return ClassicWavyStyle(rippleAnimation: _rippleController);
      case PressButtonStyle.midnightGlass:
        return MidnightGlassStyle(rippleAnimation: _rippleController);
      case PressButtonStyle.glowingBall:
        return GlowingBallStyle(rippleAnimation: _rippleController);
    }
  }
}
