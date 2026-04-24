import 'package:flutter/material.dart';

class GlowingBallStyle extends StatelessWidget {
  final Animation<double> rippleAnimation;

  const GlowingBallStyle({super.key, required this.rippleAnimation});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth;
          final starSize = size * 0.45;

          return AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) {
              // Create a peaked factor (0 -> 1 -> 0) for the star flash
              final double flashFactor = rippleAnimation.value < 0.2
                  ? rippleAnimation.value * 5
                  : (1.0 - rippleAnimation.value) * 1.25;

              // Transition for the ball's brightness (softened)
              final double brightnessFactor = rippleAnimation.value;

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color.lerp(
                        const Color(0xFF90AB8B), // Secondary Sage
                        const Color(
                          0xFFD9E4C5,
                        ), // Muted Light Sage (was EBF4DD)
                        brightnessFactor,
                      )!,
                      Color.lerp(
                        const Color(0xFF5A7863), // Primary Sage
                        const Color(0xFF90AB8B), // Secondary Sage
                        brightnessFactor,
                      )!,
                      Color.lerp(
                        const Color(0xFF2D3C32), // Deep Sage
                        const Color(0xFF5A7863), // Primary Sage
                        brightnessFactor,
                      )!,
                    ],
                    center: const Alignment(-0.2, -0.2),
                    radius: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: size * 0.06,
                      offset: Offset(0, size * 0.03),
                    ),
                    if (brightnessFactor > 0)
                      BoxShadow(
                        color: const Color(0xFF90AB8B).withValues(
                          alpha: brightnessFactor * 0.25, // Reduced from 0.4
                        ),
                        blurRadius: size * 0.08, // Reduced from 0.1
                        spreadRadius: size * 0.01 * brightnessFactor,
                      ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Inner glossy highlight
                    Positioned(
                      top: size * 0.1,
                      left: size * 0.15,
                      child: Container(
                        width: size * 0.2,
                        height: size * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(
                            alpha: 0.08 + (0.1 * brightnessFactor),
                          ),
                        ),
                      ),
                    ),
                    // The Star
                    Icon(
                      Icons.star_rounded,
                      color: Color.lerp(
                        const Color(0xFF4A5D51), // Muted Sage Idle
                        Colors.white, // Bright White Click
                        flashFactor.clamp(0.0, 1.0),
                      ),
                      size: starSize,
                      shadows: [
                        if (rippleAnimation.value > 0)
                          Shadow(
                            color: const Color(0xFFEBF4DD).withValues(
                              alpha: (1 - rippleAnimation.value) * 0.1,
                            ),
                            blurRadius: starSize * 0.3 * rippleAnimation.value,
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
