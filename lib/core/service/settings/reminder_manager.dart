import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notification_service.dart';
import '../settings_provider.dart';

final reminderManagerProvider = Provider<void>((ref) {
  final notificationService = NotificationService();

  // Listen to settings changes
  ref.listen<SettingsState>(settingsProvider, (previous, next) {
    _handleSettingsChange(previous, next, notificationService);
  });
});

void _handleSettingsChange(SettingsState? previous, SettingsState next, NotificationService notificationService) {
  // 1. Morning Reminder
  if (previous?.morningReminder != next.morningReminder ||
      previous?.morningTime != next.morningTime) {
    if (next.morningReminder) {
      notificationService.scheduleDailyNotification(
        id: 1,
        title: 'Morning Remembrance',
        body: 'Start your day with the remembrance of Allah.',
        hour: next.morningTime.hour,
        minute: next.morningTime.minute,
      );
    }
  }

  // 2. Evening Reminder
  if (previous?.eveningReminder != next.eveningReminder ||
      previous?.eveningTime != next.eveningTime) {
    if (next.eveningReminder) {
      notificationService.scheduleDailyNotification(
        id: 2,
        title: 'Evening Remembrance',
        body: 'End your day with peace and gratitude.',
        hour: next.eveningTime.hour,
        minute: next.eveningTime.minute,
      );
    }
  }

  // 3. After Salah Reminders
  _handleSalahReminder(
    previousEnabled: previous?.reminders.afterSalahFajr,
    nextEnabled: next.reminders.afterSalahFajr,
    previousTime: previous?.reminders.afterSalahFajrTime,
    nextTime: next.reminders.afterSalahFajrTime,
    id: 10,
    title: 'Fajr Dhikr',
    notificationService: notificationService,
  );
  _handleSalahReminder(
    previousEnabled: previous?.reminders.afterSalahDhuhr,
    nextEnabled: next.reminders.afterSalahDhuhr,
    previousTime: previous?.reminders.afterSalahDhuhrTime,
    nextTime: next.reminders.afterSalahDhuhrTime,
    id: 11,
    title: 'Dhuhr Dhikr',
    notificationService: notificationService,
  );
  _handleSalahReminder(
    previousEnabled: previous?.reminders.afterSalahAsr,
    nextEnabled: next.reminders.afterSalahAsr,
    previousTime: previous?.reminders.afterSalahAsrTime,
    nextTime: next.reminders.afterSalahAsrTime,
    id: 12,
    title: 'Asr Dhikr',
    notificationService: notificationService,
  );
  _handleSalahReminder(
    previousEnabled: previous?.reminders.afterSalahMaghrib,
    nextEnabled: next.reminders.afterSalahMaghrib,
    previousTime: previous?.reminders.afterSalahMaghribTime,
    nextTime: next.reminders.afterSalahMaghribTime,
    id: 13,
    title: 'Maghrib Dhikr',
    notificationService: notificationService,
  );
  _handleSalahReminder(
    previousEnabled: previous?.reminders.afterSalahIsha,
    nextEnabled: next.reminders.afterSalahIsha,
    previousTime: previous?.reminders.afterSalahIshaTime,
    nextTime: next.reminders.afterSalahIshaTime,
    id: 14,
    title: 'Isha Dhikr',
    notificationService: notificationService,
  );
}

void _handleSalahReminder({
  required bool? previousEnabled,
  required bool nextEnabled,
  required dynamic previousTime,
  required dynamic nextTime,
  required int id,
  required String title,
  required NotificationService notificationService,
}) {
  if (previousEnabled != nextEnabled || previousTime != nextTime) {
    if (nextEnabled) {
      notificationService.scheduleDailyNotification(
        id: id,
        title: title,
        body: 'It is time for your post-salah dhikr.',
        hour: nextTime.hour,
        minute: nextTime.minute,
      );
    }
  }
}
