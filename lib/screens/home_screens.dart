import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:easy_tasweeh/features/home/widgets/archive_dialog.dart';
import 'package:easy_tasweeh/features/home/widgets/counter_display.dart';
import 'package:easy_tasweeh/features/home/widgets/home_drawer.dart';
import 'package:easy_tasweeh/features/home/widgets/tactical_tap_button.dart';
import 'package:easy_tasweeh/features/home/widgets/target_selector_sheet.dart';
import 'package:easy_tasweeh/screens/analytics_screen.dart';
import 'package:easy_tasweeh/screens/history_screen.dart';
import 'package:easy_tasweeh/screens/settings_screen.dart';
import 'package:easy_tasweeh/screens/tasweeh_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure the counter session is initialized when the screen loads to show 0
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(countRepositoryProvider).getOrCreateCurrentCount();
    });
  }

  Future<void> _incrementCounter() async {
    HapticFeedback.vibrate();
    final repo = ref.read(countRepositoryProvider);
    // Directly increment; repo handles initialization if needed
    await repo.increment();

    final countData = await repo.getOrCreateCurrentCount();
    // Auto-save logic
    if (countData.targetCount > 0 &&
        countData.currentCount >= countData.targetCount) {
      await repo.saveAndReset();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Target reached! Session saved to history.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(
        onShowHistory: _showHistory,
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

          return Column(
            children: [
              const SizedBox(height: 40),
              const Spacer(flex: 1),
              CounterDisplay(current: current, target: target),
              const Spacer(flex: 2),
              TacticalTapButton(onTap: _incrementCounter),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _archiveSession,
                        icon: const Icon(Icons.archive_outlined),
                        label: const Text('Archive Session'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
