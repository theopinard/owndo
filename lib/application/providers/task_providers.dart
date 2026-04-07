import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/application/providers/database_provider.dart';
import 'package:owndo/data/repositories/task_repository_impl.dart';
import 'package:owndo/domain/entities/task.dart';
import 'package:owndo/domain/repositories/task_repository.dart';

part 'task_providers.g.dart';

@riverpod
TaskRepository taskRepository(TaskRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return TaskRepositoryImpl(db.tasksDao);
}

@riverpod
Stream<List<Task>> inboxTasks(InboxTasksRef ref) {
  return ref.watch(taskRepositoryProvider).watchInbox();
}

@riverpod
Stream<List<Task>> projectTasks(ProjectTasksRef ref, String projectId) {
  return ref.watch(taskRepositoryProvider).watchTasks(projectId: projectId);
}
