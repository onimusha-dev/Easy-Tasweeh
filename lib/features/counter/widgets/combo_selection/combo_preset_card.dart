import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComboPresetCard extends ConsumerWidget {
  final ComboPreset preset;
  final int index;
  final bool isSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const ComboPresetCard({
    super.key,
    required this.preset,
    required this.index,
    required this.isSelected,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: onSelect,
        behavior: HitTestBehavior.opaque,
        child: buildSettingsGroup(
          context,
          showBorder: true,
          borderColor: isSelected ? colorScheme.primary : null,
          borderWidth: 1.5,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                // horizontal: 20,
                // vertical: 14,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Icon(
                      Icons.view_carousel_rounded,
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
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 22,
                      color: colorScheme.error.withValues(alpha: 0.6),
                    ),
                    visualDensity: VisualDensity.compact,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: colorScheme.outlineVariant,
                    ),
                    visualDensity: VisualDensity.compact,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
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
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${preset.counts[i]}',
                          style: textTheme.titleMedium?.copyWith(
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
