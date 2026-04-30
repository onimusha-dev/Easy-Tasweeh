import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_tasbeeh/database/repository/count_repository.dart';

final currentDhikrProvider = Provider<DhikrItem>((ref) {
  final settings = ref.watch(settingsProvider);
  final countData = ref.watch(currentCountStreamProvider).value;

  if (settings.activeComboIndex >= 0 &&
      settings.activeComboIndex < settings.comboPresets.length &&
      countData != null) {
    final current = countData.currentCount;
    final preset = settings.comboPresets[settings.activeComboIndex];
    final counts = preset.counts;
    
    int cumulative = 0;
    int index = -1;
    for (int i = 0; i < counts.length; i++) {
      cumulative += counts[i];
      if (current < cumulative) {
        index = i;
        break;
      }
    }

    if (index == -1 && counts.isNotEmpty) {
      index = counts.length - 1;
    }

    if (index >= 0 && index < preset.dhikrIds.length) {
      final dhikrId = preset.dhikrIds[index];
      return dhikrList.firstWhere(
        (d) => d.id == dhikrId,
        orElse: () => dhikrList.first,
      );
    }
  }

  final lastDhikrId = settings.lastDhikrId;
  return dhikrList.firstWhere(
    (d) => d.id == lastDhikrId,
    orElse: () => dhikrList.first,
  );
});
