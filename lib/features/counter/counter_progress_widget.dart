import 'package:flutter/material.dart';

class CounterProgressWidget extends StatelessWidget {
  const CounterProgressWidget({
    super.key,
    required this.percentage,
    required this.progress,
    required this.textTheme,
    required this.colorScheme,
  });

  final int percentage;
  final double progress;
  final dynamic textTheme;
  final dynamic colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.outline,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$percentage% to complete',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress == 0 ? 0.01 : progress,
            minHeight: 12,
            backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
