import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/core/widgets/save_progress_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/providers/counter_provider.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DhikrSheet extends ConsumerWidget {
  final Function(DhikrItem)? onSelected;
  final int? sessionId;
  const DhikrSheet({super.key, this.onSelected, this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentDhikr = ref.watch(currentDhikrProvider);
    
    // Determine which session we are actually looking at
    final targetSessionId = sessionId ??
        (settings.activeComboIndex >= 0 ? sessionIdCombo : sessionIdSingle);

    final sessionCountAsync = ref.watch(sessionStreamProvider(targetSessionId));
    final currentCount = sessionCountAsync.value?.currentCount ?? 0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppLayout.brSheet,
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
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
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
              padding: const EdgeInsets.fromLTRB(
                AppLayout.spaceLarge,
                AppLayout.spaceSmall,
                AppLayout.spaceLarge,
                AppLayout.spaceLarge,
              ),
              itemCount: dhikrList.length,
              itemBuilder: (context, index) {
                final item = dhikrList[index];

                // Determine if this item is selected based on which session we are editing
                final bool isSelected = sessionId == sessionIdSingle
                    ? item.id == settings.lastDhikrId
                    : item.id == currentDhikr.id;

                return DhikrTile(
                  item: item,
                  index: index + 1,
                  isSelected: isSelected,
                  onTap: () async {
                    if (onSelected != null) {
                      onSelected!(item);
                      return;
                    }

                    final notifier = ref.read(counterProvider.notifier);

                    if (currentCount > 0) {
                      SaveProgressDialog.show(
                        context,
                        title: 'Save session?',
                        description:
                            'This will save your current progress to history.',
                        confirmLabel: 'Archive',
                        onConfirm: () async {
                          // Close dialog first
                          Navigator.pop(context);
                          
                          await ref.read(countRepositoryProvider).saveAndReset(sessionId: sessionId);
                          await ref
                              .read(settingsProvider.notifier)
                              .setLastDhikrId(item.id);
                          await ref.read(countRepositoryProvider).setDhikrId(item.id,
                              sessionId: sessionId);
                          if (context.mounted) Navigator.pop(context);
                        },
                      );
                    } else {
                      await ref
                          .read(settingsProvider.notifier)
                          .setLastDhikrId(item.id);
                      await notifier.setDhikrId(item.id, sessionId: sessionId);
                      if (context.mounted) Navigator.pop(context);
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
    int? sessionId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          DhikrSheet(onSelected: onSelected, sessionId: sessionId),
    );
  }
}
