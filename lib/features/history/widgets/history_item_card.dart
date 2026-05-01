import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/utils/color_utils.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
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
    final colorScheme = theme.colorScheme;
    final isCompleted =
        data.targetCount > 0 && data.currentCount >= data.targetCount;
    final double percentage = data.targetCount > 0
        ? (data.currentCount / data.targetCount) * 100
        : 0;

    final Color statusColor = setPercentageCompletionColor(context, percentage);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
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
                    ? Icons.auto_awesome_motion_rounded
                    : (isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.history_rounded),
                color: statusColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),

            // Content Info
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
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            (data.comboName ?? 'COMBO').toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => ComboDetailsSheet.show(context, data),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: colorScheme.primary.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    data.sessionMode == 'combo'
                        ? 'Combo Sequence'
                        : dhikrList
                              .firstWhere(
                                (d) => d.id == data.dhikrId,
                                orElse: () => dhikrList.first,
                              )
                              .arabic,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: data.sessionMode == 'combo' ? 15 : 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.sessionMode == 'combo'
                        ? 'Multi-dhikr session • ${DateFormat('hh:mm a').format(data.createdAt)}'
                        : '${dhikrList.firstWhere((d) => d.id == data.dhikrId, orElse: () => dhikrList.first).transliteration} • ${DateFormat('hh:mm a').format(data.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Progress/Score
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${data.currentCount}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (data.targetCount > 0)
                      Text(
                        '/${data.targetCount}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                if (data.targetCount > 0)
                  Text(
                    '${percentage.toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
