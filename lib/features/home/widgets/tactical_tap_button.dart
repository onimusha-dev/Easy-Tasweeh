import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TacticalTapButton extends StatelessWidget {
  final VoidCallback onTap;

  const TacticalTapButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1),
            width: 10,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fingerprint_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 50,
              ),
              const SizedBox(height: 12),
              Text(
                'PRESS',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(autoPlay: false)
        .scale(
          duration: 40.ms,
          begin: const Offset(1, 1),
          end: const Offset(0.96, 0.96),
        );
  }
}
