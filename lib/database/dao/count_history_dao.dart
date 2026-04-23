import 'package:drift/drift.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:easy_tasbeeh/database/tables/count_history.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_history_dao.g.dart';

@riverpod
CountHistoryDao countHistoryDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CountHistoryDao(db);
}

@DriftAccessor(tables: [CountHistoryTable])
class CountHistoryDao extends DatabaseAccessor<AppDatabase> with _$CountHistoryDaoMixin {
  CountHistoryDao(super.attachedDatabase);

  // Return all history
  Stream<List<CountHistoryTableData>> watchAllHistory() {
    return (select(countHistoryTable)..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])).watch();
  }

  // Insert a record into history
  Future<int> insertHistory(CountHistoryTableCompanion history) {
    return (into(countHistoryTable).insert(history));
  }

  // Delete everything
  Future<int> deleteAll() {
    return (delete(countHistoryTable)).go();
  }

  // Delete a specific record
  Future<int> deleteById(int id) {
    return (delete(countHistoryTable)..where((t) => t.id.equals(id))).go();
  }
}
