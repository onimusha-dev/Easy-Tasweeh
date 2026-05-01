import 'package:easy_tasbeeh/core/models/saying_model.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:flutter/material.dart';

class SayingTile extends StatelessWidget {
  final SayingItem item;
  final int index;
  final bool isLast;

  const SayingTile({
    super.key,
    required this.item,
    required this.index,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      DhikrUtils.toLocalizedDigits(index),
                      style: AppTypography.arabicTitle(
                        accentColor,
                      ).copyWith(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.source,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: accentColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Saying #$index',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (item.arabic != null) ...[
              SizedBox(
                width: double.infinity,
                child: Text(
                  item.arabic!,
                  textAlign: TextAlign.right,
                  style: AppTypography.arabicBody(
                    colorScheme.onSurface,
                  ).copyWith(fontSize: 19, height: 1.5),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              '"${item.content}"',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
