import 'package:drift/drift.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:easy_tasbeeh/database/tables/combo_presets_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'combo_presets_dao.g.dart';

@riverpod
ComboPresetsDao comboPresetsDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ComboPresetsDao(db);
}

@DriftAccessor(tables: [ComboPresetsTable])
class ComboPresetsDao extends DatabaseAccessor<AppDatabase> with _$ComboPresetsDaoMixin {
  ComboPresetsDao(super.attachedDatabase);

  Future<List<ComboPresetsTableData>> getAllPresets() =>
      (select(comboPresetsTable)..orderBy([(t) => OrderingTerm(expression: t.position)])).get();

  Stream<List<ComboPresetsTableData>> watchAllPresets() =>
      (select(comboPresetsTable)..orderBy([(t) => OrderingTerm(expression: t.position)])).watch();

  Future<int> insertPreset(ComboPresetsTableCompanion preset) =>
      into(comboPresetsTable).insertOnConflictUpdate(preset);

  Future<int> deletePreset(String id) =>
      (delete(comboPresetsTable)..where((t) => t.id.equals(id))).go();

  Future<void> updatePresetsPositions(List<ComboPresetsTableData> presets) async {
    await batch((batch) {
      for (int i = 0; i < presets.length; i++) {
        batch.update(
          comboPresetsTable,
          ComboPresetsTableCompanion(position: Value(i)),
          where: (t) => t.id.equals(presets[i].id),
        );
      }
    });
  }
}
