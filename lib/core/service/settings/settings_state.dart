import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:flutter/material.dart' show ThemeMode;

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

class AppearanceSettings {
  final String background;
  final double backgroundOpacity;
  final PressButtonStyle pressButtonStyle;
  final double buttonSize;
  final ThemeMode themeMode;
  final AppColorScheme colorScheme;
  final bool centerButton;

  const AppearanceSettings({
    required this.background,
    required this.backgroundOpacity,
    required this.pressButtonStyle,
    required this.buttonSize,
    required this.themeMode,
    required this.colorScheme,
    required this.centerButton,
  });

  AppearanceSettings copyWith({
    String? background,
    double? backgroundOpacity,
    PressButtonStyle? pressButtonStyle,
    double? buttonSize,
    ThemeMode? themeMode,
    AppColorScheme? colorScheme,
    bool? centerButton,
  }) {
    return AppearanceSettings(
      background: background ?? this.background,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      pressButtonStyle: pressButtonStyle ?? this.pressButtonStyle,
      buttonSize: buttonSize ?? this.buttonSize,
      themeMode: themeMode ?? this.themeMode,
      colorScheme: colorScheme ?? this.colorScheme,
      centerButton: centerButton ?? this.centerButton,
    );
  }
}

class FeedbackSettings {
  final bool hapticEnabled;
  final double hapticIntensity;
  final bool soundEnabled;
  final double volume;
  final bool tapSound;
  final bool goalReachedSound;
  final bool goalHapticPattern;
  final bool vibrateOnMilestone;
  final int milestoneValue;
  final bool showParticles;

  const FeedbackSettings({
    required this.hapticEnabled,
    required this.hapticIntensity,
    required this.soundEnabled,
    required this.volume,
    required this.tapSound,
    required this.goalReachedSound,
    required this.goalHapticPattern,
    required this.vibrateOnMilestone,
    required this.milestoneValue,
    required this.showParticles,
  });

  FeedbackSettings copyWith({
    bool? hapticEnabled,
    double? hapticIntensity,
    bool? soundEnabled,
    double? volume,
    bool? tapSound,
    bool? goalReachedSound,
    bool? goalHapticPattern,
    bool? vibrateOnMilestone,
    int? milestoneValue,
    bool? showParticles,
  }) {
    return FeedbackSettings(
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      hapticIntensity: hapticIntensity ?? this.hapticIntensity,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      volume: volume ?? this.volume,
      tapSound: tapSound ?? this.tapSound,
      goalReachedSound: goalReachedSound ?? this.goalReachedSound,
      goalHapticPattern: goalHapticPattern ?? this.goalHapticPattern,
      vibrateOnMilestone: vibrateOnMilestone ?? this.vibrateOnMilestone,
      milestoneValue: milestoneValue ?? this.milestoneValue,
      showParticles: showParticles ?? this.showParticles,
    );
  }
}

class ReminderSettings {
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

  const ReminderSettings({
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
  });

  ReminderSettings copyWith({
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
  }) {
    return ReminderSettings(
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
      afterSalahMaghribTime: afterSalahMaghribTime ?? this.afterSalahMaghribTime,
      afterSalahIsha: afterSalahIsha ?? this.afterSalahIsha,
      afterSalahIshaTime: afterSalahIshaTime ?? this.afterSalahIshaTime,
    );
  }
}

class BackupSettings {
  final bool periodicBackupEnabled;
  final String? backupDirectory;

  const BackupSettings({
    required this.periodicBackupEnabled,
    this.backupDirectory,
  });

  BackupSettings copyWith({
    bool? periodicBackupEnabled,
    Object? backupDirectory = _sentinel,
  }) {
    return BackupSettings(
      periodicBackupEnabled: periodicBackupEnabled ?? this.periodicBackupEnabled,
      backupDirectory: identical(backupDirectory, _sentinel)
          ? this.backupDirectory
          : backupDirectory as String?,
    );
  }
}

class DhikrSettings {
  final String lastDhikrId;
  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final bool tapFreezeEnabled;
  final int tapFreezeDuration;

  const DhikrSettings({
    required this.lastDhikrId,
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    required this.tapFreezeEnabled,
    required this.tapFreezeDuration,
  });

