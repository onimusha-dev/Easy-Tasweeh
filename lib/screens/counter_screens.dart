import 'package:easy_tasweeh/core/service/dhikr_service.dart';
import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:easy_tasweeh/features/home/widgets/archive_dialog.dart';
import 'package:easy_tasweeh/features/home/widgets/home_drawer.dart';
import 'package:easy_tasweeh/features/home/widgets/tactical_tap_button.dart';
import 'package:easy_tasweeh/features/home/widgets/target_selector_sheet.dart';
import 'package:easy_tasweeh/screens/analytics_screen.dart';
import 'package:easy_tasweeh/screens/challenges_screen.dart';
import 'package:easy_tasweeh/screens/history_screen.dart';
import 'package:easy_tasweeh/screens/settings_screen.dart';
import 'package:easy_tasweeh/screens/tasweeh_screen.dart';
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

    return Scaffold(
      drawer: HomeDrawer(
        onShowHistory: _showHistory,
        onShowChallenges: _showChallenges,
        onShowAnalytics: _showAnalytics,
        onShowTasweeh: _showTasweeh,
        onShowSettings: _showSettings,
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        // title: Text(
        //   'Easy Tasweeh',
        //   style: Theme.of(context).textTheme.titleMedium,
        // ),
        actions: [
          IconButton(
            onPressed: _archiveSession,
            icon: const Icon(Icons.archive_outlined),
            tooltip: 'Archive Session',
          ),
          IconButton(
            onPressed: _showSetTargetSheet,
            icon: const Icon(Icons.gps_fixed_rounded),
            tooltip: 'Set Target',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ref
          .watch(currentCountStreamProvider)
          .when(
            data: (countData) {
              final current = countData?.currentCount ?? 0;
              final target = countData?.targetCount ?? 0;
              final currentDhikr = ref.watch(currentDhikrProvider);
              final progress = target > 0
                  ? (current / target).clamp(0.0, 1.0)
                  : 0.0;
              final percentage = (progress * 100).toInt();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Progress',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$percentage% to complete',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress == 0 ? 0.01 : progress,
                            minHeight: 12,
                            backgroundColor: colorScheme.outlineVariant
                                .withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 2),

                    // Dhikr Display
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.05),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: ValueKey(currentDhikr.arabic),
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  currentDhikr.arabic,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48,
                                    color: colorScheme.onSurface,
                                    height: 1.4,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentDhikr.transliteration,
                                textAlign: TextAlign.center,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.onSurface,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  '"${currentDhikr.translation}"',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.outline,
                                    fontStyle: FontStyle.italic,
                                    height: 1.3,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Phase dots indicator (dynamic based on current dhikr in list)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0
                                ? colorScheme.outline
                                : colorScheme.outlineVariant.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                        );
                      }),
                    ),

                    const Spacer(flex: 4),

                    // The Big Button
                    TacticalTapButton(
                      onTap: _isFrozen
                          ? null
                          : () => _incrementCounter(countData),
                    ),

                    const Spacer(flex: 2),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
    );
  }

  Future<void> _incrementCounter(CurrentCountTableData? countData) async {
    if (_isFrozen) return;

    // Freeze button for 1 sec, no rush inshallah
    setState(() => _isFrozen = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isFrozen = false);
    });

    final repo = ref.read(countRepositoryProvider);
    final hapticEnabled = ref.read(settingsProvider).hapticEnabled;

    // Medium vibration on every count
    if (hapticEnabled) {
      final amplitude = ref.read(settingsProvider).vibrationAmplitude;
      Vibration.vibrate(duration: 50, amplitude: amplitude);
    }

    // Directly increment; repo handles initialization if needed
    await repo.increment();

    final nextCount = (countData?.currentCount ?? 0) + 1;
    final target = countData?.targetCount ?? 0;

    // Auto-save logic
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
      // Completion vibration on target reached
      if (hapticEnabled) {
        _playCompletionVibration();
      }
    }
  }

  /// Plays a gentle affirmative vibration on target completion.
  void _playCompletionVibration() {
    final amplitude = ref.read(settingsProvider).completionVibrationAmplitude;
    Vibration.vibrate(duration: 2000, amplitude: amplitude);
  }

  void _archiveSession() {
    showDialog(context: context, builder: (context) => const ArchiveDialog());
  }

  void _showHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  void _showAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
    );
  }

  void _showChallenges() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChallengesScreen()),
    );
  }

  void _showTasweeh() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TasweehScreen()),
    );
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
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
}
