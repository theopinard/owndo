import 'package:drift/drift.dart';
import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/data/local/database/tables/tasks_table.dart';
import 'package:owndo/data/local/database/tables/pending_changes_table.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [TasksTable, PendingChangesTable])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  // Watch all non-deleted inbox tasks (no project)
  Stream<List<TasksTableData>> watchInboxTasks() {
    return (select(tasksTable)
          ..where((t) => t.projectId.isNull() & t.deleted.equals(false)))
        .watch();
  }

  // Watch all non-deleted tasks for a given project
  Stream<List<TasksTableData>> watchTasksByProject(String projectId) {
    return (select(tasksTable)
          ..where(
            (t) => t.projectId.equals(projectId) & t.deleted.equals(false),
          ))
        .watch();
  }

  Future<TasksTableData?> getTaskById(String id) {
    return (select(tasksTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Upsert a task and record a pending change atomically.
  // Use this for all user-initiated writes.
  Future<void> upsertTaskWithPendingChange(
    TasksTableData row,
    PendingChangesTableCompanion change,
  ) async {
    await transaction(() async {
      await into(tasksTable).insertOnConflictUpdate(row);
      // INSERT OR REPLACE handles the unique(entity_type, entity_id) constraint:
      // if a pending change for this entity already exists, the old row is
      // deleted and replaced with the new one (last write wins).
      await into(pendingChangesTable)
          .insert(change, mode: InsertMode.insertOrReplace);
    });
  }

  // Upsert a task received from sync. Does NOT touch pending_changes.
  Future<void> upsertFromSync(TasksTableData row) async {
    await into(tasksTable).insertOnConflictUpdate(row);
  }
}
