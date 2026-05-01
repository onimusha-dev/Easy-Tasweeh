import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:easy_tasbeeh/core/widgets/app_section.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_selection_sheet/dhikr_sheet.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_goal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PresetEditSheet extends ConsumerStatefulWidget {
  final ComboPreset preset;
  const PresetEditSheet({super.key, required this.preset});

  @override
  ConsumerState<PresetEditSheet> createState() => _PresetEditSheetState();
}

class _PresetEditSheetState extends ConsumerState<PresetEditSheet> {
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset > 0 ? 100 : 0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppLayout.brSheet,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              Flexible(
                child: SingleChildScrollView(
                  padding: AppLayout.sheetPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSection(
                        title: 'Sequence Name',
                        padding: const EdgeInsets.only(bottom: 4),
                        children: [
                          TextField(
                            controller: _nameController,
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Sequence Name',
                              hintText: 'e.g. Morning Routine',
                              filled: true,
                              fillColor: colorScheme.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppLayout.radiusMedium,
                                ),
                                borderSide: BorderSide(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppLayout.radiusMedium,
                                ),
                                borderSide: BorderSide(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppLayout.radiusMedium,
                                ),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.edit_note_rounded),
                            ),
                          ),
                        ],
                      ),

                      AppSection(
                        title: 'Sequence Slots',
                        padding: const EdgeInsets.only(bottom: 2),
                        children: List.generate(
                          _dhikrIds.length,
                          (index) => _buildSlotEditor(index),
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: _dhikrIds.length >= 10
                                  ? null
                                  : () {
                                      setState(() {
                                        _dhikrIds.add('subhanallah');
                                        _counts.add(33);
                                      });
                                    },
                              icon: const Icon(Icons.add_rounded, size: 20),
                              label: const Text('Add Slot'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppLayout.radiusMedium,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_dhikrIds.length > 1) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: () {
                                  setState(() {
                                    _dhikrIds.removeLast();
                                    _counts.removeLast();
                                  });
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline_rounded,
                                  size: 20,
                                ),
                                label: const Text('Remove'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  foregroundColor: colorScheme.error,
                                  backgroundColor: colorScheme.errorContainer
                                      .withValues(alpha: 0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppLayout.radiusMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
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

                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Save Sequence',
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
        ),
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

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppLayout.spaceTileGap),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dhikr.transliteration,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dhikr.arabic,
                  style: AppTypography.arabicLabel(
                    colorScheme.onSurface.withValues(alpha: 0.6),
                  ).copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => TargetGoalSheet(
                  showInfinite: false,
                  onSelected: (newTarget) {
                    setState(() => _counts[index] = newTarget);
                    Navigator.pop(context);
                  },
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_counts[index]}',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary,
                      fontSize: 14,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'GOAL',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary.withValues(alpha: 0.6),
                      letterSpacing: 1.0,
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
}
