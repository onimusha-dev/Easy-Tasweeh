import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/combo_preset_card.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/empty_presets_state.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/preset_edit_sheet.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/single_mode_card.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ComboSelectionScreen extends ConsumerWidget {
  const ComboSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final activeIndex = settings.activeComboIndex;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Dhikr Selection',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSettingSectionTitle(context, 'Single Mode'),
              SingleModeCard(
                isSelected: activeIndex == -1,
                onSelect: () => _handleModeChange(context, ref, -1),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildSettingSectionTitle(context, 'Combo Presets'),

                    if (settings.comboPresets.isNotEmpty)
                      TextButton.icon(
                        onPressed: () => _addNewPreset(ref),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('New'),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                  ],
                ),
              ),
              if (settings.comboPresets.isEmpty)
                EmptyPresetsState(onAdd: () => _addNewPreset(ref))
              else
                ...settings.comboPresets.asMap().entries.map((entry) {
                  return ComboPresetCard(
                    preset: entry.value,
                    index: entry.key,
                    isSelected: activeIndex == entry.key,
                    onEdit: () => _editPreset(context, entry.value),
                    onDelete: () => _confirmDelete(context, ref, entry.value),
                    onSelect: () => _handleModeChange(context, ref, entry.key),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewPreset(WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    final nextIndex = settings.comboPresets.length;
    final newPreset = ComboPreset(
      id: const Uuid().v4(),
      name: 'New Combination',
      dhikrIds: ['subhanallah', 'alhamdulillah', 'allahu_akbar'],
      counts: [33, 33, 33],
    );
    ref.read(settingsProvider.notifier).saveComboPreset(newPreset);
    ref.read(settingsProvider.notifier).setActiveComboIndex(nextIndex);
  }

  void _editPreset(BuildContext context, ComboPreset preset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => PresetEditSheet(preset: preset),
    );
  }

  Future<void> _handleModeChange(
    BuildContext context,
    WidgetRef ref,
    int newIndex,
  ) async {
    final settings = ref.read(settingsProvider);
    final currentIndex = settings.activeComboIndex;

    if (currentIndex == newIndex) return;

    await ref.read(settingsProvider.notifier).setActiveComboIndex(newIndex);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ComboPreset preset) {
    showDialog(
      context: context,
      builder: (context) => PremiumDialog(
        icon: Icons.delete_outline_rounded,
        title: 'Delete Preset?',
        description:
            'Are you sure you want to delete "${preset.name}"? This action cannot be undone.',
        confirmLabel: 'Delete',
        color: Theme.of(context).colorScheme.error,
        onConfirm: () =>
            ref.read(settingsProvider.notifier).deleteComboPreset(preset.id),
      ),
    );
  }
}
