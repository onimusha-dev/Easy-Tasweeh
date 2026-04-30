import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/combo_preset_card.dart';
import 'package:flutter/material.dart';

class ComboPresetsList extends StatelessWidget {
  final List<ComboPreset> presets;
  final int activeIndex;
  final Function(ComboPreset) onEdit;
  final Function(ComboPreset) onDelete;
  final Function(int) onSelect;

  const ComboPresetsList({
    super.key,
    required this.presets,
    required this.activeIndex,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: presets.asMap().entries.map((entry) {
        return ComboPresetCard(
          preset: entry.value,
          index: entry.key,
          isSelected: activeIndex == entry.key,
          onEdit: () => onEdit(entry.value),
          onDelete: () => onDelete(entry.value),
          onSelect: () => onSelect(entry.key),
        );
      }).toList(),
    );
  }
}
