import 'package:flutter/material.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:easy_tasweeh/core/service/notification_service.dart';
import 'package:easy_tasweeh/core/models/saying_model.dart';
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
  final bool sayingReminders;
  final int sayingsPerDay;
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
  final String lastDhikrId;

  SettingsState({
    required this.morningReminder,
    required this.eveningReminder,
    required this.hapticEnabled,
    required this.morningTime,
    required this.eveningTime,
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
    required this.sayingReminders,
    required this.sayingsPerDay,
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
    required this.lastDhikrId,
  });

  SettingsState copyWith({
    bool? morningReminder,
    bool? eveningReminder,
    bool? hapticEnabled,
    ReminderTime? morningTime,
    ReminderTime? eveningTime,
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
    bool? sayingReminders,
    int? sayingsPerDay,
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
    String? lastDhikrId,
  }) {
    return SettingsState(
      morningReminder: morningReminder ?? this.morningReminder,
      eveningReminder: eveningReminder ?? this.eveningReminder,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      morningTime: morningTime ?? this.morningTime,
      eveningTime: eveningTime ?? this.eveningTime,
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
      sayingReminders: sayingReminders ?? this.sayingReminders,
      sayingsPerDay: sayingsPerDay ?? this.sayingsPerDay,
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
      lastDhikrId: lastDhikrId ?? this.lastDhikrId,
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
          background: '',
          backgroundOpacity: 0.75,
          pressButtonStyle: PressButtonStyle.first,
          showArabic: true,
          showTransliteration: true,
          showTranslation: true,
          vibrateOnMilestone: true,
          milestoneValue: 33,
          buttonSize: 220,
          showParticles: false,
          sayingReminders: true,
          sayingsPerDay: 3,
          afterSalahFajr: false,
          afterSalahFajrTime: const ReminderTime(hour: 5, minute: 0),
          afterSalahDhuhr: false,
          afterSalahDhuhrTime: const ReminderTime(hour: 13, minute: 0),
          afterSalahAsr: false,
          afterSalahAsrTime: const ReminderTime(hour: 16, minute: 30),
          afterSalahMaghrib: false,
          afterSalahMaghribTime: const ReminderTime(hour: 18, minute: 30),
          afterSalahIsha: false,
          afterSalahIshaTime: const ReminderTime(hour: 20, minute: 30),
          lastDhikrId: 'subhanallah',
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
  static const _sayingRemindersKey = 'saying_reminders';
  static const _sayingsPerDayKey = 'sayings_per_day';
  static const _afterSalahFajrKey = 'after_salah_fajr';
  static const _afterSalahFajrHourKey = 'after_salah_fajr_hour';
  static const _afterSalahFajrMinKey = 'after_salah_fajr_min';
  static const _afterSalahDhuhrKey = 'after_salah_dhuhr';
  static const _afterSalahDhuhrHourKey = 'after_salah_dhuhr_hour';
  static const _afterSalahDhuhrMinKey = 'after_salah_dhuhr_min';
  static const _afterSalahAsrKey = 'after_salah_asr';
  static const _afterSalahAsrHourKey = 'after_salah_asr_hour';
  static const _afterSalahAsrMinKey = 'after_salah_asr_min';
  static const _afterSalahMaghribKey = 'after_salah_maghrib';
  static const _afterSalahMaghribHourKey = 'after_salah_maghrib_hour';
  static const _afterSalahMaghribMinKey = 'after_salah_maghrib_min';
  static const _afterSalahIshaKey = 'after_salah_isha';
  static const _afterSalahIshaHourKey = 'after_salah_isha_hour';
  static const _afterSalahIshaMinKey = 'after_salah_isha_min';
  static const _lastDhikrIdKey = 'last_dhikr_id';

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
      background: prefs.getString(_backgroundKey) ?? '',
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
      sayingReminders: prefs.getBool(_sayingRemindersKey) ?? true,
      sayingsPerDay: prefs.getInt(_sayingsPerDayKey) ?? 3,
      afterSalahFajr: prefs.getBool(_afterSalahFajrKey) ?? false,
      afterSalahFajrTime: ReminderTime(
        hour: prefs.getInt(_afterSalahFajrHourKey) ?? 5,
        minute: prefs.getInt(_afterSalahFajrMinKey) ?? 0,
      ),
      afterSalahDhuhr: prefs.getBool(_afterSalahDhuhrKey) ?? false,
      afterSalahDhuhrTime: ReminderTime(
        hour: prefs.getInt(_afterSalahDhuhrHourKey) ?? 13,
        minute: prefs.getInt(_afterSalahDhuhrMinKey) ?? 0,
      ),
      afterSalahAsr: prefs.getBool(_afterSalahAsrKey) ?? false,
      afterSalahAsrTime: ReminderTime(
        hour: prefs.getInt(_afterSalahAsrHourKey) ?? 16,
        minute: prefs.getInt(_afterSalahAsrMinKey) ?? 30,
      ),
      afterSalahMaghrib: prefs.getBool(_afterSalahMaghribKey) ?? false,
      afterSalahMaghribTime: ReminderTime(
        hour: prefs.getInt(_afterSalahMaghribHourKey) ?? 18,
        minute: prefs.getInt(_afterSalahMaghribMinKey) ?? 30,
      ),
      afterSalahIsha: prefs.getBool(_afterSalahIshaKey) ?? false,
      afterSalahIshaTime: ReminderTime(
        hour: prefs.getInt(_afterSalahIshaHourKey) ?? 20,
        minute: prefs.getInt(_afterSalahIshaMinKey) ?? 30,
      ),
      lastDhikrId: prefs.getString(_lastDhikrIdKey) ?? 'subhanallah',
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
        title: 'Evening Tasbeeh',
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
    await _updatePrayerNotifications();
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

  Future<void> toggleSayingReminders(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sayingRemindersKey, value);
    state = state.copyWith(sayingReminders: value);
    await _updateSayingNotifications();
  }

  Future<void> setSayingsPerDay(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sayingsPerDayKey, value);
    state = state.copyWith(sayingsPerDay: value);
    await _updateSayingNotifications();
  }

  Future<void> toggleAfterSalahFajr(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_afterSalahFajrKey, value);
    state = state.copyWith(afterSalahFajr: value);
    await _updatePrayerNotifications();
  }

  Future<void> setAfterSalahFajrTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_afterSalahFajrHourKey, hour);
    await prefs.setInt(_afterSalahFajrMinKey, minute);
    state = state.copyWith(
      afterSalahFajrTime: ReminderTime(hour: hour, minute: minute),
      afterSalahFajr: true,
    );
    await _updatePrayerNotifications();
  }

  Future<void> toggleAfterSalahDhuhr(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_afterSalahDhuhrKey, value);
    state = state.copyWith(afterSalahDhuhr: value);
    await _updatePrayerNotifications();
  }

  Future<void> setAfterSalahDhuhrTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_afterSalahDhuhrHourKey, hour);
    await prefs.setInt(_afterSalahDhuhrMinKey, minute);
    state = state.copyWith(
      afterSalahDhuhrTime: ReminderTime(hour: hour, minute: minute),
      afterSalahDhuhr: true,
    );
    await _updatePrayerNotifications();
  }

  Future<void> toggleAfterSalahAsr(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_afterSalahAsrKey, value);
    state = state.copyWith(afterSalahAsr: value);
    await _updatePrayerNotifications();
  }

  Future<void> setAfterSalahAsrTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_afterSalahAsrHourKey, hour);
    await prefs.setInt(_afterSalahAsrMinKey, minute);
    state = state.copyWith(
      afterSalahAsrTime: ReminderTime(hour: hour, minute: minute),
      afterSalahAsr: true,
    );
    await _updatePrayerNotifications();
  }

  Future<void> toggleAfterSalahMaghrib(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_afterSalahMaghribKey, value);
    state = state.copyWith(afterSalahMaghrib: value);
    await _updatePrayerNotifications();
  }

  Future<void> setAfterSalahMaghribTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_afterSalahMaghribHourKey, hour);
    await prefs.setInt(_afterSalahMaghribMinKey, minute);
    state = state.copyWith(
      afterSalahMaghribTime: ReminderTime(hour: hour, minute: minute),
      afterSalahMaghrib: true,
    );
    await _updatePrayerNotifications();
  }

  Future<void> toggleAfterSalahIsha(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_afterSalahIshaKey, value);
    state = state.copyWith(afterSalahIsha: value);
    await _updatePrayerNotifications();
  }

  Future<void> setAfterSalahIshaTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_afterSalahIshaHourKey, hour);
    await prefs.setInt(_afterSalahIshaMinKey, minute);
    state = state.copyWith(
      afterSalahIshaTime: ReminderTime(hour: hour, minute: minute),
      afterSalahIsha: true,
    );
    await _updatePrayerNotifications();
  }

  // ── Scheduling Helpers ───────────────────────────────────────────────────

  Future<void> _updatePrayerNotifications() async {
    if (!state.notificationPermissionGranted) return;

    // Fajr
    if (state.afterSalahReminder && state.afterSalahFajr) {
      await _notificationService.scheduleDailyNotification(
        id: 201,
        title: 'After Fajr Dhikr',
        body: 'Start your morning with peaceful dhikr.',
        hour: state.afterSalahFajrTime.hour,
        minute: state.afterSalahFajrTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(201);
    }

    // Dhuhr
    if (state.afterSalahReminder && state.afterSalahDhuhr) {
      await _notificationService.scheduleDailyNotification(
        id: 202,
        title: 'After Dhuhr Dhikr',
        body: 'Pause for a moment of remembrance.',
        hour: state.afterSalahDhuhrTime.hour,
        minute: state.afterSalahDhuhrTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(202);
    }

    // Asr
    if (state.afterSalahReminder && state.afterSalahAsr) {
      await _notificationService.scheduleDailyNotification(
        id: 203,
        title: 'After Asr Dhikr',
        body: 'Fill your afternoon with gratitude.',
        hour: state.afterSalahAsrTime.hour,
        minute: state.afterSalahAsrTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(203);
    }

    // Maghrib
    if (state.afterSalahReminder && state.afterSalahMaghrib) {
      await _notificationService.scheduleDailyNotification(
        id: 204,
        title: 'After Maghrib Dhikr',
        body: 'A serene moment after sunset.',
        hour: state.afterSalahMaghribTime.hour,
        minute: state.afterSalahMaghribTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(204);
    }

    // Isha
    if (state.afterSalahReminder && state.afterSalahIsha) {
      await _notificationService.scheduleDailyNotification(
        id: 205,
        title: 'After Isha Dhikr',
        body: 'End your day in remembrance.',
        hour: state.afterSalahIshaTime.hour,
        minute: state.afterSalahIshaTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(205);
    }
  }

  Future<void> _updateSayingNotifications() async {
    // Clear old ones (IDs 301 to 310)
    for (int i = 1; i <= 10; i++) {
      await _notificationService.cancelNotification(300 + i);
    }

    if (!state.notificationPermissionGranted || !state.sayingReminders) return;

    // Schedule N sayings spread between 09:00 and 21:00
    final int count = state.sayingsPerDay;
    if (count <= 0) return;

    final startHour = 9;
    final totalMinutes = 12 * 60; // 12 hours window
    final interval = totalMinutes ~/ count;

    for (int i = 0; i < count; i++) {
      final scheduledMinutes = (i * interval) + (interval ~/ 2);
      final hour = startHour + (scheduledMinutes ~/ 60);
      final minute = scheduledMinutes % 60;
      
      final hadith = hadiths[i % hadiths.length];

      await _notificationService.scheduleDailyNotification(
        id: 301 + i,
        title: "Prophet's Saying",
        body: hadith.content,
        hour: hour,
        minute: minute,
      );
    }
  }

  Future<void> setLastDhikrId(String dhikrId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDhikrIdKey, dhikrId);
    state = state.copyWith(lastDhikrId: dhikrId);
  }
}
