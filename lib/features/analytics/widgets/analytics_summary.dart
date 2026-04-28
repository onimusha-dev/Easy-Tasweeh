import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
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

    return buildSettingsGroup(
      context,
      title: 'Summary',
      children: [
        buildSettingTile(
          context,
          icon: Icons.insights_rounded,
          title: 'Total sessions',
          subtitle: 'Sessions completed',
          iconColor: colorScheme.primary,
          trailingLabel: '$totalSessions',
          showChevron: false,
        ),
        buildSettingTile(
          context,
          icon: Icons.workspace_premium_rounded,
          title: 'Best session',
          subtitle: 'Single highest count',
          iconColor: Colors.amber,
          trailingLabel: '$maxSession',
          showChevron: false,
        ),
        buildSettingTile(
          context,
          icon: Icons.all_inclusive_rounded,
          title: 'Total count',
          subtitle: 'Lifetime tasbeeh count',
          iconColor: Colors.orange,
          trailingLabel: '$totalCount',
          showChevron: false,
        ),
      ],
    );
  }
}
