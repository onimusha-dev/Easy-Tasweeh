import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/saying_model.dart';
import '../notification_service.dart';
import '../settings_provider.dart';

final reminderManagerProvider = Provider<void>((ref) {
  final notificationService = NotificationService();
  
  // Initialize reminders on first load
  final initialState = ref.read(settingsProvider);
  _initializeReminders(initialState.reminders, notificationService);

  // Listen to ONLY reminder settings changes
  ref.listen<ReminderSettings>(
    settingsProvider.select((s) => s.reminders),
    (previous, next) {
      if (previous != next) {
        _handleSettingsChange(previous, next, notificationService);
      }
    },
  );
});

void _initializeReminders(
  ReminderSettings state,
  NotificationService notificationService,
) {
  // Morning Reminder
  if (state.morningReminder) {
    notificationService.scheduleDailyNotification(
      id: 1,
      title: 'Morning Remembrance',
      body: 'Start your day with the light of Dhikr.',
      hour: state.morningTime.hour,
      minute: state.morningTime.minute,
    );
  }

  // Evening Reminder
  if (state.eveningReminder) {
    notificationService.scheduleDailyNotification(
      id: 2,
      title: 'Evening Remembrance',
      body: 'End your day in peace and gratitude.',
      hour: state.eveningTime.hour,
      minute: state.eveningTime.minute,
    );
  }

  // After Salah Reminders
  _syncSalahReminder(
    enabled: state.afterSalahFajr,
    time: state.afterSalahFajrTime,
    id: 10,
    title: 'Fajr Dhikr',
    notificationService: notificationService,
  );
  _syncSalahReminder(
    enabled: state.afterSalahDhuhr,
    time: state.afterSalahDhuhrTime,
    id: 11,
    title: 'Dhuhr Dhikr',
    notificationService: notificationService,
  );
  _syncSalahReminder(
    enabled: state.afterSalahAsr,
    time: state.afterSalahAsrTime,
    id: 12,
    title: 'Asr Dhikr',
    notificationService: notificationService,
  );
  _syncSalahReminder(
    enabled: state.afterSalahMaghrib,
    time: state.afterSalahMaghribTime,
    id: 13,
    title: 'Maghrib Dhikr',
    notificationService: notificationService,
  );
  _syncSalahReminder(
    enabled: state.afterSalahIsha,
    time: state.afterSalahIshaTime,
    id: 14,
    title: 'Isha Dhikr',
    notificationService: notificationService,
  );

  // Prophet's Sayings
  if (state.sayingReminders) {
    _scheduleSayings(state.sayingsPerDay, notificationService);
  }
}

void _handleSettingsChange(
  ReminderSettings? previous,
  ReminderSettings next,
  NotificationService notificationService,
) {
  // 1. Morning Reminder
  if (previous?.morningReminder != next.morningReminder ||
      previous?.morningTime != next.morningTime) {
    if (next.morningReminder) {
      notificationService.scheduleDailyNotification(
        id: 1,
        title: 'Morning Remembrance',
        body: 'Start your day with the light of Dhikr.',
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
        body: 'End your day in peace and gratitude.',
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

  // 4. Prophet's Sayings
  if (previous?.sayingReminders != next.sayingReminders ||
      previous?.sayingsPerDay != next.sayingsPerDay) {
    if (next.sayingReminders) {
      _scheduleSayings(next.sayingsPerDay, notificationService);
    } else {
      notificationService.cancelNotificationsWithPrefix(1000, 1005);
    }
  }
}

void _scheduleSayings(int count, NotificationService notificationService) {
  // Cancel previous ones first
  notificationService.cancelNotificationsWithPrefix(1000, 1005);

  if (count <= 0) return;

  final random = Random();
  // Use the first 5 sayings from the model as requested
  final availableHadiths = hadiths.take(5).toList();
  
  // Pick unique indices from the pool
  final List<int> selectedIndices = [];
  while (selectedIndices.length < count && selectedIndices.length < availableHadiths.length) {
    final idx = random.nextInt(availableHadiths.length);
    if (!selectedIndices.contains(idx)) {
      selectedIndices.add(idx);
    }
  }

  // Divide the day into slots based on count
  // If count is 2, slots are 12 hours each.
  final int totalMinutesInDay = 24 * 60;
  final int slotSize = totalMinutesInDay ~/ count;

  for (int i = 0; i < selectedIndices.length; i++) {
    final hadith = availableHadiths[selectedIndices[i]];
    
    // To ensure spacing (e.g. at least 5-6 hours gap for 2 sayings),
    // we use a buffer within each slot.
    final int buffer = slotSize ~/ 4; // 3 hour buffer for a 12 hour slot
    final int usableSlot = slotSize - (2 * buffer); // 6 hours usable window
    
    final int slotStart = i * slotSize + buffer;
    final int randomOffset = random.nextInt(usableSlot);
    final int totalMinutes = slotStart + randomOffset;
    
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    
    notificationService.scheduleDailyNotification(
      id: 1000 + i,
      title: "Prophet's Saying",
      body: hadith.content,
      hour: hour,
      minute: minute,
      channelId: 'sayings_channel_id',
      channelName: "Prophet's Sayings",
      payload: 'saying_${hadith.source}',
    );
  }
}

void _syncSalahReminder({
  required bool enabled,
  required ReminderTime time,
  required int id,
  required String title,
  required NotificationService notificationService,
}) {
  if (enabled) {
    notificationService.scheduleDailyNotification(
      id: id,
      title: title,
      body: 'Time for your post-salah remembrance.',
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
  required ReminderTime? previousTime,
  required ReminderTime nextTime,
  required int id,
  required String title,
  required NotificationService notificationService,
}) {
  if (previousEnabled != nextEnabled || previousTime != nextTime) {
    if (nextEnabled) {
      notificationService.scheduleDailyNotification(
        id: id,
        title: title,
        body: 'Time for your post-salah remembrance.',
        hour: nextTime.hour,
        minute: nextTime.minute,
      );
    } else {
      notificationService.cancelNotification(id);
    }
  }
}
