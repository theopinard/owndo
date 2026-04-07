import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/application/providers/task_providers.dart';
import 'package:owndo/domain/entities/task.dart';

part 'task_list_notifier.g.dart';

@riverpod
class TaskListNotifier extends _$TaskListNotifier {
  @override
  Stream<List<Task>> build() {
    return ref.watch(taskRepositoryProvider).watchInbox();
  }

  Future<void> addTask(String title, {String? projectId}) async {
    final task = Task.create(title: title, projectId: projectId);
    await ref.read(taskRepositoryProvider).saveTask(task);
  }

  Future<void> toggleComplete(Task task) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await ref.read(taskRepositoryProvider).saveTask(
          task.copyWith(completed: !task.completed, updatedAt: now),
        );
  }

  Future<void> deleteTask(String id) async {
    await ref.read(taskRepositoryProvider).deleteTask(id);
  }
}
