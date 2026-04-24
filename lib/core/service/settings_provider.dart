import 'dart:convert';

import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

enum PressButtonStyle { classicWavy, midnightGlass, glowingBall }

class ReminderTime {
  final int hour;
  final int minute;

  const ReminderTime(this.hour, this.minute);

  Map<String, dynamic> toJson() => {'hour': hour, 'minute': minute};

  factory ReminderTime.fromJson(Map<String, dynamic> json) {
    return ReminderTime(json['hour'] as int, json['minute'] as int);
  }

  String get label {
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    return '$h:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  String toString() => label;
}

class SettingsState {
  final bool hapticEnabled;
  final bool soundEnabled;
  final double volume;
  final double hapticIntensity;
  final String background; // Changed from backgroundPath
  final double backgroundOpacity; // Added
  final PressButtonStyle pressButtonStyle;
  final double buttonSize;
  final bool tapFreezeEnabled;
  final int tapFreezeDuration;

  // Additional Fields
  final String lastDhikrId;
  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final bool tapSound;
  final bool goalReachedSound;
  final bool goalHapticPattern;
  final bool vibrateOnMilestone;
  final int milestoneValue;
  final bool showParticles; // Added
  final ThemeMode themeMode;
  final AppColorScheme colorScheme;

  // Backup
  final bool periodicBackupEnabled;
  final String? backupDirectory;

  // Reminders
  final bool morningReminder;
  final ReminderTime morningTime;
  final bool eveningReminder;
  final ReminderTime eveningTime;
  final bool sayingReminders;
  final int sayingsPerDay;
  final bool afterSalahReminder;
  final bool afterSalahFajr;
  final ReminderTime afterSalahFajrTime;
  final bool afterSalahDhuhr;
  final ReminderTime afterSalahDhuhrTime;
  final bool afterSalahAsr;
  final ReminderTime afterSalahAsrTime;
  final bool afterSalahMaghrib;
  final ReminderTime afterSalahMaghribTime;
  final bool afterSalahIsha;
  final ReminderTime afterSalahIshaTime;
  final bool notificationPermissionGranted;

  SettingsState({
    required this.hapticEnabled,
    required this.soundEnabled,
    required this.volume,
    required this.hapticIntensity,
    required this.background,
    required this.backgroundOpacity,
    required this.pressButtonStyle,
    required this.buttonSize,
    required this.tapFreezeEnabled,
    required this.tapFreezeDuration,
    required this.lastDhikrId,
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    required this.tapSound,
    required this.goalReachedSound,
    required this.goalHapticPattern,
    required this.vibrateOnMilestone,
    required this.milestoneValue,
    required this.showParticles,
    required this.themeMode,
    required this.colorScheme,
    required this.morningReminder,
    required this.morningTime,
    required this.eveningReminder,
    required this.eveningTime,
    required this.sayingReminders,
    required this.sayingsPerDay,
    required this.afterSalahReminder,
    required this.afterSalahFajr,
    required this.afterSalahFajrTime,
    required this.afterSalahDhuhr,
    required this.afterSalahDhuhrTime,
    required this.afterSalahAsr,
    required this.afterSalahAsrTime,
    required this.afterSalahMaghrib,
    required this.afterSalahMaghribTime,
    required this.afterSalahIsha,
    required this.afterSalahIshaTime,
    required this.notificationPermissionGranted,
    required this.periodicBackupEnabled,
    this.backupDirectory,
  });

