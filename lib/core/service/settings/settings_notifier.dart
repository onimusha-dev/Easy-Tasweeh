import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/database/dao/combo_presets_dao.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import '../../../database/repository/count_repository.dart';
import '../settings_provider.dart';
import 'settings_service.dart';

class SettingsNotifier extends Notifier<SettingsState> {
  SettingsService get _service => ref.read(settingsServiceProvider);
  ComboPresetsDao get _presetsDao => ref.read(comboPresetsDaoProvider);

  @override
  SettingsState build() {
    // Automatically load settings when the provider is initialized
    final service = ref.watch(settingsServiceProvider);

    // Use a microtask to refresh permission status and sync presets after build
    Future.microtask(() {
      refreshPermissionStatus();
      _syncPresetsFromDb();
    });

    return service.loadSettings();
  }

  Future<void> refreshPermissionStatus() async {
    final status = await Permission.notification.status;

    // On Android 13+, we need both notification and (often) exact alarm permissions.
    // If exactStatus is denied, it might still show notifications but they won't be exact.
    // We consider it "granted" only if notification permission is granted.
    state = state.copyWith(notificationPermissionGranted: status.isGranted);
  }

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();

    // Also request exact alarm permission if needed
    if (status.isGranted) {
      final exactStatus = await Permission.scheduleExactAlarm.status;
      if (exactStatus.isDenied || exactStatus.isPermanentlyDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }

    final finalStatus = await Permission.notification.status;
    final granted = finalStatus.isGranted;
    state = state.copyWith(notificationPermissionGranted: granted);
    return granted;
  }

  // --- Feedback ---
  Future<void> toggleHaptic(bool value) async {
    await _service.setBool('hapticEnabled', value);
    state = state.copyWith(
      feedback: state.feedback.copyWith(hapticEnabled: value),
    );
  }

  Future<void> toggleTapSound(bool value) async {
    await _service.setBool('tapSound', value);
    state = state.copyWith(feedback: state.feedback.copyWith(tapSound: value));
  }

  Future<void> toggleGoalReachedSound(bool value) async {
    await _service.setBool('goalReachedSound', value);
    state = state.copyWith(
      feedback: state.feedback.copyWith(goalReachedSound: value),
    );
  }

  Future<void> toggleGoalHapticPattern(bool value) async {
    await _service.setBool('goalHapticPattern', value);
    state = state.copyWith(
      feedback: state.feedback.copyWith(goalHapticPattern: value),
    );
  }

  Future<void> toggleVibrateOnMilestone(bool value) async {
    await _service.setBool('vibrateOnMilestone', value);
    state = state.copyWith(
      feedback: state.feedback.copyWith(vibrateOnMilestone: value),
    );
  }

  Future<void> setMilestoneValue(int value) async {
    await _service.setInt('milestoneValue', value);
    state = state.copyWith(
      feedback: state.feedback.copyWith(milestoneValue: value),
    );
  }

  Future<void> toggleShowParticles(bool value) async {
    await _service.setBool('showParticles', value);
    state = state.copyWith(
      feedback: state.feedback.copyWith(showParticles: value),
    );
  }

  Future<void> toggleSound(bool value) async {
    await _service.setBool('soundEnabled', value);
    state = state.copyWith(
      feedback: state.feedback.copyWith(soundEnabled: value),
    );
  }

  Future<void> setVolume(double value) async {
    await _service.setDouble('volume', value);
    state = state.copyWith(feedback: state.feedback.copyWith(volume: value));
  }

  Future<void> setHapticIntensity(double value) async {
    await _service.setDouble('hapticIntensity', value);
    state = state.copyWith(
      feedback: state.feedback.copyWith(hapticIntensity: value),
    );
  }

  // --- Appearance ---
  Future<void> setThemeMode(ThemeMode mode) async {
    await _service.setString('themeMode', mode.name);
    state = state.copyWith(
      appearance: state.appearance.copyWith(themeMode: mode),
    );
  }

  Future<void> setColorScheme(AppColorScheme scheme) async {
    await _service.setString('colorScheme', scheme.name);
    state = state.copyWith(
      appearance: state.appearance.copyWith(colorScheme: scheme),
    );
  }

  Future<void> setBackground(String path) async {
    await _service.setString('background', path);
    state = state.copyWith(
      appearance: state.appearance.copyWith(background: path),
    );
  }

  Future<void> setBackgroundOpacity(double value) async {
    await _service.setDouble('backgroundOpacity', value);
    state = state.copyWith(
      appearance: state.appearance.copyWith(backgroundOpacity: value),
    );
  }

  Future<void> setButtonStyle(PressButtonStyle style) async {
    await _service.setString('pressButtonStyle', style.name);
    state = state.copyWith(
      appearance: state.appearance.copyWith(pressButtonStyle: style),
    );
  }

  Future<void> setButtonSize(double value) async {
    await _service.setDouble('buttonSize', value);
    state = state.copyWith(
      appearance: state.appearance.copyWith(buttonSize: value),
    );
  }

