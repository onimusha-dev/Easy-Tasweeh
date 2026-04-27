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
            colors: [
              const Color(0xFF6366F1),
              const Color(0xFF4F46E5),
            ], // Indigo
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Sessions',
            value: totalSessions.toString(),
            icon: Icons.history_rounded,
            colors: [const Color(0xFF06B6D4), const Color(0xFF0891B2)], // Cyan
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Goals',
            value: completedSessions.toString(),
            icon: Icons.task_alt_rounded,
            colors: [
              const Color(0xFF10B981),
              const Color(0xFF059669),
            ], // Emerald
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
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 18),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
