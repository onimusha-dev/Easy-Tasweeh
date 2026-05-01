import 'package:easy_tasbeeh/core/theme/app_layout.dart';
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

          final stats = _calculateStats(history);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              WeeklyActivityBar(dailyTotals: stats.dailyTotals),
              const SizedBox(height: 16),
              ActivityHeatmap(dailyTotals: stats.dailyTotals),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Recent Activity'),
              ...history
                  .take(6)
                  .indexed
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: AppLayout.spaceTileGap),
                      child: HistoryItemCard(data: entry.$2, index: entry.$1),
                    ),
                  ),
              if (history.length > 6) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _navigateToHistory(context),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('See More'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
  }

  _AnalyticsStats _calculateStats(List<CountHistoryTableData> history) {
    Map<String, int> dailyTotals = {};
    final now = DateTime.now();
    for (int i = 0; i < 35; i++) {
      final date = now.subtract(Duration(days: i));
      dailyTotals[DateFormat('yyyy-MM-dd').format(date)] = 0;
    }

    for (var record in history) {
      final dateKey = DateFormat('yyyy-MM-dd').format(record.createdAt);
      if (dailyTotals.containsKey(dateKey)) {
        dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + 1;
      }
    }

    return _AnalyticsStats(dailyTotals: dailyTotals);
  }
}

class _AnalyticsStats {
  final Map<String, int> dailyTotals;
  _AnalyticsStats({required this.dailyTotals});
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: buildSettingSectionTitle(context, title, isLarge: true),
    );
  }
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
