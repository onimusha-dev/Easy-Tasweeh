import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_tasbeeh/database/repository/count_repository.dart';

final currentDhikrProvider = Provider<DhikrItem>((ref) {
  final settings = ref.watch(settingsProvider);
  final countData = ref.watch(currentCountStreamProvider).value;

  if (settings.activeComboIndex >= 0 &&
      settings.activeComboIndex < settings.comboPresets.length &&
      countData != null &&
      countData.targetCount > 0) {
    final current = countData.currentCount;
    final preset = settings.comboPresets[settings.activeComboIndex];
    final counts = preset.counts;
    
    if (counts.length >= 3) {
      final total1 = counts[0];
      final total2 = total1 + counts[1];

      int index = 0;
      if (current < total1) {
        index = 0;
      } else if (current < total2) {
        index = 1;
      } else {
        index = 2;
      }

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
