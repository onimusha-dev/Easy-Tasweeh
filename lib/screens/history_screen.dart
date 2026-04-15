import 'package:easy_tasweeh/database/dao/count_history_dao.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History Log',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: StreamBuilder<List<CountHistoryTableData>>(
        stream: ref.watch(countHistoryDaoProvider).watchAllHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final historyList = snapshot.data ?? [];

          if (historyList.isEmpty) {
            return Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history_toggle_off_rounded, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'No sessions documented.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            itemCount: historyList.length,
            separatorBuilder: (context, index) => Divider(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.3),
              height: 1,
            ),
            itemBuilder: (context, index) {
              return HistoryItemCard(data: historyList[index], index: index);
            },
          );
        },
      ),
    );
  }
}

class HistoryItemCard extends StatelessWidget {
  final CountHistoryTableData data;
  final int index;

  const HistoryItemCard({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy • HH:mm').format(data.createdAt);
    final isSuccess =
        data.targetCount > 0 && data.currentCount >= data.targetCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${data.currentCount}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isSuccess
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (data.targetCount > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '/ ${data.targetCount}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isSuccess)
            Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            )
          else if (data.targetCount > 0)
            Text(
              'PARTIAL',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05, delay: (index * 40).ms);
  }
}

// ignore: unused_element
void _clearHistory(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Clear All History'),
      content: const Text(
        'This action cannot be undone. Are you sure you want to delete all saved sessions?',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () {
            ref.read(countHistoryDaoProvider).deleteAll();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('History cleared'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: const Text('CLEAR ALL'),
        ),
      ],
    ),
  );
}
