import 'package:flutter/material.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:easy_tasweeh/core/service/notification_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PressButtonStyle {
  first,
  second,
  third,
  tealCircular,
  slateRounded,
  amberGradient,
  purpleOutlined,
  coralSoft,
  midnightGlass,
  neonGlow,
  emeraldMinimal,
  royalGold
}


final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);

class ReminderTime {
  final int hour;
  final int minute;

  const ReminderTime({required this.hour, required this.minute});

  String get label {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  ReminderTime copyWith({int? hour, int? minute}) {
    return ReminderTime(hour: hour ?? this.hour, minute: minute ?? this.minute);
  }
}

class SettingsState {
  final bool morningReminder;
  final bool eveningReminder;
  final bool hapticEnabled;
  final ReminderTime morningTime;
  final ReminderTime eveningTime;

  /// Vibration amplitude for every dhikr tap: 1–255
  final int vibrationAmplitude;

  /// Vibration amplitude for session completion: 1–255
  final int completionVibrationAmplitude;

  /// Whether the user has granted notification permission
  final bool notificationPermissionGranted;

  // ── New appearance / behaviour fields ──────────────────────────────────────
  final bool keepScreenOn;
  final bool tapSound;
  final bool goalReachedSound;
  final bool goalHapticPattern;
  final bool afterSalahReminder;
  final bool autoResetOnGoal;
  final bool resumeLastSession;
  final ThemeMode themeMode;
  final AppColorScheme colorScheme;
  final String background;
  final double backgroundOpacity;
  final PressButtonStyle pressButtonStyle;
  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final bool vibrateOnMilestone;
  final int milestoneValue;
  final double buttonSize;
  final bool showParticles;

  SettingsState({
    required this.morningReminder,
    required this.eveningReminder,
    required this.hapticEnabled,
    required this.morningTime,
    required this.eveningTime,
    required this.vibrationAmplitude,
    required this.completionVibrationAmplitude,
    required this.notificationPermissionGranted,
    required this.keepScreenOn,
    required this.tapSound,
    required this.goalReachedSound,
    required this.goalHapticPattern,
    required this.afterSalahReminder,
    required this.autoResetOnGoal,
    required this.resumeLastSession,
    required this.themeMode,
    required this.colorScheme,
    required this.background,
    required this.backgroundOpacity,
    required this.pressButtonStyle,
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    required this.vibrateOnMilestone,
    required this.milestoneValue,
    required this.buttonSize,
    required this.showParticles,
  });

