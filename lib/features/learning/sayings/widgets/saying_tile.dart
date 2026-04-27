import 'package:easy_tasbeeh/core/models/saying_model.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Use a consistent wisdom-themed color for sayings
    final accentColor = Colors.amber;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Index side-bar
          SizedBox(
            width: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Solid accent strip
                Container(width: 3, color: accentColor),
                // Numbering area
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Text(
                            DhikrUtils.toArabicDigits(index),
                            style: AppTypography.arabicLabel(colorScheme.onSurface),
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 10, isLast ? 40 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (item.arabic != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        item.arabic!,
                        textAlign: TextAlign.right,
                        style: AppTypography.arabicBody(colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    '"${item.content}"',
                    style: textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '- ${item.source}',
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
