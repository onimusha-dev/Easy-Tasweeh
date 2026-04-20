import 'package:drift/drift.dart';
import 'package:easy_tasweeh/database/dao/count_history_dao.dart';
import 'package:easy_tasweeh/database/dao/current_count_dao.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_repository.g.dart';

@Riverpod(keepAlive: true)
CountRepository countRepository(Ref ref) {
  final currentCountDao = ref.watch(currentCountDaoProvider);
  final countHistoryDao = ref.watch(countHistoryDaoProvider);
  return CountRepository(currentCountDao, countHistoryDao);
}

final currentCountStreamProvider = StreamProvider<CurrentCountTableData?>((
  ref,
) {
  return ref.watch(countRepositoryProvider).watchCurrentCount();
});

class CountRepository {
  final CurrentCountDao _currentCountDao;
  final CountHistoryDao _countHistoryDao;

  CountRepository(this._currentCountDao, this._countHistoryDao);

  // Get or initialize the current count session
  Future<CurrentCountTableData> getOrCreateCurrentCount() async {
    final counts = await _currentCountDao.getAllCounts();
    if (counts.isEmpty) {
      await _currentCountDao.insertCount(
        const CurrentCountTableCompanion(
          targetCount: Value(33),
          currentCount: Value(0),
        ),
      );
      final newCounts = await _currentCountDao.getAllCounts();
      return newCounts.isNotEmpty
          ? newCounts.first
          : throw Exception('Failed to initialize count');
    }
    return counts.first;
  }

  // Watch the current count for reactive UI
  Stream<CurrentCountTableData?> watchCurrentCount() {
    return _currentCountDao.watchCurrentCount();
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
      // Save to history
      await _countHistoryDao.insertHistory(
        CountHistoryTableCompanion(
          targetCount: Value(current.targetCount),
          currentCount: Value(current.currentCount),
          dhikrId: Value(current.dhikrId),
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

    // Check if the session was incomplete and from today
    if (isToday &&
        last.targetCount > 0 &&
        last.currentCount < last.targetCount) {
      final current = await getOrCreateCurrentCount();
      await _currentCountDao.updateCount(
        CurrentCountTableCompanion(
          id: Value(current.id),
          targetCount: Value(last.targetCount),
          currentCount: Value(last.currentCount),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _countHistoryDao.deleteById(last.id);
      return true;
    }
    return false;
  }
}
