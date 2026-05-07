import 'dart:convert';

import 'package:easy_tasbeeh/features/counter/providers/counter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/repository/combo_repository.dart';
import '../../../../database/repository/count_repository.dart';
import '../settings_service.dart';
import '../settings_state.dart';

mixin DhikrSettingsMixin on Notifier<SettingsState> {
  SettingsService get _service => ref.read(settingsServiceProvider);
  ComboRepository get _comboRepository => ref.read(comboRepositoryProvider);

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

  Future<void> setActiveComboIndex(
    int index, {
    bool isRestoring = false,
  }) async {
    final oldActiveIndex = state.dhikr.activeComboIndex;
    if (oldActiveIndex == index) return;

    final newIsCombo = index >= 0;
    final newSessionId = newIsCombo ? sessionIdCombo : sessionIdSingle;
    final oldSessionId = (oldActiveIndex >= 0)
        ? sessionIdCombo
        : sessionIdSingle;

    if (!isRestoring) {
      // 1. Save the session we are leaving WHILE state is still old
      await ref
          .read(countRepositoryProvider)
          .saveAndReset(isRestorable: true, sessionId: oldSessionId);
    }

    // 2. Update the state
    await _service.setInt('activeComboIndex', index);
    state = state.copyWith(
      dhikr: state.dhikr.copyWith(
        activeComboIndex: index,
        comboEnabled: newIsCombo,
      ),
    );

    if (!isRestoring) {
      // 3. Prepare the session we are entering WHILE state is new
      if (newIsCombo && index < state.dhikr.comboPresets.length) {
        final total = state.dhikr.comboPresets[index].counts.reduce(
          (a, b) => a + b,
        );
        await ref
            .read(countRepositoryProvider)
            .setTarget(total, sessionId: newSessionId);
      }

      // If we are switching modes (Single <-> Combo), we need to ensure the new session is clean
      if (newSessionId != oldSessionId) {
        await ref.read(countRepositoryProvider).reset(sessionId: newSessionId);
      } else {
        // Even if session ID is same (Combo A -> Combo B), we already called saveAndReset
        // which reset it to 0. We just need to make sure getOrCreateCurrentCount syncs metadata.
        await ref
            .read(countRepositoryProvider)
            .getOrCreateCurrentCount(sessionId: newSessionId);
      }
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

    await _comboRepository.savePreset(preset);

    state = state.copyWith(dhikr: state.dhikr.copyWith(comboPresets: presets));

    if (state.dhikr.activeComboIndex == index ||
        (index == -1 && state.dhikr.activeComboIndex == presets.length - 1)) {
      final total = preset.counts.reduce((a, b) => a + b);
      await ref.read(counterProvider.notifier).setTarget(total);
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

    await _comboRepository.deletePreset(id);

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

    await _service.setStringList(
      'comboPresets',
      presets.map((e) => jsonEncode(e.toJson())).toList(),
    );

    await _comboRepository.updatePositions(presets);

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

  Future<void> syncPresetsFromDb() async {
    final dbPresets = await _comboRepository.getAllPresets();
    final spPresets = state.dhikr.comboPresets;

    if (dbPresets.isEmpty && spPresets.isNotEmpty) {
      for (final preset in spPresets) {
        await _comboRepository.savePreset(preset);
      }
      return;
    }

    if (dbPresets.isNotEmpty) {
      final presets = dbPresets;
      state = state.copyWith(
        dhikr: state.dhikr.copyWith(comboPresets: presets),
      );
      await _service.setStringList(
        'comboPresets',
        presets.map((e) => jsonEncode(e.toJson())).toList(),
      );
    }
  }
}
