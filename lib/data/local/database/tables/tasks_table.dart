import 'package:drift/drift.dart';

class TasksTable extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get projectId => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  IntColumn get deadline => integer().nullable()();
  IntColumn get reminderAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
