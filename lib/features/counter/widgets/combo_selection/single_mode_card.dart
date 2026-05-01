import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_sheet.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_goal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleModeCard extends ConsumerWidget {
  final bool isSelected;
  final VoidCallback onSelect;

  const SingleModeCard({
    super.key,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final settings = ref.watch(settingsProvider);
    final singleDhikr = dhikrList.firstWhere(
      (d) => d.id == settings.lastDhikrId,
      orElse: () => dhikrList.first,
    );
    final countAsync = ref.watch(singleCountStreamProvider);
    final currentTarget = countAsync.asData?.value?.targetCount ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.08)
            : colorScheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        // Always have a border to prevent layout shift ("movement") on selection
        border: Border.all(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 1, // Smaller border width
        ),
      ),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.15)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.adjust_rounded,
                      size: 22,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Single Mode',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Standard one-at-a-time dhikr',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onSelect,
                      onLongPress: () => DhikrSheet.show(context),
                      child: Column(
                        children: [
                          Text(
                            'DHIKR',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            singleDhikr.transliteration.split(' ').first,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onSelect,
                      onLongPress: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const TargetGoalSheet(),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'GOAL',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentTarget == 0 ? '∞' : '$currentTarget',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
