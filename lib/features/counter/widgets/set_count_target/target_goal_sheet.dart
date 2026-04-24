import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/archive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TargetGoalSheet extends ConsumerWidget {
  const TargetGoalSheet({super.key});

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
                  borderRadius: BorderRadius.circular(12),
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

          // Target Selection Card
          Container(
            decoration: BoxDecoration(color: colorScheme.surfaceContainerLow),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemCount: targets.length + 1,
              itemBuilder: (context, index) {
                final isInfinite = index == targets.length;
                final target = isInfinite ? 0 : targets[index];
                final isSelected = currentTarget == target;

                return InkWell(
                  onTap: () {
                    final currentCount =
                        countAsync.asData?.value?.currentCount ?? 0;
                    if (currentCount > 0) {
                      showDialog(
                        context: context,
                        builder: (_) => PremiumDialog(
                          icon: Icons.track_changes_rounded,
                          title: 'Save session?',
                          description:
                              'This will save your current progress to history.',
                          confirmLabel: 'Archive',
                          onConfirm: () {
                            ref.read(countRepositoryProvider).saveAndReset();
                            ref.read(countRepositoryProvider).setTarget(target);
                            Navigator.pop(context); // Close sheet
                          },
                        ),
                      );
                    } else {
                      ref.read(countRepositoryProvider).setTarget(target);
                      Navigator.pop(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withValues(alpha: 0.5),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: const [],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isInfinite ? '∞' : '$target',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Session Actions
          _sessionActionButton(
            context,
            ref,
            currentCount: countAsync.asData?.value?.currentCount ?? 0,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

Widget _sessionActionButton(
  BuildContext context,
  WidgetRef ref, {
  required int currentCount,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final appColors = Theme.of(context).extension<AppColors>();

  if (currentCount > 0) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => const ArchiveDialog(),
          );
        },
        icon: const Icon(Icons.archive_outlined, size: 18),
        label: const Text(
          'Archive Session',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: FilledButton.styleFrom(
          backgroundColor: appColors?.destructiveColor.withValues(alpha: 0.1),
          foregroundColor: appColors?.destructiveColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  } else {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () async {
          final success = await ref
              .read(countRepositoryProvider)
              .restoreLastSession();
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? 'Last incomplete session restored'
                      : 'No eligible session found to restore',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        icon: const Icon(Icons.restore_rounded, size: 18),
        label: const Text(
          'Restore Last Session',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