  Future<void> toggleCenterButton(bool value) async {
    await _service.setBool('centerButton', value);
    state = state.copyWith(
      appearance: state.appearance.copyWith(centerButton: value),
    );
  }

  void updateCenterButtonTemporary(bool value) {
    state = state.copyWith(
      appearance: state.appearance.copyWith(centerButton: value),
    );
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
    state = state.copyWith(
      dhikr: state.dhikr.copyWith(tapFreezeEnabled: value),
    );
  }

  Future<void> setTapFreezeDuration(int value) async {
    await _service.setInt('tapFreezeDuration', value);
    state = state.copyWith(
      dhikr: state.dhikr.copyWith(tapFreezeDuration: value),
    );
  }

  Future<void> setActiveComboIndex(int index, {bool isRestoring = false}) async {
    // 1. Save outgoing session to history before switching (mark as non-restorable to ensure clean start)
    // Only if we are not in the middle of a restoration process
    if (!isRestoring) {
      await ref.read(countRepositoryProvider).saveAndReset(isRestorable: false);
    }

    // 2. Update active index
    await _service.setInt('activeComboIndex', index);
    state = state.copyWith(
      dhikr: state.dhikr.copyWith(
        activeComboIndex: index,
        comboEnabled: index >= 0,
      ),
    );

    if (!isRestoring) {
      // 3. Sync database target with combo total if active
      if (index >= 0 && index < state.dhikr.comboPresets.length) {
        final total = state.dhikr.comboPresets[index].counts.reduce(
          (a, b) => a + b,
        );
        await ref.read(countRepositoryProvider).setTarget(total);
      }

      // 4. Always reset the counter for the newly entered mode to ensure a clean start
      await ref.read(countRepositoryProvider).reset();
    }
  }

  Future<void> saveComboPreset(ComboPreset preset) async {
    final presets = List<ComboPreset>.from(state.dhikr.comboPresets);
    final index = presets.indexWhere((p) => p.id == preset.id);
    if (index >= 0) {
      presets[index] = preset;
    } else {
      presets.add(preset);
    }
    await _service.setStringList(
      'comboPresets',
      presets.map((e) => jsonEncode(e.toJson())).toList(),
    );

    // Sync with DB
    await _presetsDao.insertPreset(
      ComboPresetsTableCompanion(
        id: Value(preset.id),
        name: Value(preset.name),
        dhikrIds: Value(jsonEncode(preset.dhikrIds)),
        counts: Value(jsonEncode(preset.counts)),
      ),
    );

    state = state.copyWith(dhikr: state.dhikr.copyWith(comboPresets: presets));

    // If this was the active combo, update the target count
    if (state.dhikr.activeComboIndex == index ||
        (index == -1 && state.dhikr.activeComboIndex == presets.length - 1)) {
      final total = preset.counts.reduce((a, b) => a + b);
      await ref.read(countRepositoryProvider).setTarget(total);
    }
  }

  Future<void> deleteComboPreset(String id) async {
    final presets = List<ComboPreset>.from(state.dhikr.comboPresets)
      ..removeWhere((p) => p.id == id);
    await _service.setStringList(
      'comboPresets',
      presets.map((e) => jsonEncode(e.toJson())).toList(),
    );

    int newActiveIndex = state.dhikr.activeComboIndex;
    if (newActiveIndex >= presets.length) {
      newActiveIndex = presets.isEmpty ? -1 : presets.length - 1;
    }

    await _service.setInt('activeComboIndex', newActiveIndex);

    // Sync with DB
    await _presetsDao.deletePreset(id);

    state = state.copyWith(
      dhikr: state.dhikr.copyWith(
        comboPresets: presets,
        activeComboIndex: newActiveIndex,
        comboEnabled: newActiveIndex >= 0,
      ),
    );
  }

  Future<void> moveComboPresetUp(int index) async {
    if (index <= 0) return;
    await reorderPresets(index, index - 1);
  }

  Future<void> moveComboPresetDown(int index) async {
    if (index >= state.dhikr.comboPresets.length - 1) return;
    await reorderPresets(index, index + 1);
  }

  Future<void> reorderPresets(int oldIndex, int newIndex) async {
    final presets = List<ComboPreset>.from(state.dhikr.comboPresets);
    final item = presets.removeAt(oldIndex);
    presets.insert(newIndex, item);

    // Update SP
    await _service.setStringList(
      'comboPresets',
      presets.map((e) => jsonEncode(e.toJson())).toList(),
    );

    // Update DB
    final tableData = presets
        .map(
          (p) => ComboPresetsTableData(
            id: p.id,
            name: p.name,
            dhikrIds: jsonEncode(p.dhikrIds),
            counts: jsonEncode(p.counts),
            position: 0, // Will be set by updatePresetsPositions
            createdAt: DateTime.now(),
          ),
        )
        .toList();
    await _presetsDao.updatePresetsPositions(tableData);

    // If active index was affected, update it
    int activeIndex = state.dhikr.activeComboIndex;
    if (activeIndex == oldIndex) {
      activeIndex = newIndex;
    } else if (activeIndex == newIndex) {
      activeIndex = oldIndex;
    }
    await _service.setInt('activeComboIndex', activeIndex);

    state = state.copyWith(
      dhikr: state.dhikr.copyWith(
        comboPresets: presets,
        activeComboIndex: activeIndex,
      ),
    );
  }

