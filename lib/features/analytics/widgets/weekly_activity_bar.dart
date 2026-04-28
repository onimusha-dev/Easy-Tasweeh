import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyActivityBar extends StatelessWidget {
  final Map<String, int> dailyTotals;

  const WeeklyActivityBar({super.key, required this.dailyTotals});

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days,
      ),
    );
  }

  String _getDayLabel(int index) {
    const labels = ['S', 'M', 'Tu', 'W', 'Th', 'F', 'S'];
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isToday
                ? colorScheme.surfaceContainerHighest
                : colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  )
                : null,
          ),

          child: Center(
            child: Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: isToday
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(
                        alpha: isPast ? 0.7 : 0.3,
                      ),
                fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Text(
              '${count}s',
              style: textTheme.labelSmall?.copyWith(
                color: isToday
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
            if (isToday) ...[
              const SizedBox(height: 6),
              Container(
                width: 14,
                height: 2.5,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
