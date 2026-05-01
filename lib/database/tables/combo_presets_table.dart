import 'package:drift/drift.dart';

class ComboPresetsTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  TextColumn get dhikrIds => text()(); // JSON string of List<String>
  TextColumn get counts => text()(); // JSON string of List<int>
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
