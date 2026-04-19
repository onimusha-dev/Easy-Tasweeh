import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:easy_tasweeh/features/settings/widgets/notification_permission_banner.dart';
import 'package:easy_tasweeh/features/settings/widgets/reminder_time_tile.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(settingsProvider.notifier).refreshPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // ── Permission banner ────────────────────────────────────────────
          const NotificationPermissionBanner(),
          const SizedBox(height: 16),

          // ── Daily reminders ──────────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'DAILY REMINDERS',
            children: [
              ReminderTimeTile(
                title: 'Morning Reminder',
                subtitle: 'Start your day with remembrance',
                icon: Icons.wb_sunny_rounded,
                enabled: settings.morningReminder,
                time: settings.morningTime,
                iconColor: AppIconColors.amber(context),
                onToggle: (v) {
                  if (v && !settings.notificationPermissionGranted) {
                    _showPermissionSnack();
                    return;
                  }
                  notifier.toggleMorningReminder(v);
                },
                onTimePicked: (picked) =>
                    notifier.setMorningTime(picked.hour, picked.minute),
              ),
              ReminderTimeTile(
                title: 'Evening Reminder',
                subtitle: 'End your day with peace and gratitude',
                icon: Icons.nights_stay_rounded,
                enabled: settings.eveningReminder,
                time: settings.eveningTime,
                iconColor: AppIconColors.purple(context),
                onToggle: (v) {
                  if (v && !settings.notificationPermissionGranted) {
                    _showPermissionSnack();
                    return;
                  }
                  notifier.toggleEveningReminder(v);
                },
                onTimePicked: (picked) =>
                    notifier.setEveningTime(picked.hour, picked.minute),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Other reminders ──────────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'OTHER',
            children: [
              buildSettingTile(
                context,
                icon: Icons.mosque_outlined,
                title: 'After salah reminder',
                subtitle: 'Prompt after each prayer time',
                iconColor: AppIconColors.teal(context),
                trailing: Switch(
                  value: settings.afterSalahReminder,
                  onChanged: (v) => notifier.toggleAfterSalahReminder(v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showPermissionSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Enable notification permission first.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
