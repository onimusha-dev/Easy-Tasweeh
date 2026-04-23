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
          final starSize = size * 0.45; // Scale star relative to button size

          return AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) {
              // Create a peaked factor (0 -> 1 -> 0) for the star flash
              final double flashFactor = rippleAnimation.value < 0.2
                  ? rippleAnimation.value * 5 // Rapid climb to white
                  : (1.0 - rippleAnimation.value) * 1.25; // Slower fade back to dark

              // Transition for the ball's brightness
              final double brightnessFactor = rippleAnimation.value;

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color.lerp(
                        Colors.orange.shade600,
                        Colors.amber.shade200,
                        brightnessFactor,
                      )!,
                      Color.lerp(
                        Colors.orange.shade800,
                        Colors.orange.shade400,
                        brightnessFactor,
                      )!,
                      Color.lerp(
                        const Color(0xFF6D3C00), // Slightly less dark than before (was 4E2C00)
                        Colors.orange.shade900,
                        brightnessFactor,
                      )!,
                    ],
                    center: const Alignment(-0.2, -0.2),
                    radius: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: size * 0.06,
                      offset: Offset(0, size * 0.03),
                    ),
                    // Outer glow removed as requested
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
                            alpha: 0.2 + (0.2 * brightnessFactor),
                          ),
                        ),
                      ),
                    ),
                    // The Star
                    Icon(
                      Icons.star_rounded,
                      color: Color.lerp(
                        const Color(0xFF330000), // Very Dark Idle
                        Colors.white, // Bright White Click
                        flashFactor.clamp(0.0, 1.0),
                      ),
                      size: starSize,
                      shadows: [
                        if (rippleAnimation.value > 0)
                          Shadow(
                            color: Colors.amber.withValues(
                              alpha: (1 - rippleAnimation.value) * 0.6,
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
