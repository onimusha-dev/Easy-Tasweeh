import 'package:app_settings/app_settings.dart';
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
          // ── Prophet's Sayings ─────────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'SAYINGS',
            children: [
              buildSettingTile(
                context,
                icon: Icons.format_quote_rounded,
                title: "Prophet's Sayings",
                subtitle: 'Random hadith throughout the day',
                iconColor: AppIconColors.pink(context),
                trailing: Switch(
                  value: settings.sayingReminders,
                  onChanged: (v) {
                    if (v && !settings.notificationPermissionGranted) {
                      _showPermissionSnack();
                      return;
                    }
                    notifier.toggleSayingReminders(v);
                  },
                ),
              ),
              if (settings.sayingReminders)
                Padding(
                  padding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FREQUENCY: ${settings.sayingsPerDay} TIMES A DAY',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: settings.sayingsPerDay.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (v) => notifier.setSayingsPerDay(v.toInt()),
                      ),
                    ],
                  ),
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
                  onChanged: (v) {
                    if (v && !settings.notificationPermissionGranted) {
                      _showPermissionSnack();
                      return;
                    }
                    notifier.toggleAfterSalahReminder(v);
                  },
                ),
              ),
              if (settings.afterSalahReminder) ...[
                ReminderTimeTile(
                  title: 'Fajr',
                  subtitle: 'Early morning dhikr prompt',
                  icon: Icons.wb_twilight_rounded,
                  enabled: settings.afterSalahFajr,
                  time: settings.afterSalahFajrTime,
                  iconColor: AppIconColors.teal(context),
                  onToggle: (v) => notifier.toggleAfterSalahFajr(v),
                  onTimePicked: (picked) => notifier.setAfterSalahFajrTime(
                    picked.hour,
                    picked.minute,
                  ),
                ),
                ReminderTimeTile(
                  title: 'Dhuhr',
                  subtitle: 'Midday dhikr prompt',
                  icon: Icons.wb_sunny_rounded,
                  enabled: settings.afterSalahDhuhr,
                  time: settings.afterSalahDhuhrTime,
                  iconColor: AppIconColors.amber(context),
                  onToggle: (v) => notifier.toggleAfterSalahDhuhr(v),
                  onTimePicked: (picked) => notifier.setAfterSalahDhuhrTime(
                    picked.hour,
                    picked.minute,
                  ),
                ),
                ReminderTimeTile(
                  title: 'Asr',
                  subtitle: 'Afternoon dhikr prompt',
                  icon: Icons.sunny_snowing,
                  enabled: settings.afterSalahAsr,
                  time: settings.afterSalahAsrTime,
                  iconColor: AppIconColors.orange(context),
                  onToggle: (v) => notifier.toggleAfterSalahAsr(v),
                  onTimePicked: (picked) =>
                      notifier.setAfterSalahAsrTime(picked.hour, picked.minute),
                ),
                ReminderTimeTile(
                  title: 'Maghrib',
                  subtitle: 'Sunset dhikr prompt',
                  icon: Icons.wb_twilight_sharp,
                  enabled: settings.afterSalahMaghrib,
                  time: settings.afterSalahMaghribTime,
                  iconColor: AppIconColors.pink(context),
                  onToggle: (v) => notifier.toggleAfterSalahMaghrib(v),
                  onTimePicked: (picked) => notifier.setAfterSalahMaghribTime(
                    picked.hour,
                    picked.minute,
                  ),
                ),
                ReminderTimeTile(
                  title: 'Isha',
                  subtitle: 'Night dhikr prompt',
                  icon: Icons.nights_stay_rounded,
                  enabled: settings.afterSalahIsha,
                  time: settings.afterSalahIshaTime,
                  iconColor: AppIconColors.purple(context),
                  onToggle: (v) => notifier.toggleAfterSalahIsha(v),
                  onTimePicked: (picked) => notifier.setAfterSalahIshaTime(
                    picked.hour,
                    picked.minute,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
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
