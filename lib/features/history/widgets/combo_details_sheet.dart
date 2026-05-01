import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComboDetailsSheet extends ConsumerWidget {
  final CountHistoryTableData data;

  const ComboDetailsSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = ref.watch(settingsProvider);

    final preset = settings.comboPresets.firstWhere(
      (p) => p.name == data.comboName,
      orElse: () => settings.comboPresets.isNotEmpty
          ? settings.comboPresets.first
          : const ComboPreset(
              id: '',
              name: 'Deleted Preset',
              dhikrIds: [],
              counts: [],
            ),
    );

    final List<Map<String, dynamic>> segments = [];
    int cumulative = 0;

    for (int i = 0; i < preset.counts.length; i++) {
      final target = preset.counts[i];
      final dhikrId = preset.dhikrIds[i];
      int current = 0;

      if (data.currentCount > cumulative) {
        current = (data.currentCount - cumulative).clamp(0, target);
      }

      segments.add({
        'dhikr': dhikrList.firstWhere(
          (d) => d.id == dhikrId,
          orElse: () => dhikrList.first,
        ),
        'current': current,
        'target': target,
      });
      cumulative += target;
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.comboName ?? 'Combo Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sequence Breakdown',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${data.currentCount}/${data.targetCount}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: segments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final segment = entry.value;
                    final dhikr = segment['dhikr'] as DhikrItem;
                    final current = segment['current'] as int;
                    final target = segment['target'] as int;

                    final isCompleted = current >= target;
                    final isPartial = current > 0 && current < target;

                    final Color stateColor = isCompleted
                        ? Colors.greenAccent
                        : (isPartial
                              ? Colors.amberAccent
                              : Colors.redAccent.withValues(alpha: 0.7));

                    final progress = (current / target).clamp(0.0, 1.0);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: stateColor.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: stateColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: isCompleted
                                    ? Icon(
                                        Icons.check_rounded,
                                        color: stateColor,
                                        size: 16,
                                      )
                                    : Text(
                                        '${index + 1}',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: stateColor,
                                              fontSize: 10,
                                            ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dhikr.arabic,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        '$current/$target',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: stateColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    dhikr.transliteration,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: colorScheme.surface,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        stateColor,
                                      ),
                                      minHeight: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, CountHistoryTableData data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ComboDetailsSheet(data: data),
    );
  }
}
