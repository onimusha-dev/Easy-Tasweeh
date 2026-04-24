import 'package:easy_tasbeeh/core/models/saying_model.dart';
import 'package:flutter/material.dart';

class SayingTile extends StatelessWidget {
  final SayingItem item;

  const SayingTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.arabic != null) ...[
            SizedBox(
              width: double.infinity,
              child: SelectableText(
                item.arabic!,
                textAlign: TextAlign.right,
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  height: 1.6,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 12),
          ],
          SelectableText(
            '"${item.content}"',
            style: textTheme.bodyMedium?.copyWith(
              height: 1.5,
              fontSize: 15,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '- ${item.source}',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
