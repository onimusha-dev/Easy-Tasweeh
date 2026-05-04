import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/core/widgets/app_section.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/combo_preset_card.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/combo_selection_app_bar.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/empty_presets_state.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/preset_edit_sheet.dart';
import 'package:easy_tasbeeh/features/counter/widgets/combo_selection/single_mode_card.dart';
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
          padding: const EdgeInsets.fromLTRB(
            AppLayout.spaceLarge,
            AppLayout.spaceMedium,
            AppLayout.spaceLarge,
            AppLayout.spaceXXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _SingleModeSection(
                isSelected: activeIndex == -1,
                onSelect: () => _handleModeChange(context, ref, -1),
              ),
              const SizedBox(height: 12),
              _ComboPresetsSection(
                settings: settings,
                activeIndex: activeIndex,
                onAdd: () => _addNewPreset(ref),
                onEdit: (preset) => _editPreset(context, preset),
                onDelete: (preset) => _confirmDelete(context, ref, preset),
                onSelect: (index) => _handleModeChange(context, ref, index),
                onMoveUp: (index) => ref
                    .read(settingsProvider.notifier)
                    .moveComboPresetUp(index),
                onMoveDown: (index) => ref
                    .read(settingsProvider.notifier)
                    .moveComboPresetDown(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Logic Methods ---

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
    if (settings.activeComboIndex == newIndex) return;

    final countData = ref.read(currentCountStreamProvider).asData?.value;
    final hasProgress = (countData?.currentCount ?? 0) > 0;

    showDialog(
      context: context,
      builder: (context) => PremiumDialog(
        icon: Icons.swap_horiz_rounded,
        title: 'Switch Mode?',
        description: hasProgress
            ? 'You have active progress. Switching modes will save your current session to history and start fresh at 0.'
            : 'Are you sure you want to switch modes? Your progress in the new mode will start from 0.',
        confirmLabel: 'Switch',
        onConfirm: () async {
          await ref
              .read(settingsProvider.notifier)
              .setActiveComboIndex(newIndex);
          if (context.mounted) {
            // Close selection screen to return to counter
            Navigator.pop(context);
          }
        },
      ),
    );
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

class _SingleModeSection extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onSelect;

  const _SingleModeSection({required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionTitle(title: 'Single Mode'),
        const SizedBox(height: 8),
        SingleModeCard(isSelected: isSelected, onSelect: onSelect),
      ],
    );
  }
}

class _ComboPresetsSection extends StatelessWidget {
  final SettingsState settings;
  final int activeIndex;
  final VoidCallback onAdd;
  final Function(ComboPreset) onEdit;
  final Function(ComboPreset) onDelete;
  final Function(int) onSelect;
  final Function(int) onMoveUp;
  final Function(int) onMoveDown;

  const _ComboPresetsSection({
    required this.settings,
    required this.activeIndex,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppSectionTitle(title: 'Combo Presets'),
            if (settings.comboPresets.isNotEmpty)
              TextButton.icon(
                onPressed: settings.comboPresets.length >= 10 ? null : onAdd,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (settings.comboPresets.isEmpty)
          EmptyPresetsState(onAdd: onAdd)
        else
          Column(
            children: settings.comboPresets.asMap().entries.map((entry) {
              final index = entry.key;
              final preset = entry.value;
              return ComboPresetCard(
                key: ValueKey(preset.id),
                preset: preset,
                index: index,
                isSelected: activeIndex == index,
                onEdit: () => onEdit(preset),
                onDelete: () => onDelete(preset),
                onSelect: () => onSelect(index),
                onMoveUp: index > 0 ? () => onMoveUp(index) : null,
                onMoveDown: index < settings.comboPresets.length - 1
                    ? () => onMoveDown(index)
                    : null,
              );
            }).toList(),
          ),
      ],
    );
  }
}
