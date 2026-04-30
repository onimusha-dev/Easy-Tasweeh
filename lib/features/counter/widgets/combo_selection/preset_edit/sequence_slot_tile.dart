import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_sheet.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_goal_sheet.dart';
import 'package:flutter/material.dart';

class SequenceSlotTile extends StatelessWidget {
  final int index;
  final String dhikrId;
  final int count;
  final Function(String) onDhikrChanged;
  final Function(int) onGoalChanged;

  const SequenceSlotTile({
    super.key,
    required this.index,
    required this.dhikrId,
    required this.count,
    required this.onDhikrChanged,
    required this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final dhikr = dhikrList.firstWhere(
      (d) => d.id == dhikrId,
      orElse: () => dhikrList.first,
    );

    return GestureDetector(
      onTap: () {
        DhikrSheet.show(
          context,
          onSelected: (selected) {
            onDhikrChanged(selected.id);
            Navigator.pop(context);
          },
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIndexBadge(context, colorScheme),
            const SizedBox(width: 16),
            _buildDhikrInfo(textTheme, dhikr, colorScheme),
            const SizedBox(width: 12),
            _buildGoalBadge(context, colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexBadge(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDhikrInfo(
    TextTheme textTheme,
    DhikrItem dhikr,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dhikr.transliteration,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            dhikr.arabic,
            style: AppTypography.arabicLabel(
              colorScheme.onSurface.withValues(alpha: 0.6),
            ).copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalBadge(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => TargetGoalSheet(
            onSelected: (newTarget) {
              onGoalChanged(newTarget);
              Navigator.pop(context);
            },
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontSize: 12,
              ),
            ),
            Text(
              'GOAL',
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w900,
                color: colorScheme.outline,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
