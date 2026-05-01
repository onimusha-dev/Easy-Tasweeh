import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/utils/color_utils.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:easy_tasbeeh/features/history/widgets/combo_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HistoryItemCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isCompleted =
        data.targetCount > 0 && data.currentCount >= data.targetCount;
    final double percentage = data.targetCount > 0
        ? (data.currentCount / data.targetCount) * 100
        : 0;

    final Color statusColor = setPercentageCompletionColor(context, percentage);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon/Status Indicator
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    data.sessionMode == 'combo'
                        ? Icons.notes_rounded
                        : (isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.history_rounded),
                    color: statusColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),

                // Combo and Count Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.sessionMode == 'combo') ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.15,
                                ),
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
                            GestureDetector(
                              onTap: () =>
                                  ComboDetailsSheet.show(context, data),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  size: 20,
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            data.sessionMode == 'combo'
                                ? 'Full Sequence Completed'
                                : dhikrList
                                      .firstWhere(
                                        (d) => d.id == data.dhikrId,
                                        orElse: () => dhikrList.first,
                                      )
                                      .arabic,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: data.sessionMode == 'combo'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: data.sessionMode == 'combo' ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.sessionMode == 'combo'
                            ? 'Multi-Dhikr Collection • ${DateFormat('hh:mm a').format(data.createdAt)}'
                            : '${dhikrList.firstWhere((d) => d.id == data.dhikrId, orElse: () => dhikrList.first).transliteration} • ${DateFormat('hh:mm a').format(data.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
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
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // if (showDivider && !isLast)
        //   Divider(
        //     height: 1,
        //     indent: 56,
        //     endIndent: 0,
        //     color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        //   ),
      ],
    );
  }
}
