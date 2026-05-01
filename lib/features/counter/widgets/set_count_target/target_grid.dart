import 'package:easy_tasbeeh/core/widgets/save_progress_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TargetGrid extends ConsumerWidget {
  final List<int> targets;
  final int currentTarget;
  final AsyncValue<dynamic> countAsync;
  final Function(int)? onSelected;
  final bool showInfinite;

  const TargetGrid({
    super.key,
    required this.targets,
    required this.currentTarget,
    required this.countAsync,
    this.onSelected,
    this.showInfinite = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: targets.length + (showInfinite ? 1 : 0),
      itemBuilder: (context, index) {
        final isInfinite = showInfinite && index == targets.length;
        final target = isInfinite ? 0 : targets[index];
        final isSelected = currentTarget == target;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (onSelected != null) {
                onSelected!(target);
                return;
              }
              final repo = ref.read(countRepositoryProvider);
              final currentCount =
                  (countAsync.value as dynamic)?.currentCount ?? 0;

              if (currentCount > 0) {
                SaveProgressDialog.show(
                  context,
                  title: 'Save session?',
                  description:
                      'This will save your current progress to history.',
                  confirmLabel: 'Archive',
                  onConfirm: () {
                    repo.setTarget(target);
                    Navigator.pop(context); // Close bottom sheet
                  },
                );
              } else {
                repo.setTarget(target);
                Navigator.pop(context); // Close bottom sheet
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.12)
                    : colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: colorScheme.primary, width: 1.5)
                    : null,
              ),
              child: Center(
                child: Text(
                  isInfinite ? '∞' : '$target',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
