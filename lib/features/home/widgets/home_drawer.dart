import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  final VoidCallback onShowHistory;
  final VoidCallback onShowAnalytics;
  final VoidCallback onShowSettings;

  const HomeDrawer({
    super.key,
    required this.onShowHistory,
    required this.onShowAnalytics,
    required this.onShowSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings_input_antenna_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'EASY TASWEEH',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  context,
                  icon: Icons.home_rounded,
                  title: 'Home',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.history_rounded,
                  title: 'History',
                  onTap: () {
                    Navigator.pop(context);
                    onShowHistory();
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.analytics_rounded,
                  title: 'Analytics',
                  onTap: () {
                    Navigator.pop(context);
                    onShowAnalytics();
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    onShowSettings();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'v1.0.0',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
