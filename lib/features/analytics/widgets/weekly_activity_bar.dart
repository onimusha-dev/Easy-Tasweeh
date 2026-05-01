import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyActivityBar extends StatelessWidget {
  final Map<String, int> dailyTotals;

  const WeeklyActivityBar({super.key, required this.dailyTotals});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get current week dates (Sun to Sat)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday % 7));

    final days = List.generate(7, (index) {
      final date = firstDayOfWeek.add(Duration(days: index));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final count = dailyTotals[dateKey] ?? 0;
      final isToday =
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;

      return _DayItem(
        label: _getDayLabel(index),
        count: count,
        isToday: isToday,
        isPast: date.isBefore(today),
      );
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Activity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sessions completed this week',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('MMMM').format(now),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days,
          ),
        ],
      ),
    );
  }

  String _getDayLabel(int index) {
    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return labels[index];
  }
}

class _DayItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isToday;
  final bool isPast;

  const _DayItem({
    required this.label,
    required this.count,
    required this.isToday,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasActivity = count > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isToday
                ? colorScheme.primary
                : (hasActivity
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.3,
                        )),
            shape: BoxShape.circle,
            border: isToday
                ? null
                : Border.all(
                    color: hasActivity
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : Colors.transparent,
                    width: 1,
                  ),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isToday
                    ? colorScheme.onPrimary
                    : (hasActivity
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.4)),
                fontWeight: isToday || hasActivity
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          hasActivity ? '$count' : '',
          style: theme.textTheme.labelSmall?.copyWith(
            color: isToday
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(
                    alpha: hasActivity ? 0.8 : 0.3,
                  ),
            fontWeight: isToday || hasActivity
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: isToday
                ? colorScheme.primary
                : (hasActivity
                      ? colorScheme.primary.withValues(alpha: 0.4)
                      : Colors.transparent),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