  DhikrSettings copyWith({
    String? lastDhikrId,
    bool? showArabic,
    bool? showTransliteration,
    bool? showTranslation,
    bool? tapFreezeEnabled,
    int? tapFreezeDuration,
  }) {
    return DhikrSettings(
      lastDhikrId: lastDhikrId ?? this.lastDhikrId,
      showArabic: showArabic ?? this.showArabic,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      tapFreezeEnabled: tapFreezeEnabled ?? this.tapFreezeEnabled,
      tapFreezeDuration: tapFreezeDuration ?? this.tapFreezeDuration,
    );
  }
}

class SettingsState {
  final AppearanceSettings appearance;
  final FeedbackSettings feedback;
  final ReminderSettings reminders;
  final BackupSettings backup;
  final DhikrSettings dhikr;
  final bool notificationPermissionGranted;
  final bool onboardingCompleted;

  const SettingsState({
    required this.appearance,
    required this.feedback,
    required this.reminders,
    required this.backup,
    required this.dhikr,
    required this.notificationPermissionGranted,
    required this.onboardingCompleted,
  });

  SettingsState copyWith({
    AppearanceSettings? appearance,
    FeedbackSettings? feedback,
    ReminderSettings? reminders,
    BackupSettings? backup,
    DhikrSettings? dhikr,
    bool? notificationPermissionGranted,
    bool? onboardingCompleted,
  }) {
    return SettingsState(
      appearance: appearance ?? this.appearance,
      feedback: feedback ?? this.feedback,
      reminders: reminders ?? this.reminders,
      backup: backup ?? this.backup,
      dhikr: dhikr ?? this.dhikr,
      notificationPermissionGranted: notificationPermissionGranted ?? this.notificationPermissionGranted,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  // Helper getters for backward compatibility (optional but recommended)
  ThemeMode get themeMode => appearance.themeMode;
  AppColorScheme get colorScheme => appearance.colorScheme;
  String get background => appearance.background;
  double get backgroundOpacity => appearance.backgroundOpacity;
  PressButtonStyle get pressButtonStyle => appearance.pressButtonStyle;
  double get buttonSize => appearance.buttonSize;
  bool get centerButton => appearance.centerButton;

  bool get hapticEnabled => feedback.hapticEnabled;
  double get hapticIntensity => feedback.hapticIntensity;
  bool get soundEnabled => feedback.soundEnabled;
  double get volume => feedback.volume;
  bool get tapSound => feedback.tapSound;
  bool get goalReachedSound => feedback.goalReachedSound;
  bool get goalHapticPattern => feedback.goalHapticPattern;
  bool get vibrateOnMilestone => feedback.vibrateOnMilestone;
  int get milestoneValue => feedback.milestoneValue;
  bool get showParticles => feedback.showParticles;

  bool get morningReminder => reminders.morningReminder;
  ReminderTime get morningTime => reminders.morningTime;
  bool get eveningReminder => reminders.eveningReminder;
  ReminderTime get eveningTime => reminders.eveningTime;
  bool get sayingReminders => reminders.sayingReminders;
  int get sayingsPerDay => reminders.sayingsPerDay;
  bool get afterSalahReminder => reminders.afterSalahReminder;
  bool get afterSalahFajr => reminders.afterSalahFajr;
  ReminderTime get afterSalahFajrTime => reminders.afterSalahFajrTime;
  bool get afterSalahDhuhr => reminders.afterSalahDhuhr;
  ReminderTime get afterSalahDhuhrTime => reminders.afterSalahDhuhrTime;
  bool get afterSalahAsr => reminders.afterSalahAsr;
  ReminderTime get afterSalahAsrTime => reminders.afterSalahAsrTime;
  bool get afterSalahMaghrib => reminders.afterSalahMaghrib;
  ReminderTime get afterSalahMaghribTime => reminders.afterSalahMaghribTime;
  bool get afterSalahIsha => reminders.afterSalahIsha;
  ReminderTime get afterSalahIshaTime => reminders.afterSalahIshaTime;

  bool get periodicBackupEnabled => backup.periodicBackupEnabled;
  String? get backupDirectory => backup.backupDirectory;

  String get lastDhikrId => dhikr.lastDhikrId;
  bool get showArabic => dhikr.showArabic;
  bool get showTransliteration => dhikr.showTransliteration;
  bool get showTranslation => dhikr.showTranslation;
  bool get tapFreezeEnabled => dhikr.tapFreezeEnabled;
  int get tapFreezeDuration => dhikr.tapFreezeDuration;
}

const Object _sentinel = Object();
