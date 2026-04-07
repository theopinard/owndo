import 'package:drift/drift.dart';

// entity_type values: 'task', 'project'
// operation values: 'create', 'update', 'delete'
class PendingChangesTable extends Table {
  @override
  String get tableName => 'pending_changes';

  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {entityType, entityId},
      ];
}
