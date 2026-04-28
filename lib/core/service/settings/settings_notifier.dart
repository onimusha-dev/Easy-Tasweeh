import 'dart:convert';
import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'settings_service.dart';
import '../settings_provider.dart';

class SettingsNotifier extends Notifier<SettingsState> {
  SettingsService get _service => ref.read(settingsServiceProvider);

  @override
  SettingsState build() {
    // Automatically load settings when the provider is initialized
    final service = ref.watch(settingsServiceProvider);
    
    // Use a microtask to refresh permission status after build
    Future.microtask(() => refreshPermissionStatus());
    
    return service.loadSettings();
  }

  Future<void> refreshPermissionStatus() async {
    final status = await Permission.notification.status;
    state = state.copyWith(notificationPermissionGranted: status.isGranted);
  }

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    final granted = status.isGranted;
    state = state.copyWith(notificationPermissionGranted: granted);
    return granted;
  }

  // --- Feedback ---
  Future<void> toggleHaptic(bool value) async {
    await _service.setBool('hapticEnabled', value);
    state = state.copyWith(feedback: state.feedback.copyWith(hapticEnabled: value));
  }

  Future<void> toggleTapSound(bool value) async {
    await _service.setBool('tapSound', value);
    state = state.copyWith(feedback: state.feedback.copyWith(tapSound: value));
  }

  Future<void> toggleGoalReachedSound(bool value) async {
    await _service.setBool('goalReachedSound', value);
    state = state.copyWith(feedback: state.feedback.copyWith(goalReachedSound: value));
  }

  Future<void> toggleGoalHapticPattern(bool value) async {
    await _service.setBool('goalHapticPattern', value);
    state = state.copyWith(feedback: state.feedback.copyWith(goalHapticPattern: value));
  }

  Future<void> toggleVibrateOnMilestone(bool value) async {
    await _service.setBool('vibrateOnMilestone', value);
    state = state.copyWith(feedback: state.feedback.copyWith(vibrateOnMilestone: value));
  }

  Future<void> setMilestoneValue(int value) async {
    await _service.setInt('milestoneValue', value);
    state = state.copyWith(feedback: state.feedback.copyWith(milestoneValue: value));
  }

  Future<void> toggleShowParticles(bool value) async {
    await _service.setBool('showParticles', value);
    state = state.copyWith(feedback: state.feedback.copyWith(showParticles: value));
  }

  Future<void> toggleSound(bool value) async {
    await _service.setBool('soundEnabled', value);
    state = state.copyWith(feedback: state.feedback.copyWith(soundEnabled: value));
  }

  Future<void> setVolume(double value) async {
    await _service.setDouble('volume', value);
    state = state.copyWith(feedback: state.feedback.copyWith(volume: value));
  }

  Future<void> setHapticIntensity(double value) async {
    await _service.setDouble('hapticIntensity', value);
    state = state.copyWith(feedback: state.feedback.copyWith(hapticIntensity: value));
  }

  // --- Appearance ---
  Future<void> setThemeMode(ThemeMode mode) async {
    await _service.setString('themeMode', mode.name);
    state = state.copyWith(appearance: state.appearance.copyWith(themeMode: mode));
  }

  Future<void> setColorScheme(AppColorScheme scheme) async {
    await _service.setString('colorScheme', scheme.name);
    state = state.copyWith(appearance: state.appearance.copyWith(colorScheme: scheme));
  }

  Future<void> setBackground(String path) async {
    await _service.setString('background', path);
    state = state.copyWith(appearance: state.appearance.copyWith(background: path));
  }

  Future<void> setBackgroundOpacity(double value) async {
    await _service.setDouble('backgroundOpacity', value);
    state = state.copyWith(appearance: state.appearance.copyWith(backgroundOpacity: value));
  }

  Future<void> setButtonStyle(PressButtonStyle style) async {
    await _service.setString('pressButtonStyle', style.name);
    state = state.copyWith(appearance: state.appearance.copyWith(pressButtonStyle: style));
  }

  Future<void> setButtonSize(double value) async {
    await _service.setDouble('buttonSize', value);
    state = state.copyWith(appearance: state.appearance.copyWith(buttonSize: value));
  }

  Future<void> toggleCenterButton(bool value) async {
    await _service.setBool('centerButton', value);
    state = state.copyWith(appearance: state.appearance.copyWith(centerButton: value));
  }

  void updateCenterButtonTemporary(bool value) {
    state = state.copyWith(appearance: state.appearance.copyWith(centerButton: value));
  }

  // --- Dhikr ---
  Future<void> setLastDhikrId(String id) async {
    await _service.setString('lastDhikrId', id);
    state = state.copyWith(dhikr: state.dhikr.copyWith(lastDhikrId: id));
  }

  Future<void> toggleShowArabic(bool v) async {
    await _service.setBool('showArabic', v);
    state = state.copyWith(dhikr: state.dhikr.copyWith(showArabic: v));
  }

  Future<void> toggleShowTransliteration(bool v) async {
    await _service.setBool('showTransliteration', v);
    state = state.copyWith(dhikr: state.dhikr.copyWith(showTransliteration: v));
  }

  Future<void> toggleShowTranslation(bool v) async {
    await _service.setBool('showTranslation', v);
    state = state.copyWith(dhikr: state.dhikr.copyWith(showTranslation: v));
  }

  Future<void> toggleTapFreeze(bool value) async {
    await _service.setBool('tapFreezeEnabled', value);
    state = state.copyWith(dhikr: state.dhikr.copyWith(tapFreezeEnabled: value));
  }

  Future<void> setTapFreezeDuration(int value) async {
    await _service.setInt('tapFreezeDuration', value);
    state = state.copyWith(dhikr: state.dhikr.copyWith(tapFreezeDuration: value));
  }

  // --- Reminders ---
  Future<void> toggleMorningReminder(bool v) async {
    await _service.setBool('morningReminder', v);
    state = state.copyWith(reminders: state.reminders.copyWith(morningReminder: v));
  }

  Future<void> setMorningTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('morningTime', jsonEncode(time.toJson()));
    state = state.copyWith(reminders: state.reminders.copyWith(morningTime: time));
  }

  Future<void> toggleEveningReminder(bool v) async {
    await _service.setBool('eveningReminder', v);
    state = state.copyWith(reminders: state.reminders.copyWith(eveningReminder: v));
  }

  Future<void> setEveningTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('eveningTime', jsonEncode(time.toJson()));
    state = state.copyWith(reminders: state.reminders.copyWith(eveningTime: time));
  }

  Future<void> toggleSayingReminders(bool v) async {
    await _service.setBool('sayingReminders', v);
    state = state.copyWith(reminders: state.reminders.copyWith(sayingReminders: v));
  }

  Future<void> setSayingsPerDay(int v) async {
    await _service.setInt('sayingsPerDay', v);
    state = state.copyWith(reminders: state.reminders.copyWith(sayingsPerDay: v));
  }

  Future<void> toggleAfterSalahReminder(bool v) async {
    await _service.setBool('afterSalahReminder', v);
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahReminder: v));
  }

  Future<void> toggleAfterSalahFajr(bool v) async {
    await _service.setBool('afterSalahFajr', v);
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahFajr: v));
  }

  Future<void> setAfterSalahFajrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahFajrTime', jsonEncode(time.toJson()));
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahFajrTime: time));
  }

  Future<void> toggleAfterSalahDhuhr(bool v) async {
    await _service.setBool('afterSalahDhuhr', v);
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahDhuhr: v));
  }

  Future<void> setAfterSalahDhuhrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahDhuhrTime', jsonEncode(time.toJson()));
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahDhuhrTime: time));
  }

  Future<void> toggleAfterSalahAsr(bool v) async {
    await _service.setBool('afterSalahAsr', v);
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahAsr: v));
  }

  Future<void> setAfterSalahAsrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahAsrTime', jsonEncode(time.toJson()));
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahAsrTime: time));
  }

  Future<void> toggleAfterSalahMaghrib(bool v) async {
    await _service.setBool('afterSalahMaghrib', v);
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahMaghrib: v));
  }

  Future<void> setAfterSalahMaghribTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahMaghribTime', jsonEncode(time.toJson()));
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahMaghribTime: time));
  }

  Future<void> toggleAfterSalahIsha(bool v) async {
    await _service.setBool('afterSalahIsha', v);
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahIsha: v));
  }

  Future<void> setAfterSalahIshaTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahIshaTime', jsonEncode(time.toJson()));
    state = state.copyWith(reminders: state.reminders.copyWith(afterSalahIshaTime: time));
  }

  // --- Backup ---
  Future<void> togglePeriodicBackup(bool v) async {
    await _service.setBool('periodicBackupEnabled', v);
    state = state.copyWith(backup: state.backup.copyWith(periodicBackupEnabled: v));

    if (v && state.backup.backupDirectory != null) {
      await Workmanager().registerPeriodicTask(
        '1',
        'dailyBackup',
        frequency: const Duration(days: 1),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
        constraints: Constraints(requiresBatteryNotLow: true),
      );
    } else {
      await Workmanager().cancelByUniqueName('1');
    }
  }

  Future<void> setBackupDirectory(String? path) async {
    if (path == null) {
      await _service.remove('backupDirectory');
    } else {
      await _service.setString('backupDirectory', path);
    }
    state = state.copyWith(backup: state.backup.copyWith(backupDirectory: path));
  }

  Future<void> completeOnboarding() async {
    await _service.setBool('onboardingCompleted', true);
    state = state.copyWith(onboardingCompleted: true);
  }
}
