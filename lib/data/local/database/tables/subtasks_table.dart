import 'package:drift/drift.dart';

class SubtasksTable extends Table {
  @override
  String get tableName => 'subtasks';

  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get title => text()();
  IntColumn get currentStep => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
