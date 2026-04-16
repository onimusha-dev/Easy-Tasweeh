import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:easy_tasweeh/core/service/dhikr_service.dart';
import 'package:easy_tasweeh/features/counter/dhikr_selection_sheet/dhikr_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DhikrSelectionSheet extends ConsumerWidget {
  const DhikrSelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDhikr = ref.watch(currentDhikrProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
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
          const SizedBox(height: 24),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: dhikrList.length,
              separatorBuilder: (context, _) =>
                  Divider(indent: 24, endIndent: 24),
              itemBuilder: (context, index) {
                final item = dhikrList[index];
                final isSelected = item.id == currentDhikr.id;

                return DhikrItemCard(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    ref.read(currentDhikrProvider.notifier).state = item;
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DhikrSelectionSheet(),
    );
  }
}
