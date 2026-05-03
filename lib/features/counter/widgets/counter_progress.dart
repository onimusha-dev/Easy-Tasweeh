import 'package:easy_tasbeeh/core/service/settings/settings_state.dart';
import 'package:flutter/material.dart';

class CounterProgress extends StatelessWidget {
  const CounterProgress({
    super.key,
    required this.progress,
    required this.textTheme,
    required this.colorScheme,
    required this.currentCountData,
    required this.targetCount,
    required this.settings,
  });

  final double progress;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final int currentCountData;
  final int targetCount;
  final SettingsState settings;

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
                if (settings.activeComboIndex >= 0)
                  _buildComboCheckmarks(context)
                else
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
            _AnimatedProgressBar(
              progress: progress,
              colorScheme: colorScheme,
              settings: settings,
            )
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

  Widget _buildComboCheckmarks(BuildContext context) {
    if (targetCount <= 0) return const SizedBox.shrink();

    if (settings.activeComboIndex < 0 ||
        settings.activeComboIndex >= settings.comboPresets.length) {
      return const SizedBox.shrink();
    }

    final preset = settings.comboPresets[settings.activeComboIndex];
    final counts = preset.counts;
    if (counts.isEmpty) return const SizedBox.shrink();

    // Calculate segments progress
    int completedSegments = 0;
    int cumulative = 0;
    for (int i = 0; i < counts.length; i++) {
      cumulative += counts[i];
      if (currentCountData >= cumulative) {
        completedSegments = i + 1;
      } else {
        break;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(counts.length, (index) {
        final isCompleted = index < completedSegments;
        final isActive = index == completedSegments;

        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.greenAccent.withValues(alpha: 0.2)
                  : (isActive
                      ? colorScheme.primary.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05)),
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted
                    ? Colors.greenAccent.withValues(alpha: 0.5)
                    : (isActive
                        ? colorScheme.primary.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1)),
                width: 1,
              ),
            ),
            child: Icon(
              isCompleted ? Icons.check_rounded : Icons.circle,
              size: 10, // Slightly smaller to fit more segments if needed
              color: isCompleted
                  ? Colors.greenAccent
                  : (isActive
                      ? colorScheme.primary
                      : Colors.white.withValues(alpha: 0.2)),
            ),
          ),
        );
      }),
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final ColorScheme colorScheme;
  final SettingsState settings;

  const _AnimatedProgressBar({
    required this.progress,
    required this.colorScheme,
    required this.settings,
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
