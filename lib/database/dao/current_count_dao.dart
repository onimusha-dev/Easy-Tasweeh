import 'package:drift/drift.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:easy_tasbeeh/database/tables/current_count_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_count_dao.g.dart';

@riverpod
CurrentCountDao currentCountDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CurrentCountDao(db);
}

@DriftAccessor(tables: [CurrentCountTable])
class CurrentCountDao extends DatabaseAccessor<AppDatabase> with _$CurrentCountDaoMixin {
  CurrentCountDao(super.attachedDatabase);

  // Return all current counts, though there should probably only be one or per session.
  Future<List<CurrentCountTableData>> getAllCounts() {
    return (select(currentCountTable).get());
  }

  // Watch current count progress by ID
  Stream<CurrentCountTableData?> watchCountById(int id) {
    return (select(currentCountTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  // Insert or initialize count
  Future<int> insertCount(CurrentCountTableCompanion count) {
    return (into(currentCountTable).insert(count));
  }

  // Update specific count
  Future<int> updateCount(CurrentCountTableCompanion count) {
    return (update(currentCountTable)..where((t) => t.id.equals(count.id.value))).write(count);
  }

  // Delete everything to reset completely
  Future<int> deleteAll() {
    return (delete(currentCountTable)).go();
  }
}