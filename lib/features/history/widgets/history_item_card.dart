import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:easy_tasweeh/core/utils/color_utils.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryItemCard extends StatelessWidget {
  final CountHistoryTableData data;
  final int index;
  final bool isLast;

  const HistoryItemCard({
    super.key,
    required this.data,
    required this.index,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted =
        data.targetCount > 0 && data.currentCount >= data.targetCount;
    final double percentage = data.targetCount > 0
        ? (data.currentCount / data.targetCount) * 100
        : 0;

    final Color statusColor = setPercentageCompletionColor(percentage);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icon/Status Indicator
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCompleted ? Icons.done_all_rounded : Icons.history_rounded,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),

              // Count Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dhikrList.firstWhere(
                        (d) => d.id == data.dhikrId,
                        orElse: () => dhikrList.first,
                      ).arabic,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${dhikrList.firstWhere(
                            (d) => d.id == data.dhikrId,
                            orElse: () => dhikrList.first,
                          ).transliteration} • ${DateFormat('hh:mm a').format(data.createdAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress/Score
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${data.currentCount}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (data.targetCount > 0)
                          TextSpan(
                            text: ' / ${data.targetCount}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (data.targetCount > 0)
                    Text(
                      '${percentage.toInt()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
      ],
    );
  }
}
