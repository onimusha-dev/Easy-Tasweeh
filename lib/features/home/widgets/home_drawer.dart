import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  final VoidCallback onShowHistory;
  final VoidCallback onShowAnalytics;
  final VoidCallback onShowTasweeh;
  final VoidCallback onShowSettings;

  const HomeDrawer({
    super.key,
    required this.onShowHistory,
    required this.onShowAnalytics,
    required this.onShowSettings,
    required this.onShowTasweeh,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280, // More compact width
      child: Column(
        children: [
          // Custom compact header
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.settings_input_antenna_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'EASY TASWEEH',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'v1.0.0',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Become a member',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our commitment to keep Easy Tasweeh ad-free is possible because of the support of people like you.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text('Become a member'),
                      ),
                    ],
                  ),
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.graphic_eq_outlined,
                  title: 'Analytics',
                  onTap: () {
                    Navigator.pop(context);
                    onShowAnalytics();
                  },
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
                  icon: Icons.menu_book_rounded,
                  title: 'Learn Tasweeh',
                  onTap: () {
                    Navigator.pop(context);
                    onShowTasweeh();
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
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
      dense: true, // Makes it more compact
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      visualDensity: const VisualDensity(
        horizontal: 0,
        vertical: -2,
      ), // Further compaction
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
