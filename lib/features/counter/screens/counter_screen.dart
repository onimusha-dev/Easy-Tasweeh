import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/core/models/counter_models.dart';
import 'package:easy_tasbeeh/features/counter/providers/counter_provider.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_app_bar.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_background.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_layout.dart';
import 'package:easy_tasbeeh/features/left_menu_bar/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

class CounterScreen extends ConsumerStatefulWidget {
  const CounterScreen({super.key});

  @override
  ConsumerState<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends ConsumerState<CounterScreen> {
  bool _isFrozen = false;
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final countAsync = ref.watch(counterProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handlePop,
      child: CounterBackground(
        settings: settings,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const SideDrawer(),
          appBar: CounterAppBar(onShowLayoutDialog: _showLayoutDialog),
          body: countAsync.when(
            data: (countData) {
              final current = countData?.currentCount ?? 0;
              final target = countData?.targetCount ?? 33;
              final currentDhikr = ref.watch(currentDhikrProvider);
              final progress =
                  countData?.calculateProgress(settings.dhikr) ?? 0.0;

              return CounterLayout(
                settings: settings,
                current: current,
                target: target,
                progress: progress,
                currentDhikr: currentDhikr,
                onIncrement: _isFrozen
                    ? null
                    : () => _incrementCounter(countData),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }

  void _handlePop(bool didPop, dynamic result) {
    if (didPop) return;

    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasExpired =
        _lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarHasExpired) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }

  Future<void> _incrementCounter(CounterSession? countData) async {
    if (_isFrozen) return;

    setState(() => _isFrozen = true);

    final notifier = ref.read(counterProvider.notifier);
    final settings = ref.read(settingsProvider);

    final updatedSession = await notifier.increment();
    if (updatedSession == null) {
      if (mounted) setState(() => _isFrozen = false);
      return;
    }

    final nextCount = updatedSession.currentCount;
    final target = updatedSession.targetCount;
    final isTargetReached = target > 0 && nextCount >= target;

    if (!isTargetReached) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _isFrozen = false);
      });
    }

    // 1. Combo Segment Milestone Vibration
    if (settings.activeComboIndex >= 0 &&
        settings.activeComboIndex < settings.comboPresets.length) {
      final preset = settings.comboPresets[settings.activeComboIndex];
      int cumulative = 0;
      bool isSegmentFinished = false;

      for (int i = 0; i < preset.counts.length - 1; i++) {
        cumulative += preset.counts[i];
        if (nextCount == cumulative) {
          isSegmentFinished = true;
          break;
        }
      }

      if (isSegmentFinished && settings.hapticEnabled) {
        HapticFeedback.mediumImpact();
        Vibration.vibrate(duration: 150); // Distinct vibration for segment finish
      }
    }

    // 2. Regular Milestone vibration
    if (settings.hapticEnabled &&
        settings.vibrateOnMilestone &&
        nextCount > 0 &&
        nextCount % settings.milestoneValue == 0 &&
        (!isTargetReached)) {
      HapticFeedback.mediumImpact();
      Vibration.vibrate(duration: 60);
    }

    // 3. Final Target Reached
    if (isTargetReached) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Target reached! Session saved to history.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (settings.hapticEnabled) {
        const vibrationPattern = [0, 200, 100, 200, 100, 600];
        const intensities = [0, 120, 0, 120, 0, 150];
        const totalDuration = 1200;

        Vibration.vibrate(pattern: vibrationPattern, intensities: intensities);

        setState(() => _isFrozen = true);
        Future.delayed(const Duration(milliseconds: totalDuration), () {
          if (mounted) setState(() => _isFrozen = false);
        });
      }
    }
  }

  void _showLayoutDialog() {
    final settings = ref.read(settingsProvider);
    final isCentered = settings.centerButton;

    showDialog(
      context: context,
      builder: (context) => PremiumDialog(
        icon: Icons.dashboard_customize_rounded,
        title: 'Change Layout',
        description: isCentered
            ? 'Do you want to move the counter button to the bottom?'
            : 'Do you want to move the counter button to the middle?',
        confirmLabel: 'Switch',
        onConfirm: () {
          ref
              .read(settingsProvider.notifier)
              .updateCenterButtonTemporary(!isCentered);
        },
      ),
    );
  }
}
