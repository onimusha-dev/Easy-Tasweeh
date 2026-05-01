import 'package:easy_tasbeeh/core/constants/app_constants.dart';
import 'package:easy_tasbeeh/core/service/package_info_provider.dart';
import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:easy_tasbeeh/features/settings/screens/barrel.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appVersionProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSettingsGroup(
            context,
            title: "General",
            children: [
              buildSettingTile(
                context,
                icon: Icons.brightness_6_outlined,
                title: 'Appearance',
                subtitle: 'Theme, accent, counter style, font size',
                iconColor: AppIconColors.purple(context),
                onTap: () => _push(context, const AppearanceScreen()),
              ),
              buildSettingTile(
                context,
                icon: Icons.vibration_rounded,
                title: 'Sound & Haptics',
                subtitle: 'Tap sound, haptic feedback, vibration',
                iconColor: AppIconColors.amber(context),
                onTap: () => _push(context, const SoundHapticsScreen()),
              ),
              buildSettingTile(
                context,
                icon: Icons.notifications_active_outlined,
                title: 'Reminders',
                subtitle: 'Daily dhikr reminders & salah prompts',
                iconColor: AppIconColors.blue(context),
                onTap: () => _push(context, const RemindersScreen()),
              ),
            ],
          ),

          buildSettingsGroup(
            context,
            title: "Others",
            children: [
              buildSettingTile(
                context,
                icon: Icons.storage_outlined,
                title: 'Data',
                subtitle: 'Backup, restore, delete all data',
                iconColor: Colors.green,
                onTap: () => _push(context, DataPrivacyScreen()),
              ),
              buildSettingTile(
                context,
                icon: Icons.info_outline_rounded,
                title: 'About & Support',
                subtitle: 'Donate, feedback, suggest a feature',
                iconColor: Colors.grey,
                onTap: () => _push(context, const AboutSupportScreen()),
              ),
            ],
          ),

          // ── Footer ─────────────────────────────────────────────────────────
          const SizedBox(height: 64),
          Center(
            child: Text(
              '${AppConstants.appName} v$appVersion · Non-profit',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
