import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CounterDisplay extends StatelessWidget {
  final int current;
  final int target;

  const CounterDisplay({
    super.key,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final displayProgress = target > 0
        ? (current == 0 ? 0.001 : (current / target).clamp(0.0, 1.0))
        : 0.0;

    return Stack(
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
                  style: Theme.of(context).textTheme.headlineMedium,
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
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
