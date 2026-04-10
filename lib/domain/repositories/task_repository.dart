import 'package:owndo/domain/entities/task.dart';

abstract interface class TaskRepository {
  Stream<List<Task>> watchInbox();
  Stream<List<Task>> watchTasks({required String projectId});
  Future<Task?> getTaskById(String id);
  Future<void> saveTask(Task task);
  Future<void> deleteTask(String taskId);
}
