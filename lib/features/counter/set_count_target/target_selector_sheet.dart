import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:easy_tasweeh/features/counter/set_count_target/archive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TargetSelectorSheet extends ConsumerWidget {
  const TargetSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<int> targets = [100, 300, 500, 700, 1000, 2000];

    final countAsync = ref.watch(currentCountStreamProvider);
    final currentTarget = countAsync.when(
      data: (data) => data?.targetCount ?? 0,
      loading: () => -1,
      error: (_, _) => 0,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 72),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Set Target Goal',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose how many counts for this session',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
            ),
            itemCount: targets.length,
            itemBuilder: (context, index) {
              final target = targets[index];
              final isSelected = currentTarget == target;

              return InkWell(
                onTap: () {
                  ref.read(countRepositoryProvider).setTarget(target);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '$target',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildArchiveAndRestoreSessionActionButton(
            context,
            ref,
            currentCount: countAsync.asData?.value?.currentCount ?? 0,
          ),
        ],
      ),
    );
  }
}

Widget _buildArchiveAndRestoreSessionActionButton(
  BuildContext context,
  WidgetRef ref, {
  required int currentCount,
}) {
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
        icon: const Icon(Icons.archive_outlined, size: 20),
        label: const Text('ARCHIVE CURRENT SESSION'),
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  } else {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final success = await ref
              .read(countRepositoryProvider)
              .restoreLastSession();
          if (context.mounted) {
            Navigator.pop(context);
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
        icon: const Icon(Icons.restore_rounded, size: 20),
        label: const Text('RESTORE LAST SESSION'),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
    );
  }
}