  SettingsState copyWith({
    bool? morningReminder,
    bool? eveningReminder,
    bool? hapticEnabled,
    ReminderTime? morningTime,
    ReminderTime? eveningTime,
    int? vibrationAmplitude,
    int? completionVibrationAmplitude,
    bool? notificationPermissionGranted,
    bool? keepScreenOn,
    bool? tapSound,
    bool? goalReachedSound,
    bool? goalHapticPattern,
    bool? afterSalahReminder,
    bool? autoResetOnGoal,
    bool? resumeLastSession,
    ThemeMode? themeMode,
    AppColorScheme? colorScheme,
    String? background,
    double? backgroundOpacity,
    PressButtonStyle? pressButtonStyle,
    bool? showArabic,
    bool? showTransliteration,
    bool? showTranslation,
    bool? vibrateOnMilestone,
    int? milestoneValue,
    double? buttonSize,
    bool? showParticles,
  }) {
    return SettingsState(
      morningReminder: morningReminder ?? this.morningReminder,
      eveningReminder: eveningReminder ?? this.eveningReminder,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      morningTime: morningTime ?? this.morningTime,
      eveningTime: eveningTime ?? this.eveningTime,
      vibrationAmplitude: vibrationAmplitude ?? this.vibrationAmplitude,
      completionVibrationAmplitude:
          completionVibrationAmplitude ?? this.completionVibrationAmplitude,
      notificationPermissionGranted:
          notificationPermissionGranted ?? this.notificationPermissionGranted,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      tapSound: tapSound ?? this.tapSound,
      goalReachedSound: goalReachedSound ?? this.goalReachedSound,
      goalHapticPattern: goalHapticPattern ?? this.goalHapticPattern,
      afterSalahReminder: afterSalahReminder ?? this.afterSalahReminder,
      autoResetOnGoal: autoResetOnGoal ?? this.autoResetOnGoal,
      resumeLastSession: resumeLastSession ?? this.resumeLastSession,
      themeMode: themeMode ?? this.themeMode,
      colorScheme: colorScheme ?? this.colorScheme,
      background: background ?? this.background,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      pressButtonStyle: pressButtonStyle ?? this.pressButtonStyle,
      showArabic: showArabic ?? this.showArabic,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      vibrateOnMilestone: vibrateOnMilestone ?? this.vibrateOnMilestone,
      milestoneValue: milestoneValue ?? this.milestoneValue,
      buttonSize: buttonSize ?? this.buttonSize,
      showParticles: showParticles ?? this.showParticles,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
    : super(
        SettingsState(
          morningReminder: false,
          eveningReminder: false,
          hapticEnabled: true,
          morningTime: const ReminderTime(hour: 8, minute: 0),
          eveningTime: const ReminderTime(hour: 20, minute: 0),
          vibrationAmplitude: 50,
          completionVibrationAmplitude: 100,
          notificationPermissionGranted: false,
          keepScreenOn: false,
          tapSound: false,
          goalReachedSound: true,
          goalHapticPattern: true,
          afterSalahReminder: false,
          autoResetOnGoal: true,
          resumeLastSession: false,
          themeMode: ThemeMode.system,
          colorScheme: AppColorScheme.teal,
          background: 'assets/images/bg/bg-1.png',
          backgroundOpacity: 0.75,
          pressButtonStyle: PressButtonStyle.first,
          showArabic: true,
          showTransliteration: true,
          showTranslation: true,
          vibrateOnMilestone: true,
          milestoneValue: 33,
          buttonSize: 220,
          showParticles: false,
        ),
      ) {
    _loadSettings();
  }

  // ── SharedPreferences keys ─────────────────────────────────────────────────
  static const _morningRemKey = 'morning_reminder';
  static const _eveningRemKey = 'evening_reminder';
  static const _hapticKey = 'haptic_enabled';
  static const _morningHourKey = 'morning_hour';
  static const _morningMinuteKey = 'morning_minute';
  static const _eveningHourKey = 'evening_hour';
  static const _eveningMinuteKey = 'evening_minute';
  static const _vibrationAmplitudeKey = 'vibration_amplitude';
  static const _completionVibrationAmplitudeKey =
      'completion_vibration_amplitude';
  static const _keepScreenOnKey = 'keep_screen_on';
  static const _tapSoundKey = 'tap_sound';
  static const _goalReachedSoundKey = 'goal_reached_sound';
  static const _goalHapticPatternKey = 'goal_haptic_pattern';
  static const _afterSalahReminderKey = 'after_salah_reminder';
  static const _autoResetOnGoalKey = 'auto_reset_on_goal';
  static const _resumeLastSessionKey = 'resume_last_session';
  static const _themeModeKey = 'theme_mode';
  static const _colorSchemeKey = 'color_scheme';
  static const _backgroundKey = 'background';
  static const _backgroundOpacityKey = 'background_opacity';
  static const _pressButtonStyleKey = 'press_button_style';
  static const _showArabicKey = 'show_arabic';
  static const _showTransliterationKey = 'show_transliteration';
  static const _showTranslationKey = 'show_translation';
  static const _vibrateOnMilestoneKey = 'vibrate_on_milestone';
  static const _milestoneValueKey = 'milestone_value';
  static const _buttonSizeKey = 'button_size';
  static const _showParticlesKey = 'show_particles';

  final NotificationService _notificationService = NotificationService();

  // ── Load ───────────────────────────────────────────────────────────────────
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final permissionStatus = await Permission.notification.status;
    state = SettingsState(
      morningReminder: prefs.getBool(_morningRemKey) ?? false,
      eveningReminder: prefs.getBool(_eveningRemKey) ?? false,
      hapticEnabled: prefs.getBool(_hapticKey) ?? true,
      morningTime: ReminderTime(
        hour: prefs.getInt(_morningHourKey) ?? 8,
        minute: prefs.getInt(_morningMinuteKey) ?? 0,
      ),
      eveningTime: ReminderTime(
        hour: prefs.getInt(_eveningHourKey) ?? 20,
        minute: prefs.getInt(_eveningMinuteKey) ?? 0,
      ),
      vibrationAmplitude: prefs.getInt(_vibrationAmplitudeKey) ?? 50,
      completionVibrationAmplitude:
          prefs.getInt(_completionVibrationAmplitudeKey) ?? 100,
      notificationPermissionGranted: permissionStatus.isGranted,
      keepScreenOn: prefs.getBool(_keepScreenOnKey) ?? false,
      tapSound: prefs.getBool(_tapSoundKey) ?? false,
      goalReachedSound: prefs.getBool(_goalReachedSoundKey) ?? true,
      goalHapticPattern: prefs.getBool(_goalHapticPatternKey) ?? true,
      afterSalahReminder: prefs.getBool(_afterSalahReminderKey) ?? false,
      autoResetOnGoal: prefs.getBool(_autoResetOnGoalKey) ?? true,
      resumeLastSession: prefs.getBool(_resumeLastSessionKey) ?? false,
      themeMode: ThemeMode
          .values[prefs.getInt(_themeModeKey) ?? ThemeMode.system.index],
      colorScheme: AppColorScheme
          .values[prefs.getInt(_colorSchemeKey) ?? AppColorScheme.teal.index],
      background: prefs.getString(_backgroundKey) ?? 'assets/images/bg/bg-1.png',
      backgroundOpacity: prefs.getDouble(_backgroundOpacityKey) ?? 0.75,
      pressButtonStyle: PressButtonStyle
          .values[prefs.getInt(_pressButtonStyleKey) ?? PressButtonStyle.first.index],
      showArabic: prefs.getBool(_showArabicKey) ?? true,
      showTransliteration: prefs.getBool(_showTransliterationKey) ?? true,
      showTranslation: prefs.getBool(_showTranslationKey) ?? true,
      vibrateOnMilestone: prefs.getBool(_vibrateOnMilestoneKey) ?? true,
      milestoneValue: prefs.getInt(_milestoneValueKey) ?? 33,
      buttonSize: prefs.getDouble(_buttonSizeKey) ?? 220,
      showParticles: prefs.getBool(_showParticlesKey) ?? false,
    );
  }

  // ── Permission ─────────────────────────────────────────────────────────────
  Future<bool> requestNotificationPermission() async {
    await _notificationService.requestPermissions();
    final status = await Permission.notification.status;
    state = state.copyWith(notificationPermissionGranted: status.isGranted);
    return status.isGranted;
  }

  Future<void> refreshPermissionStatus() async {
    final status = await Permission.notification.status;
    state = state.copyWith(notificationPermissionGranted: status.isGranted);
  }

  // ── Morning reminder ───────────────────────────────────────────────────────
  Future<void> toggleMorningReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_morningRemKey, value);
    state = state.copyWith(morningReminder: value);

