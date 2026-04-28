import 'package:easy_tasbeeh/database/db.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/analytics/widgets/activity_heatmap.dart';
import 'package:easy_tasbeeh/features/analytics/widgets/weekly_activity_bar.dart';
import 'package:easy_tasbeeh/features/history/screens/history_screen.dart';
import 'package:easy_tasbeeh/features/history/widgets/history_item_card.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(countRepositoryProvider).watchAllHistory();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: StreamBuilder<List<CountHistoryTableData>>(
        stream: historyAsync,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data!;
          if (history.isEmpty) {
            return const _EmptyAnalyticsView();
          }

          // Calculate statistics
          final stats = _calculateStats(history);

          return ListView(
            children: [
              WeeklyActivityBar(dailyTotals: stats.dailyTotals),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ActivityHeatmap(dailyTotals: stats.dailyTotals),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: buildSettingSectionTitle(
                  context,
                  'Recent Activity',
                  isLarge: true,
                ),
              ),
              ...history
                  .take(5)
                  .indexed
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HistoryItemCard(
                        data: entry.$2,
                        index: entry.$1,
                        isLast: entry.$1 == 4 || entry.$1 == history.length - 1,
                      ),
                    ),
                  ),
              if (history.length > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistoryScreen(),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.05),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Move to History',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  _AnalyticsStats _calculateStats(List<CountHistoryTableData> history) {
    int totalCount = 0;
    int totalSessions = history.length;
    int maxSession = 0;

    Map<String, int> dailyTotals = {};
    final now = DateTime.now();
    for (int i = 0; i < 35; i++) {
      // Covering ~5 weeks
      final date = now.subtract(Duration(days: i));
      dailyTotals[DateFormat('yyyy-MM-dd').format(date)] = 0;
    }

    for (var record in history) {
      totalCount += record.currentCount;
      if (record.currentCount > maxSession) {
        maxSession = record.currentCount;
      }

      final dateKey = DateFormat('yyyy-MM-dd').format(record.createdAt);
      if (dailyTotals.containsKey(dateKey)) {
        dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + 1;
      }
    }

    return _AnalyticsStats(
      totalCount: totalCount,
      totalSessions: totalSessions,
      maxSession: maxSession,
      dailyTotals: dailyTotals,
    );
  }
}

class _AnalyticsStats {
  final int totalCount;
  final int totalSessions;
  final int maxSession;
  final Map<String, int> dailyTotals;

  _AnalyticsStats({
    required this.totalCount,
    required this.totalSessions,
    required this.maxSession,
    required this.dailyTotals,
  });
}

class _EmptyAnalyticsView extends StatelessWidget {
  const _EmptyAnalyticsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insights_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No data yet. Keep counting!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
