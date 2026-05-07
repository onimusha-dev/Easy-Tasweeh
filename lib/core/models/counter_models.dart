import 'package:easy_tasbeeh/core/service/settings/settings_state.dart';

class CounterSession {
  final int id;
  final int targetCount;
  final int currentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String dhikrId;
  final String? comboName;
  final String sessionMode; // 'single' or 'combo'

  CounterSession({
    required this.id,
    required this.targetCount,
    required this.currentCount,
    required this.createdAt,
    required this.updatedAt,
    required this.dhikrId,
    this.comboName,
    required this.sessionMode,
  });

  double calculateProgress(DhikrSettings settings) {
    if (targetCount <= 0) return 0.0;

    if (sessionMode == 'combo' && comboName != null) {
      final preset = settings.comboPresets.firstWhere(
        (p) => p.name == comboName,
        orElse: () => settings.comboPresets.isNotEmpty
            ? settings.comboPresets.first
            : const ComboPreset(id: '', name: '', dhikrIds: [], counts: []),
      );

      if (preset.counts.isEmpty) return 0.0;

      final counts = preset.counts;
      int cumulativeTarget = 0;
      int segmentTarget = 0;
      int segmentCurrent = 0;
      bool found = false;

      for (int i = 0; i < counts.length; i++) {
        int nextCumulative = cumulativeTarget + counts[i];
        if (currentCount < nextCumulative) {
          segmentTarget = counts[i];
          segmentCurrent = currentCount - cumulativeTarget;
          found = true;
          break;
        }
        cumulativeTarget = nextCumulative;
      }

      if (!found && counts.isNotEmpty) {
        segmentTarget = counts.last;
        segmentCurrent = counts.last;
      }

      return segmentTarget > 0
          ? (segmentCurrent / segmentTarget).clamp(0.0, 1.0)
          : 0.0;
    } else {
      return (currentCount / targetCount).clamp(0.0, 1.0);
    }
  }
}

class HistoryRecord {
  final int id;
  final String dhikrId;
  final int targetCount;
  final int currentCount;
  final DateTime createdAt;
  final String sessionMode;
  final bool isRestorable;
  final int? comboIndex;
  final String? comboName;

  HistoryRecord({
    required this.id,
    required this.dhikrId,
    required this.targetCount,
    required this.currentCount,
    required this.createdAt,
    required this.sessionMode,
    required this.isRestorable,
    this.comboIndex,
    this.comboName,
  });
}
