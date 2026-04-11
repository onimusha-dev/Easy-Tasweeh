import 'package:drift/drift.dart';
import 'package:easy_tasweeh/database/dao/count_history_dao.dart';
import 'package:easy_tasweeh/database/dao/current_count_dao.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_repository.g.dart';

@Riverpod(keepAlive: true)
CountRepository countRepository(Ref ref) {
  final currentCountDao = ref.watch(currentCountDaoProvider);
  final countHistoryDao = ref.watch(countHistoryDaoProvider);
  return CountRepository(currentCountDao, countHistoryDao);
}

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
          targetCount: Value(0),
          currentCount: Value(0),
        ),
      );
      final newCounts = await _currentCountDao.getAllCounts();
      return newCounts.first;
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
}
