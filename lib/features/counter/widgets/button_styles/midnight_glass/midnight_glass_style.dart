import 'dart:ui';

import 'package:flutter/material.dart';

class MidnightGlassStyle extends StatelessWidget {
  final Animation<double> rippleAnimation;

  const MidnightGlassStyle({super.key, required this.rippleAnimation});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dynamic Waterflow Ripple Effect (Multi-ring)
          AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) {
              // Deep Dark for light mode contrast
              final rippleColor = isDark
                  ? colorScheme.primary
                  : const Color(0xFF1A1A1A);
              final baseOpacity = isDark
                  ? 0.3
                  : 0.85; // Even higher opacity for maximum recognition

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring (First wave)
                  Container(
                    width: 280 * rippleAnimation.value,
                    height: 280 * rippleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: rippleColor.withValues(
                          alpha: (1 - rippleAnimation.value) * baseOpacity,
                        ),
                        width: isDark ? 2.0 : 3.5,
                      ),
                    ),
                  ),

                  // Middle ring (Second wave)
                  if (rippleAnimation.value > 0.3)
                    Container(
                      width: 280 * (rippleAnimation.value - 0.3) * 1.4,
                      height: 280 * (rippleAnimation.value - 0.3) * 1.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: rippleColor.withValues(
                            alpha:
                                (1 - rippleAnimation.value) *
                                (baseOpacity * 0.7),
                          ),
                          width: isDark ? 1.5 : 2.5,
                        ),
                      ),
                    ),

                  // Inner ring (Third wave)
                  if (rippleAnimation.value > 0.6)
                    Container(
                      width: 280 * (rippleAnimation.value - 0.6) * 2.5,
                      height: 280 * (rippleAnimation.value - 0.6) * 2.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: rippleColor.withValues(
                            alpha:
                                (1 - rippleAnimation.value) *
                                (baseOpacity * 0.4),
                          ),
                          width: isDark ? 1.0 : 1.5,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Glass Button
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.surface.withValues(alpha: 0.15)
                      : Colors.white.withValues(
                          alpha: 0.85,
                        ), // Whiter glass for light mode
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: isDark
                        ? colorScheme.primary.withValues(alpha: 0.2)
                        : colorScheme.primary.withValues(alpha: 0.5),
                    width: 2.0, // Thicker border for definition
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withValues(
                            alpha: isDark ? 0.4 : 0.9,
                          ),
                          colorScheme.secondary.withValues(
                            alpha: isDark ? 0.4 : 0.9,
                          ),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.blur_on_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
