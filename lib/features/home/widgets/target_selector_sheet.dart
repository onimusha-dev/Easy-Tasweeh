import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TargetSelectorSheet extends ConsumerWidget {
  const TargetSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // null = free mode (no target)
    final List<int?> targets = [100, 200, 300, 500, 1000, null];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Set Goal',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'How many counts per session?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            itemCount: targets.length,
            itemBuilder: (context, index) {
              final target = targets[index];
              final isFree = target == null;
              return InkWell(
                onTap: () {
                  ref.read(countRepositoryProvider).setTarget(target ?? 0);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isFree
                        ? Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.4)
                        : Theme.of(context).colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                    border: Border.all(
                      color: isFree
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.5)
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isFree ? '∞' : '$target',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        if (isFree)
                          Text(
                            'Free',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
