import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/application/providers/database_provider.dart';
import 'package:owndo/core/utils/uuid_factory.dart';
import 'package:owndo/core/constants.dart';
import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/data/local/mappers/subtask_mapper.dart';
import 'package:owndo/domain/entities/subtask.dart';

part 'subtask_providers.g.dart';

@riverpod
class SubtaskListNotifier extends _$SubtaskListNotifier {
  @override
  Stream<List<Subtask>> build(String taskId) {
    final db = ref.watch(appDatabaseProvider);
    return db.subtasksDao
        .watchSubtasksByTask(taskId)
        .map((rows) => rows.map(SubtaskMapper.fromRow).toList());
  }

  Future<void> addSubtask(String title) async {
    final subtask = Subtask.create(taskId: taskId, title: title.trim());
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await db.subtasksDao.upsertSubtaskWithParentPendingChange(
      SubtaskMapper.toRow(subtask),
      _parentPendingChange(taskId, now),
    );
  }

  Future<void> toggleComplete(Subtask subtask) async {
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await db.subtasksDao.upsertSubtaskWithParentPendingChange(
      SubtaskMapper.toRow(
        subtask.copyWith(completed: !subtask.completed, updatedAt: now),
      ),
      _parentPendingChange(subtask.taskId, now),
    );
  }

  Future<void> deleteSubtask(Subtask subtask) async {
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await db.subtasksDao.upsertSubtaskWithParentPendingChange(
      SubtaskMapper.toRow(subtask.copyWith(deleted: true, updatedAt: now)),
      _parentPendingChange(subtask.taskId, now),
    );
  }

  // Records a pending change on the parent task so its JSON (with subtasks)
  // gets re-uploaded to Dropbox on the next push phase.
  static PendingChangesTableCompanion _parentPendingChange(
    String taskId,
    int now,
  ) {
    return PendingChangesTableCompanion(
      id: Value(UuidFactory.generate()),
      entityType: const Value(AppConstants.entityTypeTask),
      entityId: Value(taskId),
      operation: const Value('upsert'),
      updatedAt: Value(now),
    );
  }
}
