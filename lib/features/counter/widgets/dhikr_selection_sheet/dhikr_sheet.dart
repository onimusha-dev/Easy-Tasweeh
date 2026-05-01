import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/save_progress_dialog.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Dhikr',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Choose your primary dhikr',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Dhikr List
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: dhikrList.length,
              itemBuilder: (context, index) {
                final item = dhikrList[index];
                final isSelected = item.id == currentDhikr.id;

                return DhikrTile(
                  item: item,
                  index: index + 1,
                  isSelected: isSelected,
                  onTap: () {
                    if (onSelected != null) {
                      onSelected!(item);
                      return;
                    }

                    final repo = ref.read(countRepositoryProvider);

                    if (currentCount > 0) {
                      SaveProgressDialog.show(
                        context,
                        title: 'Save session?',
                        description:
                            'This will save your current progress to history.',
                        confirmLabel: 'Archive',
                        onConfirm: () {
                          ref
                              .read(settingsProvider.notifier)
                              .setLastDhikrId(item.id);
                          repo.setDhikrId(item.id);
                          Navigator.pop(context); // Close bottom sheet
                        },
                      );
                    } else {
                      ref
                          .read(settingsProvider.notifier)
                          .setLastDhikrId(item.id);
                      repo.setDhikrId(item.id);
                      Navigator.pop(context); // Close bottom sheet
                    }
                  },
                );
              },
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
