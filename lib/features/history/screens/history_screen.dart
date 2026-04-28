import 'package:collection/collection.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/dao/count_history_dao.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:easy_tasbeeh/features/history/widgets/empty_history_view.dart';
import 'package:easy_tasbeeh/features/history/widgets/history_item_card.dart';
import 'package:easy_tasbeeh/features/history/widgets/history_totals_card.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
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
            return const EmptyHistoryView();
          }

          // Group by date
          final grouped = groupBy(historyList, (CountHistoryTableData data) {
            return DateFormat('yyyy-MM-dd').format(data.createdAt);
          });

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              const SizedBox(height: 8),
              HistoryTotalsCard(history: historyList),
              const SizedBox(height: 24),
              ...grouped.entries.map((entry) {
                final dateStr = entry.key;
                final items = entry.value;

                // Format date label (Today, Yesterday, or Date)
                final date = DateTime.parse(dateStr);
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final yesterday = today.subtract(const Duration(days: 1));

                String label;
                if (date == today) {
                  label = 'Today';
                } else if (date == yesterday) {
                  label = 'Yesterday';
                } else {
                  label = DateFormat('MMMM d, yyyy').format(date);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: buildSettingsGroup(
                    context,
                    title: label,
                    children: items.mapIndexed((idx, data) {
                      return HistoryItemCard(
                        data: data,
                        index: idx,
                        isLast: idx == items.length - 1,
                      );
                    }).toList(),
                  ),
                );
              }),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

// ignore: unused_element
void _clearHistory(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => PremiumDialog(
      icon: Icons.delete_sweep_rounded,
      title: 'Clear All History',
      description:
          'This action cannot be undone. Are you sure you want to delete all saved sessions?',
      confirmLabel: 'CLEAR ALL',
      color: Theme.of(context).colorScheme.error,
      onConfirm: () {
        ref.read(countHistoryDaoProvider).deleteAll();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('History cleared'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    ),
  );
}
