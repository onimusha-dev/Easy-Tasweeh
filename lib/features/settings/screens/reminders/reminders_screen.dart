import 'package:app_settings/app_settings.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/app_switch.dart';
import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/features/settings/widgets/notification_permission_banner.dart';
import 'package:easy_tasbeeh/features/settings/widgets/reminder_time_tile.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
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
        padding: const EdgeInsets.all(16),
        children: [
          // ── Permission banner ────────────────────────────────────────────
          const NotificationPermissionBanner(),
          const SizedBox(height: 16),

          // ── Daily reminders ──────────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'Daily Reminders',
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

          // ── Prophet's Sayings ─────────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'Sayings',
            children: [
              buildTwoPartSettingTile(
                context,
                icon: Icons.format_quote_rounded,
                title: "Prophet's Sayings",
                subtitle: 'Random hadith throughout the day',
                iconColor: AppIconColors.pink(context),
                action: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FREQUENCY: ${settings.sayingsPerDay} TIMES A DAY',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        AppSwitch(
                          value: settings.sayingReminders,
                          onChanged: (v) {
                            if (v && !settings.notificationPermissionGranted) {
                              _showPermissionSnack();
                              return;
                            }
                            notifier.toggleSayingReminders(v);
                          },
                        ),
                      ],
                    ),
                    if (settings.sayingReminders) ...[
                      const SizedBox(height: 8),
                      Slider(
                        value: settings.sayingsPerDay.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (v) => notifier.setSayingsPerDay(v.toInt()),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          buildSettingsGroup(
            context,
            title: 'Advance',
            children: [
              buildSettingTile(
                context,
                icon: Icons.settings_suggest_rounded,
                title: 'System Notification Settings',
                subtitle: 'Manage channels, priority and sounds',
                iconColor: Colors.blueGrey,
                onTap: () => AppSettings.openAppSettings(
                  type: AppSettingsType.notification,
                ),
              ),
            ],
          ),
          const SizedBox(height: 64),
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
