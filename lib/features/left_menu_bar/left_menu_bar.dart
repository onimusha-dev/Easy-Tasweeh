import 'package:easy_tasweeh/features/left_menu_bar/membership_card.dart';
import 'package:easy_tasweeh/screens/analytics_screen.dart';
import 'package:easy_tasweeh/screens/challenges_screen.dart';
import 'package:easy_tasweeh/screens/history_screen.dart';
import 'package:easy_tasweeh/screens/settings_screen.dart';
import 'package:easy_tasweeh/screens/tasbeeh_screen.dart';
import 'package:flutter/material.dart';

class LeftMenuBar extends StatelessWidget {
  const LeftMenuBar({super.key});

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
                      'Easy Tasweeh',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'v1.0.0',
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
                const MembershipCard(),
                _buildDrawerTile(
                  context,
                  icon: Icons.graphic_eq_outlined,
                  title: 'Analytics',
                  moveToScreen: AnalyticsScreen(),
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.group_outlined,
                  title: 'Challenges',
                  moveToScreen: ChallengesScreen(),
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.history_rounded,
                  title: 'History',
                  moveToScreen: HistoryScreen(),
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.menu_book_rounded,
                  title: 'Learn Tasweeh',
                  moveToScreen: TasweehScreen(),
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  moveToScreen: SettingsScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDrawerTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required moveToScreen,
}) {
  return ListTile(
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
    title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => moveToScreen),
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
