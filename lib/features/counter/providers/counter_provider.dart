import 'package:collection/collection.dart';
import 'package:easy_tasbeeh/core/models/counter_models.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/dao/count_history_dao.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentCountStreamProvider = StreamProvider<CounterSession?>((ref) {
  final settings = ref.watch(settingsProvider);
  final sessionId = settings.activeComboIndex >= 0
      ? sessionIdCombo
      : sessionIdSingle;
  return ref.watch(countRepositoryProvider).watchCountById(sessionId);
});

final sessionStreamProvider = StreamProvider.family<CounterSession?, int>((
  ref,
  id,
) {
  return ref.watch(countRepositoryProvider).watchCountById(id);
});

final canRestoreProvider = StreamProvider<bool>((ref) {
  return ref.watch(countHistoryDaoProvider).watchAllHistory().map((history) {
    if (history.isEmpty) return false;
    final now = DateTime.now();
    return history.any((h) {
      if (h.isRestorable != true) return false;

      final date = h.createdAt.toLocal();
      final isToday =
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
      if (!isToday) return false;

      final isZero = h.currentCount <= 0;
      if (isZero) return false;

      final isCompleted = h.targetCount > 0 && h.currentCount >= h.targetCount;
      if (isCompleted) return false;

      return true;
    });
  });
});

final counterProvider =
    NotifierProvider<CounterNotifier, AsyncValue<CounterSession?>>(() {
      return CounterNotifier();
    });

class CounterNotifier extends Notifier<AsyncValue<CounterSession?>> {
  @override
  AsyncValue<CounterSession?> build() {
    return ref.watch(currentCountStreamProvider);
  }

  Future<CounterSession?> increment() async {
    final repo = ref.read(countRepositoryProvider);

    // Atomic increment returns the updated state
    final updatedSession = await repo.increment();

    final isTargetReached =
        updatedSession.targetCount > 0 &&
        updatedSession.currentCount >= updatedSession.targetCount;

    if (isTargetReached) {
      await repo.saveAndReset();
    }

    return updatedSession;
  }

  Future<void> reset({int? sessionId}) async {
    await ref.read(countRepositoryProvider).reset(sessionId: sessionId);
  }

  Future<void> saveAndReset({bool isRestorable = true, int? sessionId}) async {
    await ref
        .read(countRepositoryProvider)
        .saveAndReset(isRestorable: isRestorable, sessionId: sessionId);
  }

  Future<void> setTarget(int target, {int? sessionId}) async {
    await ref
        .read(countRepositoryProvider)
        .setTarget(target, sessionId: sessionId);
  }

  Future<void> setDhikrId(String dhikrId, {int? sessionId}) async {
    await ref
        .read(countRepositoryProvider)
        .setDhikrId(dhikrId, sessionId: sessionId);
  }

  Future<bool> restoreLastSession() async {
    final repo = ref.read(countRepositoryProvider);
    final history = await ref
        .read(countHistoryDaoProvider)
        .watchAllHistory()
        .first;
    if (history.isEmpty) return false;

    // We need to know which mode to switch to BEFORE restoring
    final now = DateTime.now();
    final last = history.firstWhereOrNull((h) {
      if (h.isRestorable != true) return false;
      final date = h.createdAt.toLocal();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day &&
          h.currentCount > 0 &&
          (h.targetCount == 0 || h.currentCount < h.targetCount);
    });

    if (last == null) return false;

    // Switch mode if needed
    final isCombo = last.sessionMode == 'combo';
    final targetIndex = isCombo ? (last.comboIndex ?? 0) : -1;

    // Update settings without triggering a full saveAndReset (which would archive current 0 count)
    // Actually, setActiveComboIndex handles it.
    await ref
        .read(settingsProvider.notifier)
        .setActiveComboIndex(targetIndex, isRestoring: true);

    return await repo.restoreLastSession();
  }
}
