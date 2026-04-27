import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:flutter/material.dart';

class FeaturedTip extends StatelessWidget {
  const FeaturedTip({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppIconColors.blue(context).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppIconColors.blue(context).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppIconColors.blue(context),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'DAILY TIP',
                style: textTheme.labelSmall?.copyWith(
                  color: AppIconColors.blue(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The best way to remember Allah is through constant, small acts of devotion throughout your day. Consistency is the key to a tranquil heart.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
