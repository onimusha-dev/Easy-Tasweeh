import 'package:easy_tasweeh/core/service/notification_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

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
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(SettingsState(
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
        )) {
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
    state = state.copyWith(morningTime: ReminderTime(hour: hour, minute: minute));

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
    state = state.copyWith(eveningTime: ReminderTime(hour: hour, minute: minute));

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
}
