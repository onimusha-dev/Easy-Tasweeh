import 'dart:ui';
import 'package:flutter/material.dart';

class MidnightGlassStyle extends StatelessWidget {
  final Animation<double> rippleAnimation;

  const MidnightGlassStyle({
    super.key,
    required this.rippleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) {
              return Container(
                width: 240 * rippleAnimation.value,
                height: 240 * rippleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(
                      alpha: (1 - rippleAnimation.value) * 0.5,
                    ),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade400.withValues(alpha: 0.5),
                          Colors.purple.shade400.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: 30,
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
