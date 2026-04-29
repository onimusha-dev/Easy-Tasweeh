import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/dhikr_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_sheet.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_goal_sheet.dart';
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
        title: const Text('Dhikr Selection'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'SINGLE MODE', activeIndex == -1),
              const SizedBox(height: 16),
              _buildSingleModeCard(context, ref, activeIndex == -1),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader(
                    context,
                    'COMBO PRESETS',
                    activeIndex >= 0,
                  ),
                  TextButton.icon(
                    onPressed: () => _addNewPreset(ref),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('New'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (settings.comboPresets.isEmpty)
                _buildEmptyState(context, ref)
              else
                ...settings.comboPresets.asMap().entries.map((entry) {
                  return _buildComboPresetCard(
                    context,
                    ref,
                    preset: entry.value,
                    index: entry.key,
                    isSelected: activeIndex == entry.key,
                  );
                }),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    bool isActive,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isActive ? colorScheme.primary : colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleModeCard(
    BuildContext context,
    WidgetRef ref,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentDhikr = ref.watch(currentDhikrProvider);
    final countAsync = ref.watch(currentCountStreamProvider);
    final currentTarget = countAsync.asData?.value?.targetCount ?? 0;

    return GestureDetector(
      onTap: () => ref.read(settingsProvider.notifier).setActiveComboIndex(-1),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.05)
              : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.4)
                : colorScheme.outline.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                _buildSelectionItem(
                  context,
                  icon: Icons.menu_book_rounded,
                  title: 'Current Dhikr',
                  value: currentDhikr.transliteration,
                  onEdit: () {
                    DhikrSheet.show(context);
                  },
                ),
                const Divider(height: 1, indent: 64),
                _buildSelectionItem(
                  context,
                  icon: Icons.track_changes_rounded,
                  title: 'Target Goal',
                  value: currentTarget == 0
                      ? 'Endless'
                      : '$currentTarget Counts',
                  onEdit: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const TargetGoalSheet(),
                    );
                  },
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 16,
                right: 16,
                child: Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildComboPresetCard(
    BuildContext context,
    WidgetRef ref, {
    required ComboPreset preset,
    required int index,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () =>
            ref.read(settingsProvider.notifier).setActiveComboIndex(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.05)
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.4)
                  : colorScheme.outline.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_awesome_motion_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        preset.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _editPreset(context, ref, preset),
                      icon: Icon(
                        Icons.edit_rounded,
                        size: 20,
                        color: colorScheme.outline,
                      ),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      onPressed: () => _confirmDelete(context, ref, preset),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: colorScheme.error.withValues(alpha: 0.7),
                      ),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (i) {
                    final dhikrId = preset.dhikrIds.length > i
                        ? preset.dhikrIds[i]
                        : null;
                    final dhikr = dhikrId != null
                        ? dhikrList.firstWhere(
                            (d) => d.id == dhikrId,
                            orElse: () => dhikrList.first,
                          )
                        : null;
                    return Expanded(
                      child: Column(
                        children: [
                          Text(
                            dhikr?.transliteration.split(' ').first ?? '...',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${preset.counts[i]}',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome_motion_rounded,
            size: 48,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No presets yet',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: colorScheme.outline),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _addNewPreset(ref),
            child: const Text('Create your first combination'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                Text(
                  value,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_rounded,
                color: colorScheme.outline.withValues(alpha: 0.5),
                size: 16,
              ),
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _addNewPreset(WidgetRef ref) {
    final newPreset = ComboPreset(
      id: const Uuid().v4(),
      name: 'New Combination',
      dhikrIds: ['subhanallah', 'alhamdulillah', 'allahu_akbar'],
      counts: [33, 33, 33],
    );
    ref.read(settingsProvider.notifier).saveComboPreset(newPreset);
    ref
        .read(settingsProvider.notifier)
        .setActiveComboIndex(
          ref.read(settingsProvider).dhikr.comboPresets.length,
        );
  }

  void _editPreset(BuildContext context, WidgetRef ref, ComboPreset preset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PresetEditSheet(preset: preset),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ComboPreset preset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Preset?'),
        content: Text('Are you sure you want to delete "${preset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).deleteComboPreset(preset.id);
              Navigator.pop(context);
            },
            child: Text(
              'DELETE',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetEditSheet extends ConsumerStatefulWidget {
  final ComboPreset preset;
  const _PresetEditSheet({required this.preset});

  @override
  ConsumerState<_PresetEditSheet> createState() => _PresetEditSheetState();
}

class _PresetEditSheetState extends ConsumerState<_PresetEditSheet> {
  late TextEditingController _nameController;
  late List<String> _dhikrIds;
  late List<int> _counts;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.preset.name);
    _dhikrIds = List<String>.from(widget.preset.dhikrIds);
    _counts = List<int>.from(widget.preset.counts);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  'Edit Combination',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Preset Name',
                      hintText: 'e.g. Morning Routine',
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(3, (index) => _buildSlotEditor(index)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        final updated = widget.preset.copyWith(
                          name: _nameController.text.isEmpty
                              ? 'Combination'
                              : _nameController.text,
                          dhikrIds: _dhikrIds,
                          counts: _counts,
                        );
                        ref
                            .read(settingsProvider.notifier)
                            .saveComboPreset(updated);

                        // Sync total target if this is the active preset
                        final settings = ref.read(settingsProvider);
                        final activeIndex = settings.activeComboIndex;
                        if (activeIndex >= 0 &&
                            settings.comboPresets[activeIndex].id ==
                                updated.id) {
                          final totalSum = updated.counts.fold(
                            0,
                            (sum, item) => sum + item,
                          );
                          ref.read(countRepositoryProvider).setTarget(totalSum);
                        }

                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotEditor(int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dhikrId = _dhikrIds[index];
    final dhikr = dhikrList.firstWhere(
      (d) => d.id == dhikrId,
      orElse: () => dhikrList.first,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  DhikrSheet.show(
                    context,
                    onSelected: (selected) {
                      setState(() => _dhikrIds[index] = selected.id);
                      Navigator.pop(context);
                    },
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dhikr.transliteration,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            dhikr.arabic,
                            style: AppTypography.arabicLabel(
                              colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 32),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => TargetGoalSheet(
                    onSelected: (newTarget) {
                      setState(() => _counts[index] = newTarget);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              child: Column(
                children: [
                  Text(
                    '${_counts[index]}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const Text(
                    'GOAL',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
