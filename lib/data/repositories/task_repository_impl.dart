import 'package:owndo/core/constants.dart';
import 'package:owndo/core/utils/uuid_factory.dart';
import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/data/local/database/daos/tasks_dao.dart';
import 'package:owndo/data/local/mappers/task_mapper.dart';
import 'package:owndo/domain/entities/task.dart';
import 'package:owndo/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this._tasksDao);

  final TasksDao _tasksDao;

  @override
  Stream<List<Task>> watchInbox() {
    return _tasksDao
        .watchInboxTasks()
        .map((rows) => rows.map(TaskMapper.fromRow).toList());
  }

  @override
  Stream<List<Task>> watchTasks({required String projectId}) {
    return _tasksDao
        .watchTasksByProject(projectId)
        .map((rows) => rows.map(TaskMapper.fromRow).toList());
  }

  @override
  Future<Task?> getTaskById(String id) async {
    final row = await _tasksDao.getTaskById(id);
    return row == null ? null : TaskMapper.fromRow(row);
  }

  @override
  Future<void> saveTask(Task task) async {
    final existing = await _tasksDao.getTaskById(task.id);
    final operation = existing == null ? 'create' : 'update';
    final change = PendingChangesTableCompanion.insert(
      id: UuidFactory.generate(),
      entityType: AppConstants.entityTypeTask,
      entityId: task.id,
      operation: operation,
      updatedAt: task.updatedAt,
    );
    await _tasksDao.upsertTaskWithPendingChange(TaskMapper.toRow(task), change);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final existing = await _tasksDao.getTaskById(taskId);
    if (existing == null) return;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final deleted = TaskMapper.fromRow(existing).copyWith(
      deleted: true,
      updatedAt: now,
    );
    final change = PendingChangesTableCompanion.insert(
      id: UuidFactory.generate(),
      entityType: AppConstants.entityTypeTask,
      entityId: taskId,
      operation: 'delete',
      updatedAt: now,
    );
    await _tasksDao.upsertTaskWithPendingChange(
      TaskMapper.toRow(deleted),
      change,
    );
  }
}