  SettingsState copyWith({
    bool? hapticEnabled,
    bool? soundEnabled,
    double? volume,
    double? hapticIntensity,
    String? background,
    double? backgroundOpacity,
    PressButtonStyle? pressButtonStyle,
    double? buttonSize,
    bool? tapFreezeEnabled,
    int? tapFreezeDuration,
    String? lastDhikrId,
    bool? showArabic,
    bool? showTransliteration,
    bool? showTranslation,
    bool? tapSound,
    bool? goalReachedSound,
    bool? goalHapticPattern,
    bool? vibrateOnMilestone,
    int? milestoneValue,
    bool? showParticles,
    ThemeMode? themeMode,
    AppColorScheme? colorScheme,
    bool? morningReminder,
    ReminderTime? morningTime,
    bool? eveningReminder,
    ReminderTime? eveningTime,
    bool? sayingReminders,
    int? sayingsPerDay,
    bool? afterSalahReminder,
    bool? afterSalahFajr,
    ReminderTime? afterSalahFajrTime,
    bool? afterSalahDhuhr,
    ReminderTime? afterSalahDhuhrTime,
    bool? afterSalahAsr,
    ReminderTime? afterSalahAsrTime,
    bool? afterSalahMaghrib,
    ReminderTime? afterSalahMaghribTime,
    bool? afterSalahIsha,
    ReminderTime? afterSalahIshaTime,
    bool? notificationPermissionGranted,
    bool? periodicBackupEnabled,
    // Use _clearBackupDirectory = true to explicitly set backupDirectory to null.
    Object? backupDirectory = _sentinel,
  }) {
    return SettingsState(
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      volume: volume ?? this.volume,
      hapticIntensity: hapticIntensity ?? this.hapticIntensity,
      background: background ?? this.background,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      pressButtonStyle: pressButtonStyle ?? this.pressButtonStyle,
      buttonSize: buttonSize ?? this.buttonSize,
      tapFreezeEnabled: tapFreezeEnabled ?? this.tapFreezeEnabled,
      tapFreezeDuration: tapFreezeDuration ?? this.tapFreezeDuration,
      lastDhikrId: lastDhikrId ?? this.lastDhikrId,
      showArabic: showArabic ?? this.showArabic,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      tapSound: tapSound ?? this.tapSound,
      goalReachedSound: goalReachedSound ?? this.goalReachedSound,
      goalHapticPattern: goalHapticPattern ?? this.goalHapticPattern,
      vibrateOnMilestone: vibrateOnMilestone ?? this.vibrateOnMilestone,
      milestoneValue: milestoneValue ?? this.milestoneValue,
      showParticles: showParticles ?? this.showParticles,
      themeMode: themeMode ?? this.themeMode,
      colorScheme: colorScheme ?? this.colorScheme,
      morningReminder: morningReminder ?? this.morningReminder,
      morningTime: morningTime ?? this.morningTime,
      eveningReminder: eveningReminder ?? this.eveningReminder,
      eveningTime: eveningTime ?? this.eveningTime,
      sayingReminders: sayingReminders ?? this.sayingReminders,
      sayingsPerDay: sayingsPerDay ?? this.sayingsPerDay,
      afterSalahReminder: afterSalahReminder ?? this.afterSalahReminder,
      afterSalahFajr: afterSalahFajr ?? this.afterSalahFajr,
      afterSalahFajrTime: afterSalahFajrTime ?? this.afterSalahFajrTime,
      afterSalahDhuhr: afterSalahDhuhr ?? this.afterSalahDhuhr,
      afterSalahDhuhrTime: afterSalahDhuhrTime ?? this.afterSalahDhuhrTime,
      afterSalahAsr: afterSalahAsr ?? this.afterSalahAsr,
      afterSalahAsrTime: afterSalahAsrTime ?? this.afterSalahAsrTime,
      afterSalahMaghrib: afterSalahMaghrib ?? this.afterSalahMaghrib,
      afterSalahMaghribTime:
          afterSalahMaghribTime ?? this.afterSalahMaghribTime,
      afterSalahIsha: afterSalahIsha ?? this.afterSalahIsha,
      afterSalahIshaTime: afterSalahIshaTime ?? this.afterSalahIshaTime,
      notificationPermissionGranted:
          notificationPermissionGranted ?? this.notificationPermissionGranted,
      periodicBackupEnabled:
          periodicBackupEnabled ?? this.periodicBackupEnabled,
      backupDirectory: identical(backupDirectory, _sentinel)
          ? this.backupDirectory
          : backupDirectory as String?,
    );
  }
}

// Sentinel object to distinguish "not provided" from "explicitly null".
const Object _sentinel = Object();

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences prefs;

