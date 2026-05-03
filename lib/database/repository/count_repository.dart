import 'package:drift/drift.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/dao/count_history_dao.dart';
import 'package:easy_tasbeeh/database/dao/current_count_dao.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_repository.g.dart';

@Riverpod(keepAlive: true)
CountRepository countRepository(Ref ref) {
  final currentCountDao = ref.watch(currentCountDaoProvider);
  final countHistoryDao = ref.watch(countHistoryDaoProvider);
  return CountRepository(ref, currentCountDao, countHistoryDao);
}

final currentCountStreamProvider = StreamProvider<CurrentCountTableData?>((
  ref,
) {
  final settings = ref.watch(settingsProvider);
  final sessionId = settings.activeComboIndex >= 0
      ? sessionIdCombo
      : sessionIdSingle;
  return ref.watch(countRepositoryProvider).watchCountById(sessionId);
});

final singleCountStreamProvider = StreamProvider<CurrentCountTableData?>((ref) {
  return ref.watch(countRepositoryProvider).watchCountById(sessionIdSingle);
});

final comboCountStreamProvider = StreamProvider<CurrentCountTableData?>((ref) {
  return ref.watch(countRepositoryProvider).watchCountById(sessionIdCombo);
});

const int sessionIdSingle = 1;
const int sessionIdCombo = 2;

class CountRepository {
  final Ref _ref;
  final CurrentCountDao _currentCountDao;
  final CountHistoryDao _countHistoryDao;

  CountRepository(this._ref, this._currentCountDao, this._countHistoryDao);

  // Get or initialize the current count session based on the active mode
  Future<CurrentCountTableData> getOrCreateCurrentCount() async {
    final settings = _ref.read(settingsProvider);
    final isCombo = settings.activeComboIndex >= 0;
    final sessionId = isCombo ? sessionIdCombo : sessionIdSingle;

    final counts = await _currentCountDao.getAllCounts();
    final session = counts.firstWhere(
      (c) => c.id == sessionId,
      orElse: () => CurrentCountTableData(
        id: sessionId,
        targetCount: isCombo ? 99 : 33, // Default targets for combo/single
        currentCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dhikrId: 'subhanallah',
        comboName: isCombo
            ? settings.comboPresets[settings.activeComboIndex].name
            : null,
        sessionMode: isCombo ? 'combo' : 'single',
      ),
    );

    // If session doesn't exist in DB, insert it
    if (!counts.any((c) => c.id == sessionId)) {
      await _currentCountDao.insertCount(
        CurrentCountTableCompanion(
          id: Value(sessionId),
          targetCount: Value(session.targetCount),
          currentCount: Value(0),
          dhikrId: Value(session.dhikrId),
          comboName: Value(session.comboName),
          sessionMode: Value(session.sessionMode),
        ),
      );
    }

    return session;
  }

  // Watch the current count for reactive UI, respecting the active mode
  Stream<CurrentCountTableData?> watchCurrentCount(int sessionId) {
    return _currentCountDao.watchCountById(sessionId);
  }

