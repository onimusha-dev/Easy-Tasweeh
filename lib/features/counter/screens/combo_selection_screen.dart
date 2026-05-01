import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/core/widgets/save_progress_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/combo_preset_card.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/combo_selection_app_bar.dart';
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
      appBar: const ComboSelectionAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              buildSettingSectionTitle(context, 'Single Mode'),
              const SizedBox(height: 8),
              SingleModeCard(
                isSelected: activeIndex == -1,
                onSelect: () => _handleModeChange(context, ref, -1),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 8),
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
                    onMoveUp: entry.key > 0
                        ? () => ref
                            .read(settingsProvider.notifier)
                            .moveComboPresetUp(entry.key)
                        : null,
                    onMoveDown: entry.key < settings.comboPresets.length - 1
                        ? () => ref
                            .read(settingsProvider.notifier)
                            .moveComboPresetDown(entry.key)
                        : null,
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

    final countData = ref.read(currentCountStreamProvider).asData?.value;
    final currentCount = countData?.currentCount ?? 0;

    if (currentCount > 0) {
      SaveProgressDialog.show(
        context,
        title: 'Switch Mode?',
        description:
            'You have active progress. Switching modes will save your current session to history.',
        confirmLabel: 'Switch',
        onConfirm: () async {
          await ref
              .read(settingsProvider.notifier)
              .setActiveComboIndex(newIndex);
        },
      );
    } else {
      await ref.read(settingsProvider.notifier).setActiveComboIndex(newIndex);
    }
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
