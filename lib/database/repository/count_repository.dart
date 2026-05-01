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
  return ref.watch(countRepositoryProvider).watchCurrentCount();
});

final singleCountStreamProvider = StreamProvider<CurrentCountTableData?>((ref) {
  return ref.watch(countRepositoryProvider).watchCountById(SESSION_ID_SINGLE);
});

final comboCountStreamProvider = StreamProvider<CurrentCountTableData?>((ref) {
  return ref.watch(countRepositoryProvider).watchCountById(SESSION_ID_COMBO);
});

const int SESSION_ID_SINGLE = 1;
const int SESSION_ID_COMBO = 2;

class CountRepository {
  final Ref _ref;
  final CurrentCountDao _currentCountDao;
  final CountHistoryDao _countHistoryDao;

  CountRepository(this._ref, this._currentCountDao, this._countHistoryDao);

  // Get or initialize the current count session based on the active mode
  Future<CurrentCountTableData> getOrCreateCurrentCount() async {
    final settings = _ref.read(settingsProvider);
    final isCombo = settings.activeComboIndex >= 0;
    final sessionId = isCombo ? SESSION_ID_COMBO : SESSION_ID_SINGLE;

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
  Stream<CurrentCountTableData?> watchCurrentCount() {
    final settings = _ref.watch(settingsProvider);
    final sessionId = settings.activeComboIndex >= 0
        ? SESSION_ID_COMBO
        : SESSION_ID_SINGLE;

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

  // Reset the current counter and update the database
  Future<void> reset() async {
    final current = await getOrCreateCurrentCount();
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(current.id),
        currentCount: Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Save the current session to history and reset the current count
  Future<void> saveAndReset() async {
    final current = await getOrCreateCurrentCount();
    if (current.currentCount > 0) {
      final settings = _ref.read(settingsProvider);
      String? activeComboName;
      if (settings.activeComboIndex >= 0 &&
          settings.activeComboIndex < settings.comboPresets.length) {
        activeComboName = settings.comboPresets[settings.activeComboIndex].name;
      }

      final isCombo = settings.activeComboIndex >= 0;

      // Save to history
      await _countHistoryDao.insertHistory(
        CountHistoryTableCompanion(
          targetCount: Value(current.targetCount),
          currentCount: Value(current.currentCount),
          dhikrId: Value(current.dhikrId),
          comboName: Value(isCombo ? activeComboName : null),
          sessionMode: Value(isCombo ? 'combo' : 'single'),
          createdAt: Value(DateTime.now()),
        ),
      );
      // Reset current
      await reset();
      
      // Reset restore lock
      _hasRestoredThisSession = false;
    }
  }

  // Set a target count for the current session
  Future<void> setTarget(int target) async {
    final current = await getOrCreateCurrentCount();
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(current.id),
        targetCount: Value(target),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Set current dhikr ID
  Future<void> setDhikrId(String dhikrId) async {
    final current = await getOrCreateCurrentCount();
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(current.id),
        dhikrId: Value(dhikrId),
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

    final last = history.first;
    final now = DateTime.now();
    final isToday =
        last.createdAt.year == now.year &&
        last.createdAt.month == now.month &&
        last.createdAt.day == now.day;

    // Check if the last session is from today, has progress, and was NOT completed
    // A session is completed if targetCount > 0 and currentCount >= targetCount
    final isCompleted = last.targetCount > 0 && last.currentCount >= last.targetCount;
    final isRestorable = last.currentCount > 0 && !isCompleted;

    if (isToday && isRestorable) {
      // Determine which session record to restore into
      final restoredSessionId =
          last.sessionMode == 'combo' ? SESSION_ID_COMBO : SESSION_ID_SINGLE;

      // Reset both current progress records to ensure "delete current progress"
      // (Though we already checked current.currentCount == 0, this is for safety)
      await _currentCountDao.updateCount(
        const CurrentCountTableCompanion(
          id: Value(SESSION_ID_SINGLE),
          currentCount: Value(0),
          comboName: Value(null),
          sessionMode: Value('single'),
        ),
      );
      await _currentCountDao.updateCount(
        const CurrentCountTableCompanion(
          id: Value(SESSION_ID_COMBO),
          currentCount: Value(0),
          comboName: Value(null),
          sessionMode: Value('combo'),
        ),
      );

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
            .setActiveComboIndex(comboIndex);
      } else {
        await _ref.read(settingsProvider.notifier).setActiveComboIndex(-1);
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

    if (id == SESSION_ID_COMBO && comboName != null) {
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
