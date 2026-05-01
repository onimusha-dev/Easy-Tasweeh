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

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _selectedFilter = 'all'; // 'all', 'single', 'combo'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History Log',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () => _clearHistory(context, ref),
            icon: const Icon(Icons.delete_sweep_rounded),
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

          final rawHistoryList = snapshot.data ?? [];

          if (rawHistoryList.isEmpty) {
            return const EmptyHistoryView();
          }

          // Apply filter
          final historyList = rawHistoryList.where((item) {
            if (_selectedFilter == 'all') return true;
            return item.sessionMode == _selectedFilter;
          }).toList();

          // Group by date
          final grouped = groupBy(historyList, (CountHistoryTableData data) {
            return DateFormat('yyyy-MM-dd').format(data.createdAt);
          });

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              const SizedBox(height: 8),
              HistoryTotalsCard(history: rawHistoryList),
              const SizedBox(height: 20),
              
              // Filter Toggle
              Center(
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'all',
                      label: Text('All'),
                      icon: Icon(Icons.list_rounded, size: 18),
                    ),
                    ButtonSegment(
                      value: 'single',
                      label: Text('Single'),
                      icon: Icon(Icons.person_rounded, size: 18),
                    ),
                    ButtonSegment(
                      value: 'combo',
                      label: Text('Combo'),
                      icon: Icon(Icons.layers_rounded, size: 18),
                    ),
                  ],
                  selected: {_selectedFilter},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedFilter = newSelection.first;
                    });
                  },
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    selectedBackgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    selectedForegroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (historyList.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'No $_selectedFilter sessions found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),

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
                    showBorder: false,
                    isLargeTitle: true,
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
