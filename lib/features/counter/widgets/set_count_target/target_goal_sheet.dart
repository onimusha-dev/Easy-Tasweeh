import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TargetGoalSheet extends ConsumerWidget {
  final Function(int)? onSelected;
  final bool showInfinite;
  const TargetGoalSheet({super.key, this.onSelected, this.showInfinite = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<int> targets = [10, 33, 100, 300, 500];
    final colorScheme = Theme.of(context).colorScheme;

    final countAsync = ref.watch(currentCountStreamProvider);
    final currentTarget = countAsync.when(
      data: (data) => data?.targetCount ?? 0,
      loading: () => -1,
      error: (_, _) => 0,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppLayout.brSheet,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppLayout.spaceLarge,
        AppLayout.spaceMedium,
        AppLayout.spaceLarge,
        0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.track_changes_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Target Goal',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Choose how many counts for this session',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Target Selection Grid
          TargetGrid(
            targets: targets,
            currentTarget: currentTarget,
            countAsync: countAsync,
            onSelected: onSelected,
            showInfinite: showInfinite,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