  SettingsNotifier(this.prefs)
    : super(
        SettingsState(
          hapticEnabled: prefs.getBool('hapticEnabled') ?? true,
          soundEnabled: prefs.getBool('soundEnabled') ?? true,
          volume: prefs.getDouble('volume') ?? 0.5,
          hapticIntensity: prefs.getDouble('hapticIntensity') ?? 0.5,
          background: prefs.getString('background') ?? '',
          backgroundOpacity: prefs.getDouble('backgroundOpacity') ?? 0.4,
          pressButtonStyle: _parseStyle(prefs.getString('pressButtonStyle')),
          buttonSize: prefs.getDouble('buttonSize') ?? 240.0,
          tapFreezeEnabled: prefs.getBool('tapFreezeEnabled') ?? true,
          tapFreezeDuration: prefs.getInt('tapFreezeDuration') ?? 100,
          lastDhikrId: prefs.getString('lastDhikrId') ?? 'subhanallah',
          showArabic: prefs.getBool('showArabic') ?? true,
          showTransliteration: prefs.getBool('showTransliteration') ?? true,
          showTranslation: prefs.getBool('showTranslation') ?? true,
          tapSound: prefs.getBool('tapSound') ?? true,
          goalReachedSound: prefs.getBool('goalReachedSound') ?? true,
          goalHapticPattern: prefs.getBool('goalHapticPattern') ?? true,
          vibrateOnMilestone: prefs.getBool('vibrateOnMilestone') ?? true,
          milestoneValue: prefs.getInt('milestoneValue') ?? 100,
          showParticles: prefs.getBool('showParticles') ?? false,
          themeMode: _parseThemeMode(prefs.getString('themeMode')),
          colorScheme: _parseColorScheme(prefs.getString('colorScheme')),
          morningReminder: prefs.getBool('morningReminder') ?? false,
          morningTime: _parseTime(prefs.getString('morningTime'), 8, 0),
          eveningReminder: prefs.getBool('eveningReminder') ?? false,
          eveningTime: _parseTime(prefs.getString('eveningTime'), 19, 0),
          sayingReminders: prefs.getBool('sayingReminders') ?? false,
          sayingsPerDay: prefs.getInt('sayingsPerDay') ?? 3,
          afterSalahReminder: prefs.getBool('afterSalahReminder') ?? false,
          afterSalahFajr: prefs.getBool('afterSalahFajr') ?? false,
          afterSalahFajrTime: _parseTime(
            prefs.getString('afterSalahFajrTime'),
            5,
            30,
          ),
          afterSalahDhuhr: prefs.getBool('afterSalahDhuhr') ?? false,
          afterSalahDhuhrTime: _parseTime(
            prefs.getString('afterSalahDhuhrTime'),
            13,
            0,
          ),
          afterSalahAsr: prefs.getBool('afterSalahAsr') ?? false,
          afterSalahAsrTime: _parseTime(
            prefs.getString('afterSalahAsrTime'),
            16,
            30,
          ),
          afterSalahMaghrib: prefs.getBool('afterSalahMaghrib') ?? false,
          afterSalahMaghribTime: _parseTime(
            prefs.getString('afterSalahMaghribTime'),
            18,
            45,
          ),
          afterSalahIsha: prefs.getBool('afterSalahIsha') ?? false,
          afterSalahIshaTime: _parseTime(
            prefs.getString('afterSalahIshaTime'),
            20,
            0,
          ),
          notificationPermissionGranted: false,
          periodicBackupEnabled:
              prefs.getBool('periodicBackupEnabled') ?? false,
          backupDirectory: prefs.getString('backupDirectory'),
        ),
      ) {
    refreshPermissionStatus();
  }

