import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DhikrSheet extends ConsumerWidget {
  const DhikrSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDhikr = ref.watch(currentDhikrProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.75,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text('Select Dhikr', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
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
                    ref.read(settingsProvider.notifier).setLastDhikrId(item.id);
                    ref.read(countRepositoryProvider).setDhikrId(item.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DhikrSheet(),
    );
  }
}
