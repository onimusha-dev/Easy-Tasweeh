import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TargetGrid extends ConsumerWidget {
  final List<int> targets;
  final int currentTarget;
  final AsyncValue<dynamic> countAsync;
  final Function(int)? onSelected;

  const TargetGrid({
    super.key,
    required this.targets,
    required this.currentTarget,
    required this.countAsync,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
              if (onSelected != null) {
                onSelected!(target);
                return;
              }
              final repo = ref.read(countRepositoryProvider);
              final currentCount =
                  (countAsync.value as dynamic)?.currentCount ?? 0;

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
                      repo.saveAndReset();
                      repo.setTarget(target);
                      Navigator.pop(context); // Close bottom sheet
                    },
                  ),
                );
              } else {
                repo.saveAndReset();
                repo.setTarget(target);
                Navigator.pop(context);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
    );
  }
}
