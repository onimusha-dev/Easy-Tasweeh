import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:easy_tasbeeh/database/dao/combo_presets_dao.dart';
import 'package:easy_tasbeeh/database/dao/count_history_dao.dart';
import 'package:easy_tasbeeh/database/dao/current_count_dao.dart';
import 'package:easy_tasbeeh/database/tables/combo_presets_table.dart';
import 'package:easy_tasbeeh/database/tables/count_history.dart';
import 'package:easy_tasbeeh/database/tables/current_count_table.dart';
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
  tables: [CurrentCountTable, CountHistoryTable, ComboPresetsTable],
  daos: [CurrentCountDao, CountHistoryDao, ComboPresetsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(currentCountTable, currentCountTable.dhikrId);
        await migrator.addColumn(countHistoryTable, countHistoryTable.dhikrId);
      }
      if (from < 3) {
        await migrator.addColumn(
          countHistoryTable,
          countHistoryTable.comboName,
        );
      }
      if (from < 4) {
        await migrator.addColumn(
          currentCountTable,
          currentCountTable.comboName,
        );
      }
      if (from < 5) {
        await migrator.addColumn(
          currentCountTable,
          currentCountTable.sessionMode,
        );
        await migrator.addColumn(
          countHistoryTable,
          countHistoryTable.sessionMode,
        );
        await migrator.createTable(comboPresetsTable);
      }
      if (from < 6) {
        await migrator.addColumn(comboPresetsTable, comboPresetsTable.position);
      }
      if (from < 7) {
        await migrator.addColumn(
          countHistoryTable,
          countHistoryTable.isRestorable,
        );
      }
      if (from < 8) {
        await migrator.addColumn(
          countHistoryTable,
          countHistoryTable.comboIndex,
        );
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'easy_tasbeeh_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
