import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/selection_item_tile.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_sheet.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_goal_sheet.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleModeCard extends ConsumerWidget {
  final bool isSelected;

  const SingleModeCard({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDhikr = ref.watch(currentDhikrProvider);
    final countAsync = ref.watch(currentCountStreamProvider);
    final currentTarget = countAsync.asData?.value?.targetCount ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: buildSettingsGroup(
        context,
        showBorder: true,
        children: [
          SelectionItemTile(
            icon: Icons.menu_book_rounded,
            title: 'Current Dhikr',
            value: currentDhikr.transliteration,
            isSelected: isSelected,
            onTap: () =>
                ref.read(settingsProvider.notifier).setActiveComboIndex(-1),
            onEdit: () => DhikrSheet.show(context),
          ),
          SelectionItemTile(
            icon: Icons.track_changes_rounded,
            title: 'Target Goal',
            value: currentTarget == 0 ? 'Endless' : '$currentTarget Counts',
            isSelected: isSelected,
            onTap: () =>
                ref.read(settingsProvider.notifier).setActiveComboIndex(-1),
            onEdit: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const TargetGoalSheet(),
            ),
          ),
        ],
      ),
    );
  }
}
