import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:flutter/material.dart';

class FeaturedTip extends StatelessWidget {
  const FeaturedTip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = AppIconColors.blue(context);

    return AppCard(
      backgroundColor: accentColor.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  color: accentColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'DAILY TIP',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'The best way to remember Allah is through constant, small acts of devotion throughout your day. Consistency is the key to a tranquil heart.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
