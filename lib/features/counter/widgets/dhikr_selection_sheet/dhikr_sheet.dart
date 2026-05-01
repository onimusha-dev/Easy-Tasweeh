import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_tile.dart';
import 'package:easy_tasbeeh/core/theme/theme.dart';
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
          SizedBox(height: 12),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 12),

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

                      showDialog(
                        context: context,
                        builder: (context) => PremiumDialog(
                          icon: Icons.track_changes_rounded,
                          title: currentCount > 0 ? 'Save session?' : 'Change Dhikr?',
                          description: currentCount > 0
                              ? 'This will save your current progress to history.'
                              : 'Are you sure you want to change your current dhikr?',
                          confirmLabel: currentCount > 0 ? 'Archive' : 'Confirm',
                          color: currentCount > 0
                              ? Theme.of(context)
                                  .extension<AppColors>()
                                  ?.destructiveColor
                              : null,
                          onConfirm: () {
                            repo.saveAndReset();
                            ref
                                .read(settingsProvider.notifier)
                                .setLastDhikrId(item.id);
                            repo.setDhikrId(item.id);
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Close bottom sheet
                          },
                        ),
                      );
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

  static Future<void> show(
    BuildContext context, {
    Function(DhikrItem)? onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DhikrSheet(onSelected: onSelected),
    );
  }
}
