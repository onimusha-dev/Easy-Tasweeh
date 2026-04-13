import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:easy_tasweeh/core/service/dhikr_service.dart';
import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SelectorMode { goal, dhikr }

class TargetSelectorSheet extends ConsumerStatefulWidget {
  const TargetSelectorSheet({super.key});

  @override
  ConsumerState<TargetSelectorSheet> createState() =>
      _TargetSelectorSheetState();
}

class _TargetSelectorSheetState extends ConsumerState<TargetSelectorSheet> {
  SelectorMode _mode = SelectorMode.goal;

  @override
  Widget build(BuildContext context) {
    // null = free mode (no target)
    final List<int?> targets = [
      100,
      200,
      300,
      500,
      700,
      1000,
      2000,
      5000,
      null,
    ];

    final countAsync = ref.watch(currentCountStreamProvider);
    final currentTarget = countAsync.when(
      data: (data) => data?.targetCount ?? 0,
      loading: () => -1,
      error: (_, _) => 0,
    );

    final currentDhikr = ref.watch(currentDhikrProvider);

    // Sort dhikrList to put selected one at the top
    final sortedDhikrList = [...dhikrList];
    final selectedIdx = sortedDhikrList.indexOf(currentDhikr);
    if (selectedIdx != -1) {
      final item = sortedDhikrList.removeAt(selectedIdx);
      sortedDhikrList.insert(0, item);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
            _mode == SelectorMode.goal ? 'Set Goal' : 'Select Dhikr',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            _mode == SelectorMode.goal
                ? 'How many counts per session?'
                : 'What would you like to recite?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200, // Reduced to fit 3 goal rows perfectly
            child: _mode == SelectorMode.goal
                ? GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.8,
                        ),
                    itemCount: targets.length,
                    itemBuilder: (context, index) {
                      final target = targets[index];
                      final isFree = target == null;
                      final value = target ?? 0;
                      final isSelected = currentTarget == value;

                      return InkWell(
                        onTap: () {
                          ref.read(countRepositoryProvider).setTarget(value);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.5),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isFree ? '∞' : '$target',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onPrimary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                      ),
                                ),
                                if (isFree)
                                  Text(
                                    'Free',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontSize: 9,
                                          color: isSelected
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.7),
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.2,
                        ),
                    itemCount: sortedDhikrList.length,
                    itemBuilder: (context, index) {
                      final item = sortedDhikrList[index];
                      final isSelected = item == currentDhikr;

                      return InkWell(
                        onTap: () {
                          ref.read(currentDhikrProvider.notifier).state = item;
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.arabic,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : null,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.transliteration,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontSize: 11,
                                      color: isSelected
                                          ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withValues(alpha: 0.8)
                                          : Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _mode = SelectorMode.goal),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _mode == SelectorMode.goal
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    side: _mode == SelectorMode.goal ? BorderSide.none : null,
                  ),
                  child: const Text("GOAL"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _mode = SelectorMode.dhikr),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _mode == SelectorMode.dhikr
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    side: _mode == SelectorMode.dhikr ? BorderSide.none : null,
                  ),
                  child: const Text("DHIKR TYPE"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