  // Increment the counter and update the database
  Future<void> increment() async {
    final current = await getOrCreateCurrentCount();
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(current.id),
        currentCount: Value(current.currentCount + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Save the current progress to history and reset the counter for a specific session
  Future<void> saveAndReset({bool isRestorable = true, int? sessionId}) async {
    final current = sessionId != null
        ? (await _currentCountDao.getAllCounts()).firstWhere(
            (c) => c.id == sessionId,
            orElse: () => throw Exception('Session $sessionId not found'),
          )
        : await getOrCreateCurrentCount();

    if (current.currentCount > 0) {
      final isCombo = current.id == sessionIdCombo;
      final settings = _ref.read(settingsProvider);

      int? comboIndex;
      if (isCombo) {
        comboIndex = settings.activeComboIndex;
      }

      await _countHistoryDao.insertHistory(
        CountHistoryTableCompanion(
          dhikrId: Value(current.dhikrId),
          targetCount: Value(current.targetCount),
          currentCount: Value(current.currentCount),
          createdAt: Value(DateTime.now()),
          sessionMode: Value(isCombo ? 'combo' : 'single'),
          isRestorable: Value(isRestorable),
          comboIndex: Value(comboIndex),
        ),
      );

      // Reset the current count in DB
      await reset(sessionId: current.id);
    } else {
      // Even if count is 0, we might want to reset the session state
      await reset(sessionId: current.id);
    }
  }

  // Reset progress for a specific session
  Future<void> reset({int? sessionId}) async {
    final finalSessionId = sessionId ?? (await getOrCreateCurrentCount()).id;
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(finalSessionId),
        currentCount: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Update target goal for a specific session
  Future<void> setTarget(int target, {int? sessionId}) async {
    final finalSessionId = sessionId ?? (await getOrCreateCurrentCount()).id;
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(finalSessionId),
        targetCount: Value(target),
        currentCount: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Update Dhikr ID for a specific session
  Future<void> setDhikrId(String dhikrId, {int? sessionId}) async {
    final finalSessionId = sessionId ?? (await getOrCreateCurrentCount()).id;
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(finalSessionId),
        dhikrId: Value(dhikrId),
        currentCount: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Watch all history records
  Stream<List<CountHistoryTableData>> watchAllHistory() {
    return _countHistoryDao.watchAllHistory();
  }

  // Watch current count progress by ID
  Stream<CurrentCountTableData?> watchCountById(int id) {
    return _currentCountDao.watchCountById(id);
  }

  bool _hasRestoredThisSession = false;

  // Restore the last incomplete session from history (only if it was from today)
  Future<bool> restoreLastSession() async {
    // Prevent multiple restores in a row to protect history
    if (_hasRestoredThisSession) return false;

    // Only allow restore if current session has no progress
    final current = await getOrCreateCurrentCount();
    if (current.currentCount > 0) return false;

    final history = await _countHistoryDao.watchAllHistory().first;
    if (history.isEmpty) return false;

    // Only allow restoration of the absolute latest session in history
    final last = history.first;
    if (!last.isRestorable) return false;

    final now = DateTime.now();
    final isToday =
        last.createdAt.year == now.year &&
        last.createdAt.month == now.month &&
        last.createdAt.day == now.day;

    // Check if the last session is from today, has progress, and was NOT completed
    // A session is completed if targetCount > 0 and currentCount >= targetCount
    final isCompleted =
        last.targetCount > 0 && last.currentCount >= last.targetCount;
    final isRestorable = last.currentCount > 0 && !isCompleted;

    if (isToday && isRestorable) {
      // Determine which session record to restore into
      final restoredSessionId = last.sessionMode == 'combo'
          ? sessionIdCombo
          : sessionIdSingle;

      // Restore the last session data into the correct record
      await _currentCountDao.updateCount(
        CurrentCountTableCompanion(
          id: Value(restoredSessionId),
          targetCount: Value(last.targetCount),
          currentCount: Value(last.currentCount),
          dhikrId: Value(last.dhikrId),
          comboName: Value(last.comboName),
          sessionMode: Value(last.sessionMode),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // Sync settings with the restored session
      await _ref.read(settingsProvider.notifier).setLastDhikrId(last.dhikrId);

      if (last.sessionMode == 'combo' && last.comboName != null) {
        final settings = _ref.read(settingsProvider);
        final comboIndex = settings.comboPresets.indexWhere(
          (p) => p.name == last.comboName,
        );
        // If combo still exists, switch to it, otherwise default to Single mode
        await _ref
            .read(settingsProvider.notifier)
            .setActiveComboIndex(comboIndex, isRestoring: true);
      } else {
        await _ref
            .read(settingsProvider.notifier)
            .setActiveComboIndex(-1, isRestoring: true);
      }

      // Remove from history
      await _countHistoryDao.deleteById(last.id);

      // Lock restoration until next save
      _hasRestoredThisSession = true;
      return true;
    }
    return false;
  }
}

extension CountProgressExtension on CurrentCountTableData {
  double calculateProgress(DhikrSettings settings) {
    if (targetCount <= 0) return 0.0;

    if (id == sessionIdCombo && comboName != null) {
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
