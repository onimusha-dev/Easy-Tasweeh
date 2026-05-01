import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:flutter/material.dart';

class HistoryTotalsCard extends StatelessWidget {
  final List<CountHistoryTableData> history;

  const HistoryTotalsCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final totalCounts = history.fold<int>(
      0,
      (sum, item) => sum + item.currentCount,
    );
    final totalSessions = history.length;
    final completedSessions = history
        .where(
          (item) =>
              item.targetCount > 0 && item.currentCount >= item.targetCount,
        )
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Counts',
            value: totalCounts.toString(),
            icon: Icons.functions_rounded,
            iconColor: Colors.indigo,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Sessions',
            value: totalSessions.toString(),
            icon: Icons.history_rounded,
            iconColor: Colors.cyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Goals',
            value: completedSessions.toString(),
            icon: Icons.task_alt_rounded,
            iconColor: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
