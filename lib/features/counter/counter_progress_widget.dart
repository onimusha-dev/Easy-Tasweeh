import 'package:flutter/material.dart';

class CounterProgressWidget extends StatelessWidget {
  const CounterProgressWidget({
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR PROGRESS',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary.withValues(alpha: 0.7),
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$currentCountData',
                        style: textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: hasTarget ? ' / $targetCount' : ' counts',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasTarget)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.15),
                      colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$percentage%',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ENDLESS',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.outline,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        if (hasTarget)
          _AnimatedProgressBar(progress: progress, colorScheme: colorScheme)
        else
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
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
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Container(
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.1),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Progress Fill
              FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Glowing Thumb/Cap
              if (value > 0)
                Positioned(
                  left: (MediaQuery.of(context).size.width - 48) * value - 8,
                  top: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.primary, width: 3),
                    ),
                  ),
                ),
              // Subtle Inner Shine
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
