import 'package:easy_tasweeh/core/constants/app_constants.dart';
import 'package:easy_tasweeh/core/utils/color_utils.dart';
import 'package:easy_tasweeh/features/analytics/screens/analytics_screen.dart';
import 'package:easy_tasweeh/features/history/screens/history_screen.dart';
import 'package:easy_tasweeh/features/settings/screens/settings_screen.dart';
import 'package:easy_tasweeh/features/tasbeeh/screens/tasbeeh_screen.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

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
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'v${AppConstants.appVersion}',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(fontSize: 10),
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
                // const MembershipCard(),
                _DrawerTile(
                  context,
                  'blue',
                  icon: Icons.graphic_eq_outlined,
                  title: 'Analytics',
                  screen: AnalyticsScreen(),
                ),
                _DrawerTile(
                  context,
                  'red',
                  icon: Icons.history_rounded,
                  title: 'History',
                  screen: HistoryScreen(),
                ),
                _DrawerTile(
                  context,
                  'green',
                  icon: Icons.menu_book_rounded,
                  title: 'Learn Tasweeh',
                  screen: TasweehScreen(),
                ),
                _DrawerTile(
                  context,
                  'grey',
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  screen: SettingsScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _DrawerTile(
  BuildContext context,
  String? iconColor, {
  required IconData icon,
  required String title,
  required Widget screen,
}) {
  return ListTile(
    leading: Icon(icon, color: setIconsColor(iconColor), size: 20),
    title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    },
    dense: true, // Makes it more compact
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    visualDensity: const VisualDensity(
      horizontal: 0,
      vertical: -2,
    ), // Further compaction
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
