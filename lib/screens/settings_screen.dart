import 'package:easy_tasweeh/features/settings/screens/about_support_screen.dart';
import 'package:easy_tasweeh/features/settings/screens/appearance_screen.dart';
import 'package:easy_tasweeh/features/settings/screens/counter_defaults_screen.dart';
import 'package:easy_tasweeh/features/settings/screens/data_screen.dart';
import 'package:easy_tasweeh/features/settings/screens/reminders_screen.dart';
import 'package:easy_tasweeh/features/settings/screens/sound_haptics_screen.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 8),

          // ── Sections ───────────────────────────────────────────────────────
          buildSettingTile(
            context,
            icon: Icons.brightness_6_outlined,
            title: 'Appearance',
            subtitle: 'Theme, accent, counter style, font size',
            onTap: () => _push(context, const AppearanceScreen()),
          ),
          buildSettingTile(
            context,
            icon: Icons.vibration_rounded,
            title: 'Sound & Haptics',
            subtitle: 'Tap sound, haptic feedback, intensity',
            onTap: () => _push(context, const SoundHapticsScreen()),
          ),
          buildSettingTile(
            context,
            icon: Icons.notifications_active_outlined,
            title: 'Reminders',
            subtitle: 'Daily dhikr reminders & salah prompts',
            onTap: () => _push(context, const RemindersScreen()),
          ),
          buildSettingTile(
            context,
            icon: Icons.gps_fixed_rounded,
            title: 'Counter Defaults',
            subtitle: 'Goal, dhikr, auto-reset, session resume',
            onTap: () => _push(context, const CounterDefaultsScreen()),
          ),
          buildSettingTile(
            context,
            icon: Icons.info_outline_rounded,
            title: 'About & Support',
            subtitle: 'Version, donate, GitHub, feedback',
            onTap: () => _push(context, const AboutSupportScreen()),
          ),
          buildSettingTile(
            context,
            icon: Icons.storage_outlined,
            title: 'Data',
            subtitle: 'Export history, reset all data',
            onTap: () => _push(context, const DataScreen()),
          ),

          // ── Footer ─────────────────────────────────────────────────────────
          const SizedBox(height: 36),
          Center(
            child: Text(
              'Easy Tasbeeh v1.0.0 · MIT License · Non-profit',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
