import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/core/service/package_info_provider.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:easy_tasbeeh/features/analytics/screens/analytics_screen.dart';
import 'package:easy_tasbeeh/features/history/screens/history_screen.dart';
import 'package:easy_tasbeeh/features/learning/hub/screens/learn_screen.dart';
import 'package:easy_tasbeeh/features/left_menu_bar/widgets/drawer_header.dart';
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
      elevation: 0,
      child: Column(
        children: [
          AppDrawerHeader(appVersion: appVersion),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _DrawerGroup(
                  children: [
                    _DrawerTile(
                      isFirst: true,
                      icon: Icons.auto_graph_rounded,
                      title: 'Analytics',
                      iconColor: AppIconColors.orange(context),
                      screen: const AnalyticsScreen(),
                    ),
                    _DrawerTile(
                      icon: Icons.history_rounded,
                      title: 'History Log',
                      iconColor: AppIconColors.blue(context),
                      screen: const HistoryScreen(),
                    ),
                    _DrawerTile(
                      icon: Icons.menu_book_rounded,
                      title: 'Learning Hub',
                      iconColor: AppIconColors.purple(context),
                      screen: const LearnScreen(),
                    ),
                    _DrawerTile(
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      iconColor: AppIconColors.sage(context),
                      screen: const SettingsScreen(),
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bottom Footer
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.1)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: 14,
                      color: colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Made for the Ummah',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerGroup extends StatelessWidget {
  final List<Widget> children;

  const _DrawerGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Widget screen;
  final bool isFirst;
  final bool isLast;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.screen,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final borderRadius = BorderRadius.vertical(
      top: isFirst ? const Radius.circular(16) : Radius.zero,
      bottom: isLast ? const Radius.circular(16) : Radius.zero,
    );

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
            borderRadius: borderRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.outlineVariant,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 64,
            endIndent: 16,
            color: colorScheme.outlineVariant.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}
