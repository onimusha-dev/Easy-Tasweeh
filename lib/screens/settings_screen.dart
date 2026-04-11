import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSectionTitle(context, 'NOTIFICATIONS'),
          ),
          const SizedBox(height: 8),
          _buildSettingTile(
            context,
            icon: Icons.notifications_active_outlined,
            title: 'Permissions',
            subtitle: 'Request system alerts',
            onTap: () => ref
                .read(settingsProvider.notifier)
                .requestNotificationPermission(),
          ),
          _buildSettingTile(
            context,
            icon: Icons.wb_sunny_outlined,
            title: 'Morning Reminder',
            subtitle: 'Remind me at 08:00 AM',
            trailing: Switch(
              value: settings.morningReminder,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).toggleMorningReminder(v),
            ),
          ),
          _buildSettingTile(
            context,
            icon: Icons.nightlight_outlined,
            title: 'Evening Reminder',
            subtitle: 'Remind me at 08:00 PM',
            trailing: Switch(
              value: settings.eveningReminder,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).toggleEveningReminder(v),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSectionTitle(context, 'FEEDBACK'),
          ),
          const SizedBox(height: 8),
          _buildSettingTile(
            context,
            icon: Icons.vibration_rounded,
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on click',
            trailing: Switch(
              value: settings.hapticEnabled,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).toggleHaptic(v),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSectionTitle(context, 'AESTHETIC'),
          ),
          const SizedBox(height: 8),
          _buildSettingTile(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'System default',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSettingTile(
            context,
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: const EdgeInsets.only(left: 24, right: 0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).colorScheme.outline,
          fontSize: 10,
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
      onTap: onTap,
    );
  }
}
