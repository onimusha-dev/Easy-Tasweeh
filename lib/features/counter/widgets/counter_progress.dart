import 'package:flutter/material.dart';

class CounterProgress extends StatelessWidget {
  const CounterProgress({
    super.key,
    required this.percentage,
    required this.progress,
    required this.textTheme,
    required this.colorScheme,
    required this.currentCountData,
    required this.targetCount,
  });

  final int percentage;
  final double progress;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final int currentCountData;
  final int targetCount;

  @override
  Widget build(BuildContext context) {
    final bool hasTarget = targetCount > 0;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const SizedBox(width: 8),
                  Text(
                    '$currentCountData',
                    style: textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  if (hasTarget)
                    Text(
                      ' / $targetCount',
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
              if (hasTarget)
                const SizedBox.shrink()
              else
                Text(
                  'ENDLESS',
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasTarget)
            _AnimatedProgressBar(progress: progress, colorScheme: colorScheme)
          else
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final ColorScheme colorScheme;

  const _AnimatedProgressBar({
    required this.progress,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    const double thumbSize = 16.0;
    const double thumbRadius = thumbSize / 2;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            // The thumb center moves from index 0 to availableWidth
            // But we want to keep the thumb within bounds, so we offset the track
            final trackWidth = availableWidth - (thumbRadius * 2);
            final currentPosition = value * trackWidth;

            return SizedBox(
              height: thumbSize,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Background Track
                  Positioned(
                    left: thumbRadius,
                    right: thumbRadius,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Progress Fill
                  Positioned(
                    left: thumbRadius,
                    child: Container(
                      height: 8,
                      width: currentPosition,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Thumb (Centered on the end of the progress fill)
                  Positioned(
                    left: currentPosition,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 3.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
