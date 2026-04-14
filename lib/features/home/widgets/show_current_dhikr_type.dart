import 'package:easy_tasweeh/core/service/dhikr_service.dart';
import 'package:easy_tasweeh/features/home/widgets/dhikr_item_card.dart';
import 'package:easy_tasweeh/features/home/widgets/dhikr_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowCurrentDhikrType extends ConsumerWidget {
  const ShowCurrentDhikrType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDhikr = ref.watch(currentDhikrProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(
                Icons.waves_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'CURRENT MODE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DhikrItemCard(
          item: currentDhikr,
          isSelected: true,
          onTap: () => DhikrSelectionSheet.show(context),
        ),
      ],
    );
  }
}
