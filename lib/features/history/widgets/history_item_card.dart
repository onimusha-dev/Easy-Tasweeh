import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/utils/color_utils.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryItemCard extends StatelessWidget {
  final CountHistoryTableData data;
  final int index;
  final bool isLast;
  final bool showDivider;

  const HistoryItemCard({
    super.key,
    required this.data,
    required this.index,
    this.isLast = false,
    this.showDivider = true,
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon/Status Indicator
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: data.sessionMode == 'combo'
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  data.sessionMode == 'combo'
                      ? Icons.auto_awesome_motion_rounded
                      : (isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.history_rounded),
                  color: data.sessionMode == 'combo'
                      ? theme.colorScheme.primary
                      : statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),

              // Count Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.sessionMode == 'combo') ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (data.comboName ?? 'COMBO').toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        data.sessionMode == 'combo'
                            ? 'Full Sequence Completed'
                            : dhikrList
                                .firstWhere(
                                  (d) => d.id == data.dhikrId,
                                  orElse: () => dhikrList.first,
                                )
                                .arabic,
                        textAlign: TextAlign.left,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: data.sessionMode == 'combo'
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: data.sessionMode == 'combo' ? 14 : 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.sessionMode == 'combo'
                          ? 'Multi-Dhikr Collection • ${DateFormat('hh:mm a').format(data.createdAt)}'
                          : '${dhikrList.firstWhere((d) => d.id == data.dhikrId, orElse: () => dhikrList.first).transliteration} • ${DateFormat('hh:mm a').format(data.createdAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: statusColor,
                          ),
                        ),
                        if (data.targetCount > 0)
                          TextSpan(
                            text: ' / ${data.targetCount}',
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  if (data.targetCount > 0)
                    Text(
                      '${percentage.toInt()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider && !isLast)
          Divider(
            height: 1,
            indent: 56,
            endIndent: 0,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
      ],
    );
  }
}
