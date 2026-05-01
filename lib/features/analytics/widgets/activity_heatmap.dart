import 'package:easy_tasbeeh/core/widgets/app_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityHeatmap extends StatelessWidget {
  final Map<String, int> dailyTotals;

  const ActivityHeatmap({super.key, required this.dailyTotals});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final maxVal = dailyTotals.values.isEmpty
        ? 1
        : dailyTotals.values.reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate how many weeks can fit in the available width
        // Labels (20) + padding (12) ~ 40px total margin for labels
        const labelAreaWidth = 40.0;
        const weekColumnWidth =
            24.0; // 20px block + 4px horizontal gap estimation

        final availableWidth = constraints.maxWidth - labelAreaWidth;
        final numWeeks = (availableWidth / weekColumnWidth).floor().clamp(
          1,
          20,
        );

        // Calculate the start date based on numWeeks
        int daysToMonday = today.weekday - 1;
        DateTime firstMonday = today.subtract(
          Duration(days: daysToMonday + (numWeeks - 1) * 7),
        );

        // Calculate total count for the displayed period
        int totalInPeriod = 0;
        for (int w = 0; w < numWeeks; w++) {
          for (int d = 0; d < 7; d++) {
            final date = firstMonday.add(Duration(days: w * 7 + d));
            final dateKey = DateFormat('yyyy-MM-dd').format(date);
            totalInPeriod += dailyTotals[dateKey] ?? 0;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const AppSectionTitle(
                  title: 'Commit History',
                  isLarge: true,
                ),
                Text(
                  '$totalInPeriod Sessions',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weekday labels
                Column(
                  children: daysOfWeek
                      .map(
                        (day) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: Text(
                                day,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 12),
                // The Grid
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(numWeeks, (weekIndex) {
                      return Column(
                        children: List.generate(7, (dayIndex) {
                          final date = firstMonday.add(
                            Duration(days: weekIndex * 7 + dayIndex),
                          );
                          final dateKey = DateFormat('yyyy-MM-dd').format(date);
                          final count = dailyTotals[dateKey] ?? 0;
                          final isFuture = date.isAfter(today);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: _HeatmapBlock(
                              count: count,
                              maxCount: maxVal,
                              isFuture: isFuture,
                              isToday:
                                  dateKey ==
                                  DateFormat('yyyy-MM-dd').format(today),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Less',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                const _HeatmapBlock(count: 0, maxCount: 100),
                const SizedBox(width: 4),
                const _HeatmapBlock(count: 25, maxCount: 100),
                const SizedBox(width: 4),
                const _HeatmapBlock(count: 50, maxCount: 100),
                const SizedBox(width: 4),
                const _HeatmapBlock(count: 75, maxCount: 100),
                const SizedBox(width: 4),
                const _HeatmapBlock(count: 100, maxCount: 100),
                const SizedBox(width: 8),
                Text(
                  'More',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _HeatmapBlock extends StatelessWidget {
  final int count;
  final int maxCount;
  final bool isFuture;
  final bool isToday;

  const _HeatmapBlock({
    required this.count,
    required this.maxCount,
    this.isFuture = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color color;
    if (isFuture) {
      color = Colors.transparent;
    } else if (count == 0) {
      // Dark blackish color for inactive days
      color = Colors.black.withValues(alpha: 0.3);
    } else {
      final intensity = (count / maxCount).clamp(0.2, 1.0);
      color = colorScheme.primary.withValues(alpha: intensity);
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
