import 'package:easy_tasweeh/core/constants/app_constants.dart';
import 'package:easy_tasweeh/features/analytics/screens/analytics_screen.dart';
import 'package:easy_tasweeh/features/history/screens/history_screen.dart';
import 'package:easy_tasweeh/features/settings/screens/settings_screen.dart';
import 'package:easy_tasweeh/features/tasbeeh/screens/tasbeeh_screen.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: 300,
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          // Premium Header
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.settings_input_antenna_rounded,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'v${AppConstants.appVersion}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        _DrawerTile(
                          context,
                          icon: Icons.auto_graph_rounded,
                          title: 'Analytics',
                          iconColor: Colors.blue,
                          screen: const AnalyticsScreen(),
                        ),
                        _divider(context),
                        _DrawerTile(
                          context,
                          icon: Icons.history_rounded,
                          title: 'History Log',
                          iconColor: Colors.orange,
                          screen: const HistoryScreen(),
                        ),
                        _divider(context),
                        _DrawerTile(
                          context,
                          icon: Icons.menu_book_rounded,
                          title: 'Learn Tasweeh',
                          iconColor: Colors.green,
                          screen: const TasweehScreen(),
                        ),
                        _divider(context),
                        _DrawerTile(
                          context,
                          icon: Icons.settings_rounded,
                          title: 'Settings',
                          iconColor: Colors.grey,
                          screen: const SettingsScreen(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Footer
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'MADE WITH LOVE FOR THE UMMAH',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.outline.withValues(alpha: 0.5),
                fontSize: 8,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Widget screen;

  const _DrawerTile(
    BuildContext context, {
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.outlineVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
