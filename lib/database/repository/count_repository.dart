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

final singleCountStreamProvider = StreamProvider<CurrentCountTableData?>((
  ref,
) {
  return ref.watch(countRepositoryProvider).watchCountById(SESSION_ID_SINGLE);
});

final comboCountStreamProvider = StreamProvider<CurrentCountTableData?>((
  ref,
) {
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
        ),
      );
    }

    return session;
  }

  // Watch the current count for reactive UI, respecting the active mode
  Stream<CurrentCountTableData?> watchCurrentCount() {
    final settings = _ref.watch(settingsProvider);
    final sessionId =
        settings.activeComboIndex >= 0 ? SESSION_ID_COMBO : SESSION_ID_SINGLE;

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

      // Save to history
      await _countHistoryDao.insertHistory(
        CountHistoryTableCompanion(
          targetCount: Value(current.targetCount),
          currentCount: Value(current.currentCount),
          dhikrId: Value(current.dhikrId),
          comboName: Value(activeComboName),
          createdAt: Value(DateTime.now()),
        ),
      );
      // Reset current
      await reset();
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

  // Restore the last incomplete session from history (only if it was from today)
  Future<bool> restoreLastSession() async {
    final history = await _countHistoryDao.watchAllHistory().first;
    if (history.isEmpty) return false;

    final last = history.first;
    final now = DateTime.now();
    final isToday =
        last.createdAt.year == now.year &&
        last.createdAt.month == now.month &&
        last.createdAt.day == now.day;

    // Check if the session is from today
    if (isToday) {
      final current = await getOrCreateCurrentCount();
      await _currentCountDao.updateCount(
        CurrentCountTableCompanion(
          id: Value(current.id),
          targetCount: Value(last.targetCount),
          currentCount: Value(last.currentCount),
          dhikrId: Value(last.dhikrId),
          updatedAt: Value(DateTime.now()),
        ),
      );
      // Sync the restored dhikr with settings
      await _ref.read(settingsProvider.notifier).setLastDhikrId(last.dhikrId);
      await _countHistoryDao.deleteById(last.id);
      return true;
    }
    return false;
  }
}
