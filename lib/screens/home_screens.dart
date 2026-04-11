import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:easy_tasweeh/screens/analytics_screen.dart';
import 'package:easy_tasweeh/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  // this function is not used but this will be used in future
  //   void _resetCounter() {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Reset Counter'),
  //           content: const Text('Are you sure you want to reset the counter?'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('Cancel'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 ref.read(countRepositoryProvider).reset();
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('Reset'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }

  void _archiveSession() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Archive Session'),
          content: const Text(
            'Do you want to save this session to history and reset the counter?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(countRepositoryProvider).saveAndReset();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session archived successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('ARCHIVE'),
            ),
          ],
        );
      },
    );
  }

  // NOTE: This function is not used, but it is here for future use.
  //   void _saveToHistory() {
  //     ref.read(countRepositoryProvider).saveAndReset();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Session saved to history'),
  //         behavior: SnackBarBehavior.floating,
  //       ),
  //     );
  //   }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EASY TASWEEH',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAnalytics,
            icon: const Icon(Icons.graphic_eq_rounded),
            tooltip: 'Analytics',
          ),
          IconButton(
            onPressed: () {
              _showSetTargetSheet();
            },
            icon: const Icon(Icons.gps_fixed_rounded),
            tooltip: 'Set Target',
          ),
          IconButton(
            onPressed: _showHistory,
            icon: const Icon(Icons.history_toggle_off_rounded),
            tooltip: 'History',
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

          // Dot logic: If there's a target and current is 0, show a tiny segment (looks like a dot)
          // Otherwise show the actual progress.
          final displayProgress = target > 0
              ? (current == 0 ? 0.001 : (current / target).clamp(0.0, 1.0))
              : 0.0;

          return Column(
            children: [
              const SizedBox(height: 40),
              const Spacer(flex: 1),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: CircularProgressIndicator(
                      value: displayProgress,
                      strokeWidth: 4,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                            '$current',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w900,
                                ),
                          )
                          .animate(key: ValueKey(current))
                          .scale(
                            duration: 150.ms,
                            curve: Curves.easeOutBack,
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1, 1),
                          ),
                      if (target > 0)
                        Text(
                          'OF $target',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
              const Spacer(flex: 2),

              // Tactical Tap Button
              GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _incrementCounter,
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary.withValues(alpha: 0.1),
                          width: 10,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.fingerprint_rounded,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 50,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'PRESS',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .animate(autoPlay: false)
                  .scale(
                    duration: 40.ms,
                    begin: const Offset(1, 1),
                    end: const Offset(0.96, 0.96),
                  ),

              const Spacer(flex: 1),

              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _archiveSession,
                        icon: const Icon(Icons.archive_outlined),
                        label: const Text('ARCHIVE SESSION'),
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

  void _showSetTargetSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final List<int> targets = [100, 200, 300, 500, 700, 1000];
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Select Goal',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: targets.length,
                itemBuilder: (context, index) {
                  final target = targets[index];
                  return InkWell(
                    onTap: () {
                      ref.read(countRepositoryProvider).setTarget(target);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '$target',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    ref.read(countRepositoryProvider).setTarget(0);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('No Target / Free Mode'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
