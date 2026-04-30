import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/session_action_button.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/target_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TargetGoalSheet extends ConsumerWidget {
  final Function(int)? onSelected;
  const TargetGoalSheet({super.key, this.onSelected});

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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
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
          Row(
            children: [
              Container(
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
          const SizedBox(height: 24),

          // Target Selection Grid
          TargetGrid(
            targets: targets,
            currentTarget: currentTarget,
            countAsync: countAsync,
            onSelected: onSelected,
          ),
          const SizedBox(height: 24),

          // Session Actions
          SessionActionButton(
            currentCount: countAsync.asData?.value?.currentCount ?? 0,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
