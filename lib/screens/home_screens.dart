import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:easy_tasweeh/database/repository/count_repository.dart';

import 'package:easy_tasweeh/features/home/widgets/archive_dialog.dart';
import 'package:easy_tasweeh/features/home/widgets/counter_display.dart';
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
        title: Text(
          'Easy Tasweeh',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
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
      body: StreamBuilder(
        stream: ref.watch(countRepositoryProvider).watchCurrentCount(),
        builder: (context, snapshot) {
          final countData = snapshot.data;
          final current = countData?.currentCount ?? 0;
          final target = countData?.targetCount ?? 0;

          return SizedBox.expand(
            child: Column(
              children: [
                const Spacer(flex: 1),
                const Spacer(flex: 1),
                CounterDisplay(current: current, target: target),
                const Spacer(flex: 1),
                TacticalTapButton(
                  onTap: _isFrozen ? null : () => _incrementCounter(countData),
                ),
                const Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _incrementCounter(CurrentCountTableData? countData) async {
    if (_isFrozen) return;

    // Freeze button for 1 sec, no rush inshallah
    setState(() => _isFrozen = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _isFrozen = false);
    });

    final repo = ref.read(countRepositoryProvider);
    final hapticEnabled = ref.read(settingsProvider).hapticEnabled;

    // Medium vibration on every count
    if (hapticEnabled) {
      Vibration.vibrate(duration: 50, amplitude: 50);
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
    Vibration.vibrate(duration: 2000, amplitude: 100);
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
      backgroundColor: Colors.transparent,
      builder: (context) => const TargetSelectorSheet(),
    );
  }
}
