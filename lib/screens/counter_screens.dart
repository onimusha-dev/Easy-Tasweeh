import 'package:easy_tasweeh/core/service/dhikr_service.dart';
import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:easy_tasweeh/features/counter/counter_progress_widget.dart';
import 'package:easy_tasweeh/features/counter/display_selected_dhikr_widget.dart';
import 'package:easy_tasweeh/features/counter/increase_count_tap_button.dart';
import 'package:easy_tasweeh/features/counter/set_count_target/target_selector_sheet.dart';
import 'package:easy_tasweeh/features/left_menu_bar/left_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isFrozen = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final settings = ref.watch(settingsProvider);
    final countAsync = ref.watch(currentCountStreamProvider);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(settings.background),
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: settings.backgroundOpacity),
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const LeftMenuBar(),
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
              onPressed: _showSetTargetSheet,
              icon: const Icon(Icons.gps_fixed_rounded),
              tooltip: 'Set Target',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: countAsync.when(
          data: (countData) {
            final current = countData?.currentCount ?? 0;
            final target = countData?.targetCount ?? 0;
            final currentDhikr = ref.watch(currentDhikrProvider);
            final progress = target > 0
                ? (current / target).clamp(0.0, 1.0)
                : 0.0;
            final percentage = (progress * 100).toInt();

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        // vertical: 20.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CounterProgressWidget(
                            colorScheme: colorScheme,
                            percentage: percentage,
                            progress: progress,
                            textTheme: textTheme,
                          ),

                          const SizedBox(height: 32),

                          DisplaySelectedDhikrWidget(
                            currentDhikr: currentDhikr,
                          ),

                          IncreaseCountTapButton(
                            onTap: _isFrozen
                                ? null
                                : () => _incrementCounter(countData),
                          ),

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
    );
  }

  Future<void> _incrementCounter(CurrentCountTableData? countData) async {
    if (_isFrozen) return;

    setState(() => _isFrozen = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isFrozen = false);
    });

    final repo = ref.read(countRepositoryProvider);
    final hapticEnabled = ref.read(settingsProvider).hapticEnabled;

    if (hapticEnabled) {
      final amplitude = ref.read(settingsProvider).vibrationAmplitude;
      Vibration.vibrate(duration: 50, amplitude: amplitude);
    }

    await repo.increment();

    final nextCount = (countData?.currentCount ?? 0) + 1;
    final target = countData?.targetCount ?? 0;
    final settings = ref.read(settingsProvider);

    // Milestone vibration
    if (settings.vibrateOnMilestone &&
        nextCount > 0 &&
        nextCount % settings.milestoneValue == 0 &&
        (target == 0 || nextCount < target)) {
      Vibration.vibrate(duration: 150, amplitude: settings.vibrationAmplitude);
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
      if (hapticEnabled) {
        _playCompletionVibration();
      }
    }
  }

  void _playCompletionVibration() {
    final amplitude = ref.read(settingsProvider).completionVibrationAmplitude;
    Vibration.vibrate(duration: 2000, amplitude: amplitude);
  }

  void _showSetTargetSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TargetSelectorSheet(),
    );
  }

  String _getBackground() {
    return 'assets/images/bg/bg-1.png';
  }
}
