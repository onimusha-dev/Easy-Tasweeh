import 'package:easy_tasweeh/database/dao/count_history_dao.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HISTORY LOG',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () => _clearHistory(context, ref),
            icon: const Icon(Icons.delete_forever_rounded),
            color: Theme.of(context).colorScheme.error,
            tooltip: 'Clear History',
          ),
          const SizedBox(width: 8),
        ],
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final history = historyList[index];
              final dateStr = DateFormat('MMM d, yyyy • HH:mm').format(history.createdAt);
              final isSuccess = history.targetCount > 0 && history.currentCount >= history.targetCount;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${history.currentCount}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isSuccess
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateStr,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (history.targetCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'GOAL: ${history.targetCount}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isSuccess
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ),
                  ],
                ),
              ).animate().fadeIn().slideX(begin: 0.05, delay: (index * 40).ms);
            },
          );
        },
      ),
    );
  }
}