  Future<void> _syncPresetsFromDb() async {
    final dbPresets = await _presetsDao.getAllPresets();
    final spPresets = state.dhikr.comboPresets;

    if (dbPresets.isEmpty && spPresets.isNotEmpty) {
      // First time migration: Push SP presets to DB
      for (final preset in spPresets) {
        await _presetsDao.insertPreset(
          ComboPresetsTableCompanion(
            id: Value(preset.id),
            name: Value(preset.name),
            dhikrIds: Value(jsonEncode(preset.dhikrIds)),
            counts: Value(jsonEncode(preset.counts)),
          ),
        );
      }
      return;
    }

    if (dbPresets.isNotEmpty) {
      // DB is source of truth: Sync to state and SP
      final presets = dbPresets
          .map(
            (d) => ComboPreset(
              id: d.id,
              name: d.name,
              dhikrIds: List<String>.from(jsonDecode(d.dhikrIds)),
              counts: List<int>.from(jsonDecode(d.counts)),
            ),
          )
          .toList();

      // Update state
      state = state.copyWith(
        dhikr: state.dhikr.copyWith(comboPresets: presets),
      );

      // Update SP
      await _service.setStringList(
        'comboPresets',
        presets.map((e) => jsonEncode(e.toJson())).toList(),
      );
    }
  }

  // --- Reminders ---
  Future<void> toggleMorningReminder(bool v) async {
    await _service.setBool('morningReminder', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(morningReminder: v),
    );
  }

  Future<void> setMorningTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('morningTime', jsonEncode(time.toJson()));
    state = state.copyWith(
      reminders: state.reminders.copyWith(morningTime: time),
    );
  }

  Future<void> toggleEveningReminder(bool v) async {
    await _service.setBool('eveningReminder', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(eveningReminder: v),
    );
  }

  Future<void> setEveningTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('eveningTime', jsonEncode(time.toJson()));
    state = state.copyWith(
      reminders: state.reminders.copyWith(eveningTime: time),
    );
  }

  Future<void> toggleSayingReminders(bool v) async {
    await _service.setBool('sayingReminders', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(sayingReminders: v),
    );
  }

  Future<void> setSayingsPerDay(int v) async {
    await _service.setInt('sayingsPerDay', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(sayingsPerDay: v),
    );
  }

  Future<void> toggleAfterSalahReminder(bool v) async {
    await _service.setBool('afterSalahReminder', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahReminder: v),
    );
  }

  Future<void> toggleAfterSalahFajr(bool v) async {
    await _service.setBool('afterSalahFajr', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahFajr: v),
    );
  }

  Future<void> setAfterSalahFajrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahFajrTime', jsonEncode(time.toJson()));
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahFajrTime: time),
    );
  }

  Future<void> toggleAfterSalahDhuhr(bool v) async {
    await _service.setBool('afterSalahDhuhr', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahDhuhr: v),
    );
  }

  Future<void> setAfterSalahDhuhrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahDhuhrTime', jsonEncode(time.toJson()));
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahDhuhrTime: time),
    );
  }

  Future<void> toggleAfterSalahAsr(bool v) async {
    await _service.setBool('afterSalahAsr', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahAsr: v),
    );
  }

  Future<void> setAfterSalahAsrTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahAsrTime', jsonEncode(time.toJson()));
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahAsrTime: time),
    );
  }

  Future<void> toggleAfterSalahMaghrib(bool v) async {
    await _service.setBool('afterSalahMaghrib', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahMaghrib: v),
    );
  }

  Future<void> setAfterSalahMaghribTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString(
      'afterSalahMaghribTime',
      jsonEncode(time.toJson()),
    );
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahMaghribTime: time),
    );
  }

  Future<void> toggleAfterSalahIsha(bool v) async {
    await _service.setBool('afterSalahIsha', v);
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahIsha: v),
    );
  }

  Future<void> setAfterSalahIshaTime(int h, int m) async {
    final time = ReminderTime(h, m);
    await _service.setString('afterSalahIshaTime', jsonEncode(time.toJson()));
    state = state.copyWith(
      reminders: state.reminders.copyWith(afterSalahIshaTime: time),
    );
  }

  // --- Backup ---
  Future<void> togglePeriodicBackup(bool v) async {
    await _service.setBool('periodicBackupEnabled', v);
    state = state.copyWith(
      backup: state.backup.copyWith(periodicBackupEnabled: v),
    );

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
    state = state.copyWith(
      backup: state.backup.copyWith(backupDirectory: path),
    );
  }

  Future<void> completeOnboarding() async {
    await _service.setBool('onboardingCompleted', true);
    state = state.copyWith(onboardingCompleted: true);
  }
}
