import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/screens/combo_selection_screen.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_background.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_button.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_progress.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_display.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_goal_sheet.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final settings = ref.watch(settingsProvider);
    final countAsync = ref.watch(currentCountStreamProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
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
      },
      child: CounterBackground(
        settings: settings,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const SideDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            actions: [
              IconButton(
                onPressed: _showLayoutDialog,
                icon: const Icon(Icons.swap_vert_rounded),
                tooltip: 'Swap Layout',
              ),
              IconButton(
                onPressed: _openComboScreen,
                icon: const Icon(Icons.view_carousel),
                tooltip: 'Dhikr Collection',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: countAsync.when(
            data: (countData) {
              final current = countData?.currentCount ?? 0;
              final target = countData?.targetCount ?? 33;
              final currentDhikr = ref.watch(currentDhikrProvider);

              final progress =
                  countData?.calculateProgress(settings.dhikr) ?? 0.0;

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!settings.centerButton) ...[
                              Column(
                                children: [
                                  CounterProgress(
                                    colorScheme: colorScheme,
                                    progress: progress,
                                    textTheme: textTheme,
                                    currentCountData: current,
                                    targetCount: target,
                                    settings: settings,
                                  ),
                                  const SizedBox(height: 16),
                                  DhikrDisplay(currentDhikr: currentDhikr),
                                ],
                              ),
                              SizedBox(
                                width: settings.buttonSize,
                                height: settings.buttonSize,
                                child: _getCounterStyle(
                                  settings.pressButtonStyle,
                                  _isFrozen
                                      ? null
                                      : () => _incrementCounter(countData),
                                ),
                              ),
                            ] else ...[
                              CounterProgress(
                                colorScheme: colorScheme,
                                progress: progress,
                                textTheme: textTheme,
                                currentCountData: current,
                                targetCount: target,
                                settings: settings,
                              ),
                              SizedBox(
                                width: settings.buttonSize,
                                height: settings.buttonSize,
                                child: _getCounterStyle(
                                  settings.pressButtonStyle,
                                  _isFrozen
                                      ? null
                                      : () => _incrementCounter(countData),
                                ),
                              ),
                              DhikrDisplay(currentDhikr: currentDhikr),
                            ],
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }

  Future<void> _incrementCounter(CurrentCountTableData? countData) async {
    if (_isFrozen) return;

    // Initial freeze to prevent double-taps
    setState(() => _isFrozen = true);

    // We will unfreeze after 100ms UNLESS we reach the target,
    // in which case the completion logic handles the unfreeze.
    final nextCount = (countData?.currentCount ?? 0) + 1;
    final target = countData?.targetCount ?? 0;
    final isTargetReached = target > 0 && nextCount >= target;

    if (!isTargetReached) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _isFrozen = false);
      });
    }

    final repo = ref.read(countRepositoryProvider);
    final settings = ref.read(settingsProvider);

    await repo.increment();

    // Milestone vibration
    if (settings.hapticEnabled &&
        settings.vibrateOnMilestone &&
        nextCount > 0 &&
        nextCount % settings.milestoneValue == 0 &&
        (target == 0 || nextCount < target)) {
      debugPrint('Triggering milestone haptics');
      HapticFeedback.mediumImpact();
      Vibration.vibrate(duration: 60);
    }

    if (target > 0 && nextCount >= target) {
      if (mounted) {
        await repo.saveAndReset();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Target reached! Session saved to history.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (settings.hapticEnabled) {
        debugPrint('Triggering completion haptics');
        // Playful vibration pattern: vibe 200, gap 100, vibe 200, gap 100, vibe 600
        const vibrationPattern = [0, 200, 100, 200, 100, 600];
        // Reduced intensities (0 for gaps, ~120-150 for vibes)
        const intensities = [0, 120, 0, 120, 0, 150];
        const totalDuration = 1200; // sum of pattern

        Vibration.vibrate(pattern: vibrationPattern, intensities: intensities);

        // Freeze the button for the duration of the playful vibration
        setState(() => _isFrozen = true);
        Future.delayed(const Duration(milliseconds: totalDuration), () {
          if (mounted) setState(() => _isFrozen = false);
        });
      }
    }
  }

  void _openComboScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComboSelectionScreen()),
    );
  }

  void _showLayoutDialog() {
    final settings = ref.read(settingsProvider);
    final isCentered = settings.centerButton;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Layout'),
        content: Text(
          isCentered
              ? 'Do you want to move the counter button to the bottom?'
              : 'Do you want to move the counter button to the middle?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(settingsProvider.notifier)
                  .updateCenterButtonTemporary(!isCentered);
              Navigator.pop(context);
            },
            child: const Text('SWITCH'),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _showSetTargetSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TargetGoalSheet(),
    );
  }

  Widget _getCounterStyle(PressButtonStyle style, VoidCallback? onTap) {
    return CounterButton(onTap: onTap, previewStyle: style);
  }
}
