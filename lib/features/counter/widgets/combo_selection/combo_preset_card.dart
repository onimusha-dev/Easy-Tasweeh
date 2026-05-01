import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/core/widgets/app_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComboPresetCard extends ConsumerWidget {
  final ComboPreset preset;
  final int index;
  final bool isSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSelect;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const ComboPresetCard({
    super.key,
    required this.preset,
    required this.index,
    required this.isSelected,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
    this.onMoveUp,
    this.onMoveDown,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppLayout.spaceTileGap),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.08)
            : colorScheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        // Persistent border to prevent layout shift
        border: Border.all(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 1, // Smaller border width
        ),
      ),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.15)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.style_rounded,
                      size: 22,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preset.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${preset.dhikrIds.length} Dhikrs in sequence',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppMenuButton(
                    offsetRight: 8,
                    items: [
                      AppMenuItem(
                        value: 'edit',
                        label: 'Edit',
                        icon: Icons.edit_rounded,
                      ),
                      if (onMoveUp != null)
                        AppMenuItem(
                          value: 'move_up',
                          label: 'Move Up',
                          icon: Icons.arrow_upward_rounded,
                        ),
                      if (onMoveDown != null)
                        AppMenuItem(
                          value: 'move_down',
                          label: 'Move Down',
                          icon: Icons.arrow_downward_rounded,
                        ),
                      AppMenuItem(
                        value: 'delete',
                        label: 'Delete',
                        icon: Icons.delete_outline_rounded,
                        isDestructive: true,
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'move_up') {
                        onMoveUp?.call();
                      } else if (value == 'move_down') {
                        onMoveDown?.call();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
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

                  if (dhikr == null) return const Spacer();

                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          dhikr.transliteration.split(' ').first.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          preset.counts.length > i
                              ? '${preset.counts[i]}'
                              : '-',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
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
    );
  }
}
