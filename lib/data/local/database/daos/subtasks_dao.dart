import 'package:drift/drift.dart';
import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/data/local/database/tables/subtasks_table.dart';
import 'package:owndo/data/local/database/tables/pending_changes_table.dart';

part 'subtasks_dao.g.dart';

@DriftAccessor(tables: [SubtasksTable, PendingChangesTable])
class SubtasksDao extends DatabaseAccessor<AppDatabase>
    with _$SubtasksDaoMixin {
  SubtasksDao(super.db);

  Stream<List<SubtasksTableData>> watchSubtasksByTask(String taskId) {
    return (select(subtasksTable)
          ..where((s) => s.taskId.equals(taskId) & s.deleted.equals(false))
          ..orderBy([(s) => OrderingTerm.asc(s.createdAt)]))
        .watch();
  }

  /// Returns all subtasks for a task (including deleted) — used by the push phase
  /// to embed the full subtask list in the parent task's JSON.
  Future<List<SubtasksTableData>> getSubtasksByTask(String taskId) {
    return (select(subtasksTable)
          ..where((s) => s.taskId.equals(taskId)))
        .get();
  }

  /// Upsert a subtask and record a pending change on the parent task atomically.
  Future<void> upsertSubtaskWithParentPendingChange(
    SubtasksTableData subtask,
    PendingChangesTableCompanion parentChange,
  ) async {
    await transaction(() async {
      await into(subtasksTable).insertOnConflictUpdate(subtask);
      await into(pendingChangesTable)
          .insert(parentChange, mode: InsertMode.insertOrReplace);
    });
  }

  /// Upsert a subtask received from sync. Does NOT touch pending_changes.
  Future<void> upsertFromSync(SubtasksTableData subtask) async {
    await into(subtasksTable).insertOnConflictUpdate(subtask);
  }
}
