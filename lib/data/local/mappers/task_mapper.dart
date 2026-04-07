import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/domain/entities/task.dart';

abstract final class TaskMapper {
  static Task fromRow(TasksTableData row) {
    return Task(
      id: row.id,
      title: row.title,
      description: row.description,
      completed: row.completed,
      projectId: row.projectId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  static TasksTableData toRow(Task task) {
    return TasksTableData(
      id: task.id,
      title: task.title,
      description: task.description,
      completed: task.completed,
      projectId: task.projectId,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      deleted: task.deleted,
    );
  }
}
