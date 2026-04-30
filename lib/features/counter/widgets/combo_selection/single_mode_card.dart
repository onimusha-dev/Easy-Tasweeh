import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_sheet.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_goal_sheet.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final settings = ref.watch(settingsProvider);
    final singleDhikr = dhikrList.firstWhere(
      (d) => d.id == settings.lastDhikrId,
      orElse: () => dhikrList.first,
    );
    final countAsync = ref.watch(singleCountStreamProvider);
    final currentTarget = countAsync.asData?.value?.targetCount ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: onSelect,
        behavior: HitTestBehavior.opaque,
        child: buildSettingsGroup(
          context,
          showBorder: true,
          borderColor: isSelected ? colorScheme.primary : null,
          borderWidth: 1.5,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Icon(
                      Icons.view_carousel_rounded,
                      size: 22,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Single Mode',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => DhikrSheet.show(context),
                      child: Column(
                        children: [
                          Text(
                            'DHIKR',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            singleDhikr.transliteration.split(' ').first,
                            style: textTheme.titleMedium?.copyWith(
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
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const TargetGoalSheet(),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'GOAL',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentTarget == 0 ? '∞' : '$currentTarget',
                            style: textTheme.titleMedium?.copyWith(
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
