import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:easy_tasweeh/database/dao/count_history_dao.dart';
import 'package:easy_tasweeh/database/dao/current_count_dao.dart';
import 'package:easy_tasweeh/database/tables/count_history.dart';
import 'package:easy_tasweeh/database/tables/current_count_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();

  ref.onDispose(() {
    db.close();
  });
  return db;
}

@DriftDatabase(
  tables: [CurrentCountTable, CountHistoryTable],
  daos: [CurrentCountDao, CountHistoryDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      // Handle migrations here as the app grows
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'easy_tasweeh_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}