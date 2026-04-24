import 'package:drift/drift.dart';

class CurrentCountTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get targetCount => integer().withDefault(const Constant(0))();

  IntColumn get currentCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get dhikrId => text().withDefault(const Constant('subhanallah'))();
}
