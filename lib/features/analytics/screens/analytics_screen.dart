import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:fl_chart/fl_chart.dart';
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
      body: StreamBuilder(
        stream: historyAsync,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data!;
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
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

          // Calculate statistics
          int totalCount = 0;
          int totalSessions = history.length;
          int maxSession = 0;

          Map<String, int> dailyTotals = {};
          final now = DateTime.now();
          for (int i = 0; i < 7; i++) {
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
              dailyTotals[dateKey] =
                  (dailyTotals[dateKey] ?? 0) + record.currentCount;
            }
          }

          final chartData = dailyTotals.entries.toList().reversed.toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Summary Section
              buildSettingsGroup(
                context,
                title: 'SUMMARY',
                children: [
                  buildSettingTile(
                    context,
                    icon: Icons.auto_graph_rounded,
                    title: 'Total sessions',
                    subtitle: 'Sessions completed',
                    iconColor: Theme.of(context).colorScheme.primary,
                    trailingLabel: '$totalSessions',
                  ),
                  buildSettingTile(
                    context,
                    icon: Icons.star_rounded,
                    title: 'Best session',
                    subtitle: 'Single highest count',
                    iconColor: Colors.amber,
                    trailingLabel: '$maxSession',
                  ),
                  buildSettingTile(
                    context,
                    icon: Icons.functions_rounded,
                    title: 'Total count',
                    subtitle: 'Lifetime tasbeeh count',
                    iconColor: Colors.orange,
                    trailingLabel: '$totalCount',
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // Activity Section
              buildSettingsGroup(
                context,
                title: 'WEEKLY ACTIVITY',
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: SizedBox(
                      height: 240,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY:
                              dailyTotals.values
                                  .reduce((a, b) => a > b ? a : b)
                                  .toDouble() *
                              1.3,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHigh,
                              //   tooltipRoundedRadius: 12,
                              tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              tooltipMargin: 8,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      '${rod.toY.toInt()}',
                                      Theme.of(
                                        context,
                                      ).textTheme.titleSmall!.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() < 0 ||
                                      value.toInt() >= chartData.length) {
                                    return const SizedBox();
                                  }
                                  final dateStr = chartData[value.toInt()].key;
                                  final date = DateFormat(
                                    'yyyy-MM-dd',
                                  ).parse(dateStr);
                                  final isToday =
                                      DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(DateTime.now()) ==
                                      dateStr;

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      DateFormat(
                                        'E',
                                      ).format(date).toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontSize: 9,
                                            fontWeight: isToday
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isToday
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.primary
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .outline
                                                      .withValues(alpha: 0.5),
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval:
                                (dailyTotals.values.reduce(
                                          (a, b) => a > b ? a : b,
                                        ) /
                                        4)
                                    .clamp(1, double.infinity),
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withValues(alpha: 0.1),
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(chartData.length, (index) {
                            final value = chartData[index].value.toDouble();
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: value,
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.6),
                                      Theme.of(context).colorScheme.primary,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 12,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ), // Pill shape
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY:
                                        dailyTotals.values
                                            .reduce((a, b) => a > b ? a : b)
                                            .toDouble() *
                                        1.3,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant
                                        .withValues(alpha: 0.05),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
