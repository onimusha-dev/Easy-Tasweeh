import 'package:easy_tasbeeh/core/constants/app_constants.dart';
import 'package:easy_tasbeeh/features/analytics/screens/analytics_screen.dart';
import 'package:easy_tasbeeh/features/history/screens/history_screen.dart';
import 'package:easy_tasbeeh/features/learning/hub/screens/learn_screen.dart';
import 'package:easy_tasbeeh/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:easy_tasbeeh/core/service/package_info_provider.dart';
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
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
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
                          icon: Icons.auto_graph_rounded,
                          title: 'Analytics',
                          iconColor: Colors.blue,
                          screen: const AnalyticsScreen(),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
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
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
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
  final BorderRadius? borderRadius;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.screen,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: InkWell(
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
      ),
    );
  }
}
