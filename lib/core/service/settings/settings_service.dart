import 'dart:convert';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';
import '../../theme/theme.dart';

class SettingsService {
  final SharedPreferences prefs;

  SettingsService(this.prefs);

  SettingsState loadSettings() {
    return SettingsState(
      appearance: AppearanceSettings(
        background: prefs.getString('background') ?? '',
        backgroundOpacity: prefs.getDouble('backgroundOpacity') ?? 0.4,
        pressButtonStyle: _parseStyle(prefs.getString('pressButtonStyle')),
        buttonSize: prefs.getDouble('buttonSize') ?? 240.0,
        themeMode: _parseThemeMode(prefs.getString('themeMode')),
        colorScheme: _parseColorScheme(prefs.getString('colorScheme')),
        centerButton: prefs.getBool('centerButton') ?? false,
      ),
      feedback: FeedbackSettings(
        hapticEnabled: prefs.getBool('hapticEnabled') ?? true,
        hapticIntensity: prefs.getDouble('hapticIntensity') ?? 0.5,
        soundEnabled: prefs.getBool('soundEnabled') ?? true,
        volume: prefs.getDouble('volume') ?? 0.5,
        tapSound: prefs.getBool('tapSound') ?? true,
        goalReachedSound: prefs.getBool('goalReachedSound') ?? true,
        goalHapticPattern: prefs.getBool('goalHapticPattern') ?? true,
        vibrateOnMilestone: prefs.getBool('vibrateOnMilestone') ?? true,
        milestoneValue: prefs.getInt('milestoneValue') ?? 100,
        showParticles: prefs.getBool('showParticles') ?? true,
      ),
      reminders: ReminderSettings(
        morningReminder: prefs.getBool('morningReminder') ?? false,
        morningTime: _parseTime(prefs.getString('morningTime'), 8, 0),
        eveningReminder: prefs.getBool('eveningReminder') ?? false,
        eveningTime: _parseTime(prefs.getString('eveningTime'), 19, 0),
        sayingReminders: prefs.getBool('sayingReminders') ?? true,
        sayingsPerDay: prefs.getInt('sayingsPerDay') ?? 1,
        afterSalahReminder: prefs.getBool('afterSalahReminder') ?? true,
        afterSalahFajr: prefs.getBool('afterSalahFajr') ?? true,
        afterSalahFajrTime: _parseTime(prefs.getString('afterSalahFajrTime'), 5, 0),
        afterSalahDhuhr: prefs.getBool('afterSalahDhuhr') ?? true,
        afterSalahDhuhrTime: _parseTime(prefs.getString('afterSalahDhuhrTime'), 13, 0),
        afterSalahAsr: prefs.getBool('afterSalahAsr') ?? true,
        afterSalahAsrTime: _parseTime(prefs.getString('afterSalahAsrTime'), 16, 30),
        afterSalahMaghrib: prefs.getBool('afterSalahMaghrib') ?? true,
        afterSalahMaghribTime: _parseTime(prefs.getString('afterSalahMaghribTime'), 18, 30),
        afterSalahIsha: prefs.getBool('afterSalahIsha') ?? true,
        afterSalahIshaTime: _parseTime(prefs.getString('afterSalahIshaTime'), 20, 30),
      ),
      backup: BackupSettings(
        periodicBackupEnabled: prefs.getBool('periodicBackupEnabled') ?? false,
        backupDirectory: prefs.getString('backupDirectory'),
      ),
      dhikr: DhikrSettings(
        lastDhikrId: prefs.getString('lastDhikrId') ?? 'subhanallah',
        showArabic: prefs.getBool('showArabic') ?? true,
        showTransliteration: prefs.getBool('showTransliteration') ?? true,
        showTranslation: prefs.getBool('showTranslation') ?? true,
        tapFreezeEnabled: prefs.getBool('tapFreezeEnabled') ?? true,
        tapFreezeDuration: prefs.getInt('tapFreezeDuration') ?? 100,
        comboPresets: (prefs.getStringList('comboPresets') ?? [])
            .map((e) => ComboPreset.fromJson(jsonDecode(e) as Map<String, dynamic>))
            .toList(),
        activeComboIndex: prefs.getInt('activeComboIndex') ?? -1,
        comboEnabled: prefs.getBool('comboEnabled') ?? false,
      ),
      notificationPermissionGranted: false,
      onboardingCompleted: prefs.getBool('onboardingCompleted') ?? false,
    );
  }

  static PressButtonStyle _parseStyle(String? style) {
    switch (style) {
      case 'classicWavy': return PressButtonStyle.classicWavy;
      case 'midnightGlass': return PressButtonStyle.midnightGlass;
      case 'glowingBall': return PressButtonStyle.glowingBall;
      default: return PressButtonStyle.classicWavy;
    }
  }

  static ThemeMode _parseThemeMode(String? mode) {
    switch (mode) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      case 'system': return ThemeMode.system;
      default: return ThemeMode.system;
    }
  }

  static AppColorScheme _parseColorScheme(String? scheme) {
    switch (scheme) {
      case 'sage': return AppColorScheme.sage;
      case 'sunset': return AppColorScheme.sunset;
      default: return AppColorScheme.sage;
    }
  }

  static ReminderTime _parseTime(String? json, int defHour, int defMinute) {
    if (json == null) return ReminderTime(defHour, defMinute);
    try {
      return ReminderTime.fromJson(jsonDecode(json));
    } catch (_) {
      return ReminderTime(defHour, defMinute);
    }
  }

  Future<void> setBool(String key, bool value) => prefs.setBool(key, value);
  Future<void> setString(String key, String value) => prefs.setString(key, value);
  Future<void> setDouble(String key, double value) => prefs.setDouble(key, value);
  Future<void> setInt(String key, int value) => prefs.setInt(key, value);
  Future<void> setStringList(String key, List<String> value) => prefs.setStringList(key, value);
  Future<void> remove(String key) => prefs.remove(key);
}
