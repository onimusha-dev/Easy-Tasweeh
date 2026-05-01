import 'package:easy_tasbeeh/features/analytics/widgets/analytics_widgets.dart';
import 'package:flutter/material.dart';

class AnalyticsSummary extends StatelessWidget {
  final int totalSessions;
  final int maxSession;
  final int totalCount;

  const AnalyticsSummary({
    super.key,
    required this.totalSessions,
    required this.maxSession,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnalyticsSection(
      title: 'Summary',
      children: [
        AnalyticsTile(
          icon: Icons.insights_rounded,
          title: 'Total sessions',
          subtitle: 'Sessions completed',
          iconColor: colorScheme.primary,
          value: '$totalSessions',
        ),
        AnalyticsTile(
          icon: Icons.workspace_premium_rounded,
          title: 'Best session',
          subtitle: 'Single highest count',
          iconColor: Colors.amber,
          value: '$maxSession',
        ),
        AnalyticsTile(
          icon: Icons.all_inclusive_rounded,
          title: 'Total count',
          subtitle: 'Lifetime tasbeeh count',
          iconColor: Colors.orange,
          value: '$totalCount',
        ),
      ],
    );
  }
}
