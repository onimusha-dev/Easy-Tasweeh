import 'package:easy_tasbeeh/core/constants/app_constants.dart';
import 'package:easy_tasbeeh/core/service/package_info_provider.dart';
import 'package:easy_tasbeeh/features/analytics/screens/analytics_screen.dart';
import 'package:easy_tasbeeh/features/history/screens/history_screen.dart';
import 'package:easy_tasbeeh/features/learning/hub/screens/learn_screen.dart';
import 'package:easy_tasbeeh/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appVersionProvider);
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 52,
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.appName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                        ),
                        Text(
                          'v$appVersion',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: colorScheme.outline),
                        ),
                      ],
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
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                  ),
                  child: Column(
                    children: [
                      _DrawerTile(
                        icon: Icons.auto_graph_rounded,
                        title: 'Analytics',
                        iconColor: Colors.blue,
                        screen: const AnalyticsScreen(),
                      ),
                      _divider(context),
                      _DrawerTile(
                        icon: Icons.history_rounded,
                        title: 'History Log',
                        iconColor: Colors.orange,
                        screen: const HistoryScreen(),
                      ),
                      _divider(context),
                      _DrawerTile(
                        icon: Icons.menu_book_rounded,
                        title: 'Learning Hub',
                        iconColor: Colors.green,
                        screen: const LearnScreen(),
                      ),
                      _divider(context),
                      _DrawerTile(
                        icon: Icons.settings_rounded,
                        title: 'Settings',
                        iconColor: Colors.grey,
                        screen: const SettingsScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Footerw
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Made with ❤️ for the Ummah',
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
      indent: 64, // Increased to match new internal padding
      endIndent: 20,
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

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Close drawer
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
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
      ),
    );
  }
}