    if (value) {
      await _notificationService.scheduleDailyNotification(
        id: 101,
        title: 'Morning Tasweeh',
        body: 'Start your day with remembrance.',
        hour: state.morningTime.hour,
        minute: state.morningTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(101);
    }
  }

  Future<void> setMorningTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_morningHourKey, hour);
    await prefs.setInt(_morningMinuteKey, minute);
    state = state.copyWith(
      morningTime: ReminderTime(hour: hour, minute: minute),
    );

    if (state.morningReminder) {
      await _notificationService.scheduleDailyNotification(
        id: 101,
        title: 'Morning Tasweeh',
        body: 'Start your day with remembrance.',
        hour: hour,
        minute: minute,
      );
    }
  }

  // ── Evening reminder ───────────────────────────────────────────────────────
  Future<void> toggleEveningReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eveningRemKey, value);
    state = state.copyWith(eveningReminder: value);

    if (value) {
      await _notificationService.scheduleDailyNotification(
        id: 102,
        title: 'Evening Tasweeh',
        body: 'End your day with peace and gratitude.',
        hour: state.eveningTime.hour,
        minute: state.eveningTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(102);
    }
  }

  Future<void> setEveningTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_eveningHourKey, hour);
    await prefs.setInt(_eveningMinuteKey, minute);
    state = state.copyWith(
      eveningTime: ReminderTime(hour: hour, minute: minute),
    );

    if (state.eveningReminder) {
      await _notificationService.scheduleDailyNotification(
        id: 102,
        title: 'Evening Tasweeh',
        body: 'End your day with peace and gratitude.',
        hour: hour,
        minute: minute,
      );
    }
  }

  // ── Haptic ─────────────────────────────────────────────────────────────────
  Future<void> toggleHaptic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticKey, value);
    state = state.copyWith(hapticEnabled: value);
  }

  // ── Vibration amplitude ────────────────────────────────────────────────────
  Future<void> setVibrationAmplitude(int amplitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_vibrationAmplitudeKey, amplitude);
    state = state.copyWith(vibrationAmplitude: amplitude);
  }

  Future<void> setCompletionVibrationAmplitude(int amplitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_completionVibrationAmplitudeKey, amplitude);
    state = state.copyWith(completionVibrationAmplitude: amplitude);
  }

  // ── New appearance & behaviour toggles ────────────────────────────────────
  Future<void> toggleKeepScreenOn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keepScreenOnKey, value);
    state = state.copyWith(keepScreenOn: value);
  }

  Future<void> toggleTapSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tapSoundKey, value);
    state = state.copyWith(tapSound: value);
  }

  Future<void> toggleGoalReachedSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_goalReachedSoundKey, value);
    state = state.copyWith(goalReachedSound: value);
  }

  Future<void> toggleGoalHapticPattern(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_goalHapticPatternKey, value);
    state = state.copyWith(goalHapticPattern: value);
  }

  Future<void> toggleAfterSalahReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_afterSalahReminderKey, value);
    state = state.copyWith(afterSalahReminder: value);
  }

  Future<void> toggleAutoResetOnGoal(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoResetOnGoalKey, value);
    state = state.copyWith(autoResetOnGoal: value);
  }

  Future<void> toggleResumeLastSession(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_resumeLastSessionKey, value);
    state = state.copyWith(resumeLastSession: value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setColorScheme(AppColorScheme scheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorSchemeKey, scheme.index);
    state = state.copyWith(colorScheme: scheme);
  }

  Future<void> setBackground(String background) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundKey, background);
    state = state.copyWith(background: background);
  }

  Future<void> setBackgroundOpacity(double opacity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_backgroundOpacityKey, opacity);
    state = state.copyWith(backgroundOpacity: opacity);
  }

  Future<void> setPressButtonStyle(PressButtonStyle style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pressButtonStyleKey, style.index);
    state = state.copyWith(pressButtonStyle: style);
  }

  Future<void> toggleShowArabic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showArabicKey, value);
    state = state.copyWith(showArabic: value);
  }

  Future<void> toggleShowTransliteration(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showTransliterationKey, value);
    state = state.copyWith(showTransliteration: value);
  }

  Future<void> toggleShowTranslation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showTranslationKey, value);
    state = state.copyWith(showTranslation: value);
  }

  Future<void> toggleVibrateOnMilestone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrateOnMilestoneKey, value);
    state = state.copyWith(vibrateOnMilestone: value);
  }

  Future<void> setMilestoneValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_milestoneValueKey, value);
    state = state.copyWith(milestoneValue: value);
  }

  Future<void> setButtonSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_buttonSizeKey, size);
    state = state.copyWith(buttonSize: size);
  }

  Future<void> toggleShowParticles(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showParticlesKey, value);
    state = state.copyWith(showParticles: value);
  }
}
