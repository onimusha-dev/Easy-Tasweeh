import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notification_service.dart';
import '../settings_provider.dart';

final reminderManagerProvider = Provider<void>((ref) {
  final notificationService = NotificationService();
  
  // Initialize reminders on first load
  final initialState = ref.read(settingsProvider);
  _initializeReminders(initialState, notificationService);

  // Listen to settings changes
  ref.listen<SettingsState>(settingsProvider, (previous, next) {
    _handleSettingsChange(previous, next, notificationService);
  });
});

void _initializeReminders(SettingsState state, NotificationService notificationService) {
  // Morning Reminder
  if (state.morningReminder) {
    notificationService.scheduleDailyNotification(
      id: 1,
      title: 'Morning Remembrance',
      body: 'Start your day with the remembrance of Allah.',
      hour: state.morningTime.hour,
      minute: state.morningTime.minute,
    );
  }

  // Evening Reminder
  if (state.eveningReminder) {
    notificationService.scheduleDailyNotification(
      id: 2,
      title: 'Evening Remembrance',
      body: 'End your day with peace and gratitude.',
      hour: state.eveningTime.hour,
      minute: state.eveningTime.minute,
    );
  }

  // After Salah Reminders
  _syncSalahReminder(enabled: state.afterSalahFajr, time: state.afterSalahFajrTime, id: 10, title: 'Fajr Dhikr', notificationService: notificationService);
  _syncSalahReminder(enabled: state.afterSalahDhuhr, time: state.afterSalahDhuhrTime, id: 11, title: 'Dhuhr Dhikr', notificationService: notificationService);
  _syncSalahReminder(enabled: state.afterSalahAsr, time: state.afterSalahAsrTime, id: 12, title: 'Asr Dhikr', notificationService: notificationService);
  _syncSalahReminder(enabled: state.afterSalahMaghrib, time: state.afterSalahMaghribTime, id: 13, title: 'Maghrib Dhikr', notificationService: notificationService);
  _syncSalahReminder(enabled: state.afterSalahIsha, time: state.afterSalahIshaTime, id: 14, title: 'Isha Dhikr', notificationService: notificationService);
}

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
    } else {
      notificationService.cancelNotification(1);
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
    } else {
      notificationService.cancelNotification(2);
    }
  }

  // 3. After Salah Reminders
  _handleSalahReminder(
    previousEnabled: previous?.afterSalahFajr,
    nextEnabled: next.afterSalahFajr,
    previousTime: previous?.afterSalahFajrTime,
    nextTime: next.afterSalahFajrTime,
    id: 10,
    title: 'Fajr Dhikr',
    notificationService: notificationService,
  );
  _handleSalahReminder(
    previousEnabled: previous?.afterSalahDhuhr,
    nextEnabled: next.afterSalahDhuhr,
    previousTime: previous?.afterSalahDhuhrTime,
    nextTime: next.afterSalahDhuhrTime,
    id: 11,
    title: 'Dhuhr Dhikr',
    notificationService: notificationService,
  );
  _handleSalahReminder(
    previousEnabled: previous?.afterSalahAsr,
    nextEnabled: next.afterSalahAsr,
    previousTime: previous?.afterSalahAsrTime,
    nextTime: next.afterSalahAsrTime,
    id: 12,
    title: 'Asr Dhikr',
    notificationService: notificationService,
  );
  _handleSalahReminder(
    previousEnabled: previous?.afterSalahMaghrib,
    nextEnabled: next.afterSalahMaghrib,
    previousTime: previous?.afterSalahMaghribTime,
    nextTime: next.afterSalahMaghribTime,
    id: 13,
    title: 'Maghrib Dhikr',
    notificationService: notificationService,
  );
  _handleSalahReminder(
    previousEnabled: previous?.afterSalahIsha,
    nextEnabled: next.afterSalahIsha,
    previousTime: previous?.afterSalahIshaTime,
    nextTime: next.afterSalahIshaTime,
    id: 14,
    title: 'Isha Dhikr',
    notificationService: notificationService,
  );
}

void _syncSalahReminder({
  required bool enabled,
  required dynamic time,
  required int id,
  required String title,
  required NotificationService notificationService,
}) {
  if (enabled) {
    notificationService.scheduleDailyNotification(
      id: id,
      title: title,
      body: 'It is time for your post-salah dhikr.',
      hour: time.hour,
      minute: time.minute,
    );
  } else {
    notificationService.cancelNotification(id);
  }
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
    } else {
      notificationService.cancelNotification(id);
    }
  }
}
