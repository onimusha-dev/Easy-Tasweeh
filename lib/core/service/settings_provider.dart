import 'package:easy_tasweeh/core/service/notification_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsState {
  final bool morningReminder;
  final bool eveningReminder;
  final bool hapticEnabled;

  SettingsState({
    required this.morningReminder,
    required this.eveningReminder,
    required this.hapticEnabled,
  });

  SettingsState copyWith({
    bool? morningReminder,
    bool? eveningReminder,
    bool? hapticEnabled,
  }) {
    return SettingsState(
      morningReminder: morningReminder ?? this.morningReminder,
      eveningReminder: eveningReminder ?? this.eveningReminder,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(SettingsState(
          morningReminder: false,
          eveningReminder: false,
          hapticEnabled: true,
        )) {
    _loadSettings();
  }

  static const _morningRemKey = 'morning_reminder';
  static const _eveningRemKey = 'evening_reminder';
  static const _hapticKey = 'haptic_enabled';

  final NotificationService _notificationService = NotificationService();

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      morningReminder: prefs.getBool(_morningRemKey) ?? false,
      eveningReminder: prefs.getBool(_eveningRemKey) ?? false,
      hapticEnabled: prefs.getBool(_hapticKey) ?? true,
    );
  }

  Future<void> toggleMorningReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_morningRemKey, value);
    state = state.copyWith(morningReminder: value);

    if (value) {
      await _notificationService.scheduleDailyNotification(
        id: 101,
        title: 'Morning Tasweeh',
        body: 'Start your day with remembrance.',
        hour: 8,
        minute: 0,
      );
    } else {
      await _notificationService.cancelNotification(101);
    }
  }

  Future<void> toggleEveningReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eveningRemKey, value);
    state = state.copyWith(eveningReminder: value);

    if (value) {
      await _notificationService.scheduleDailyNotification(
        id: 102,
        title: 'Evening Tasweeh',
        body: 'End your day with peace and gratitude.',
        hour: 20,
        minute: 0,
      );
    } else {
      await _notificationService.cancelNotification(102);
    }
  }

  Future<void> toggleHaptic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticKey, value);
    state = state.copyWith(hapticEnabled: value);
  }

  Future<void> requestNotificationPermission() async {
    await _notificationService.requestPermissions();
  }
}
