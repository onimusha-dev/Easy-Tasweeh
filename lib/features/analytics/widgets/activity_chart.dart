import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityChart extends StatelessWidget {
  final Map<String, int> dailyTotals;

  const ActivityChart({super.key, required this.dailyTotals});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final chartData = dailyTotals.entries.toList().reversed.toList();
    final maxVal = dailyTotals.values.isEmpty
        ? 0
        : dailyTotals.values.reduce((a, b) => a > b ? a : b);

    return buildSettingsGroup(
      context,
      title: 'Weekly Activity',
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal.toDouble() * 1.3,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => colorScheme.surfaceContainerHigh,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}',
                        textTheme.titleMedium!.copyWith(
                          color: colorScheme.primary,
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
                        final date = DateFormat('yyyy-MM-dd').parse(dateStr);
                        final isToday =
                            DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
                            dateStr;

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('E').format(date).toUpperCase(),
                            style: textTheme.labelSmall?.copyWith(
                              color: isToday
                                  ? colorScheme.primary
                                  : colorScheme.outline.withValues(alpha: 0.5),
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
                      (maxVal / 4).clamp(1, double.infinity).toDouble(),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.1),
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
                            colorScheme.primary.withValues(alpha: 0.6),
                            colorScheme.primary,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 12,
                        borderRadius: BorderRadius.circular(20),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxVal.toDouble() * 1.3,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.05,
                          ),
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
    );
  }
}
