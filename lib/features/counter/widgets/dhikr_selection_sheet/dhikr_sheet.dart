import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DhikrSheet extends ConsumerWidget {
  final Function(DhikrItem)? onSelected;
  const DhikrSheet({super.key, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDhikr = ref.watch(currentDhikrProvider);
    final countAsync = ref.watch(currentCountStreamProvider);
    final currentCount = countAsync.asData?.value?.currentCount ?? 0;
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Dhikr',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Choose which dhikr to recite',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dhikr List
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: dhikrList.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                itemBuilder: (context, index) {
                  final item = dhikrList[index];
                  final isSelected = item.id == currentDhikr.id;

                  return DhikrTile(
                    item: item,
                    index: index + 1,
                    isSelected: isSelected,
                    isLast: index == dhikrList.length - 1,
                    onTap: () {
                      if (onSelected != null) {
                        onSelected!(item);
                        return;
                      }
                      
                      final repo = ref.read(countRepositoryProvider);

                      if (currentCount > 0) {
                        showDialog(
                          context: context,
                          builder: (context) => PremiumDialog(
                            icon: Icons.track_changes_rounded,
                            title: 'Save session?',
                            description:
                                'This will save your current progress to history.',
                            confirmLabel: 'Archive',
                            onConfirm: () {
                              repo.saveAndReset();
                              ref
                                  .read(settingsProvider.notifier)
                                  .setLastDhikrId(item.id);
                              repo.setDhikrId(item.id);
                              Navigator.pop(context); // Close bottom sheet
                            },
                          ),
                        );
                      } else {
                        repo.saveAndReset();
                        ref
                            .read(settingsProvider.notifier)
                            .setLastDhikrId(item.id);
                        repo.setDhikrId(item.id);
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> show(BuildContext context, {Function(DhikrItem)? onSelected}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DhikrSheet(onSelected: onSelected),
    );
  }
}