  static PressButtonStyle _parseStyle(String? style) {
    switch (style) {
      case 'classicWavy':
        return PressButtonStyle.classicWavy;
      case 'midnightGlass':
        return PressButtonStyle.midnightGlass;
      case 'glowingBall':
        return PressButtonStyle.glowingBall;
      default:
        return PressButtonStyle.classicWavy;
    }
  }

  static ThemeMode _parseThemeMode(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  static AppColorScheme _parseColorScheme(String? scheme) {
    switch (scheme) {
      case 'sage':
        return AppColorScheme.sage;
      case 'slate':
        return AppColorScheme.slate;
      default:
        return AppColorScheme.sage;
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

  // Setters
  Future<void> toggleHaptic(bool value) async {
    await prefs.setBool('hapticEnabled', value);
    state = state.copyWith(hapticEnabled: value);
  }

  Future<void> toggleTapSound(bool value) async {
    await prefs.setBool('tapSound', value);
    state = state.copyWith(tapSound: value);
  }

  Future<void> toggleGoalReachedSound(bool value) async {
    await prefs.setBool('goalReachedSound', value);
    state = state.copyWith(goalReachedSound: value);
  }

  Future<void> toggleGoalHapticPattern(bool value) async {
    await prefs.setBool('goalHapticPattern', value);
    state = state.copyWith(goalHapticPattern: value);
  }

  Future<void> toggleVibrateOnMilestone(bool value) async {
    await prefs.setBool('vibrateOnMilestone', value);
    state = state.copyWith(vibrateOnMilestone: value);
  }

  Future<void> setMilestoneValue(int value) async {
    await prefs.setInt('milestoneValue', value);
    state = state.copyWith(milestoneValue: value);
  }

  Future<void> toggleShowParticles(bool value) async {
    await prefs.setBool('showParticles', value);
    state = state.copyWith(showParticles: value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await prefs.setString('themeMode', mode.name);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setColorScheme(AppColorScheme scheme) async {
    await prefs.setString('colorScheme', scheme.name);
    state = state.copyWith(colorScheme: scheme);
  }

  Future<void> setLastDhikrId(String id) async {
    await prefs.setString('lastDhikrId', id);
    state = state.copyWith(lastDhikrId: id);
  }

  Future<void> toggleShowArabic(bool v) async {
    await prefs.setBool('showArabic', v);
    state = state.copyWith(showArabic: v);
  }

  Future<void> toggleShowTransliteration(bool v) async {
    await prefs.setBool('showTransliteration', v);
    state = state.copyWith(showTransliteration: v);
  }

  Future<void> toggleShowTranslation(bool v) async {
    await prefs.setBool('showTranslation', v);
    state = state.copyWith(showTranslation: v);
  }

  // Original Setters with compatibility aliases
  Future<void> toggleSound(bool value) async {
    await prefs.setBool('soundEnabled', value);
    state = state.copyWith(soundEnabled: value);
  }

  Future<void> setVolume(double value) async {
    await prefs.setDouble('volume', value);
    state = state.copyWith(volume: value);
  }

  Future<void> setHapticIntensity(double value) async {
    await prefs.setDouble('hapticIntensity', value);
    state = state.copyWith(hapticIntensity: value);
  }

  Future<void> setBackground(String path) async {
    await prefs.setString('background', path);
    state = state.copyWith(background: path);
  }

  Future<void> setBackgroundOpacity(double value) async {
    await prefs.setDouble('backgroundOpacity', value);
    state = state.copyWith(backgroundOpacity: value);
  }

  Future<void> setPressButtonStyle(PressButtonStyle style) async {
    await setButtonStyle(style);
  }

  Future<void> setButtonStyle(PressButtonStyle style) async {
    await prefs.setString('pressButtonStyle', style.name);
    state = state.copyWith(pressButtonStyle: style);
  }

  Future<void> setButtonSize(double value) async {
    await prefs.setDouble('buttonSize', value);
    state = state.copyWith(buttonSize: value);
  }

  Future<void> toggleTapFreeze(bool value) async {
    await prefs.setBool('tapFreezeEnabled', value);
    state = state.copyWith(tapFreezeEnabled: value);
  }

  Future<void> setTapFreezeDuration(int value) async {
    await prefs.setInt('tapFreezeDuration', value);
    state = state.copyWith(tapFreezeDuration: value);
  }

  // Reminders
  Future<void> toggleMorningReminder(bool v) async {
    await prefs.setBool('morningReminder', v);
    state = state.copyWith(morningReminder: v);
  }

  Future<void> setMorningTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await prefs.setString('morningTime', jsonEncode(time.toJson()));
    state = state.copyWith(morningTime: time);
  }

  Future<void> toggleEveningReminder(bool v) async {
    await prefs.setBool('eveningReminder', v);
    state = state.copyWith(eveningReminder: v);
  }

  Future<void> setEveningTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await prefs.setString('eveningTime', jsonEncode(time.toJson()));
    state = state.copyWith(eveningTime: time);
  }

  Future<void> toggleSayingReminders(bool v) async {
    await prefs.setBool('sayingReminders', v);
    state = state.copyWith(sayingReminders: v);
  }

  Future<void> setSayingsPerDay(int v) async {
    await prefs.setInt('sayingsPerDay', v);
    state = state.copyWith(sayingsPerDay: v);
  }

  Future<void> toggleAfterSalahReminder(bool v) async {
    await prefs.setBool('afterSalahReminder', v);
    state = state.copyWith(afterSalahReminder: v);
  }

  Future<void> toggleAfterSalahFajr(bool v) async {
    await prefs.setBool('afterSalahFajr', v);
    state = state.copyWith(afterSalahFajr: v);
  }

  Future<void> setAfterSalahFajrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await prefs.setString('afterSalahFajrTime', jsonEncode(time.toJson()));
    state = state.copyWith(afterSalahFajrTime: time);
  }

  Future<void> toggleAfterSalahDhuhr(bool v) async {
    await prefs.setBool('afterSalahDhuhr', v);
    state = state.copyWith(afterSalahDhuhr: v);
  }

  Future<void> setAfterSalahDhuhrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await prefs.setString('afterSalahDhuhrTime', jsonEncode(time.toJson()));
    state = state.copyWith(afterSalahDhuhrTime: time);
  }

  Future<void> toggleAfterSalahAsr(bool v) async {
    await prefs.setBool('afterSalahAsr', v);
    state = state.copyWith(afterSalahAsr: v);
  }

  Future<void> setAfterSalahAsrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await prefs.setString('afterSalahAsrTime', jsonEncode(time.toJson()));
    state = state.copyWith(afterSalahAsrTime: time);
  }

  Future<void> toggleAfterSalahMaghrib(bool v) async {
    await prefs.setBool('afterSalahMaghrib', v);
    state = state.copyWith(afterSalahMaghrib: v);
  }

  Future<void> setAfterSalahMaghribTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await prefs.setString('afterSalahMaghribTime', jsonEncode(time.toJson()));
    state = state.copyWith(afterSalahMaghribTime: time);
  }

  Future<void> toggleAfterSalahIsha(bool v) async {
    await prefs.setBool('afterSalahIsha', v);
    state = state.copyWith(afterSalahIsha: v);
  }

  Future<void> setAfterSalahIshaTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await prefs.setString('afterSalahIshaTime', jsonEncode(time.toJson()));
    state = state.copyWith(afterSalahIshaTime: time);
  }

  Future<void> togglePeriodicBackup(bool v) async {
    await prefs.setBool('periodicBackupEnabled', v);
    state = state.copyWith(periodicBackupEnabled: v);

    // Register or cancel the background task live.
    if (v && state.backupDirectory != null) {
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
      await prefs.remove('backupDirectory');
    } else {
      await prefs.setString('backupDirectory', path);
    }
    state = state.copyWith(backupDirectory: path);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => throw UnimplementedError(),
);
