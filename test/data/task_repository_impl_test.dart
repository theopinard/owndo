import 'package:flutter_test/flutter_test.dart';
import 'package:owndo/data/repositories/task_repository_impl.dart';
import 'package:owndo/domain/entities/task.dart';

import '../helpers/test_database.dart';

void main() {
  setUpAll(setupTestSqlite);

  group('TaskRepositoryImpl', () {
    late TaskRepositoryImpl repo;

    setUp(() {
      final db = openTestDatabase();
      repo = TaskRepositoryImpl(db.tasksDao);
    });

    test('saves and retrieves a task', () async {
      final task = Task.create(title: 'Buy groceries');
      await repo.saveTask(task);

      final found = await repo.getTaskById(task.id);
      expect(found, isNotNull);
      expect(found!.title, 'Buy groceries');
      expect(found.completed, false);
      expect(found.deleted, false);
    });

    test('watchInbox emits tasks without a project', () async {
      final inbox = Task.create(title: 'Inbox task');
      final projectTask = Task.create(title: 'Project task', projectId: 'p1');

      await repo.saveTask(inbox);
      await repo.saveTask(projectTask);

      final tasks = await repo.watchInbox().first;
      expect(tasks.length, 1);
      expect(tasks.first.title, 'Inbox task');
    });

    test('deleteTask soft-deletes (sets deleted=true)', () async {
      final task = Task.create(title: 'To delete');
      await repo.saveTask(task);

      await repo.deleteTask(task.id);

      // Soft-deleted tasks should not appear in watchInbox
      final inbox = await repo.watchInbox().first;
      expect(inbox, isEmpty);

      // But the row still exists with deleted=true
      final found = await repo.getTaskById(task.id);
      expect(found!.deleted, true);
    });

    test('saveTask updates an existing task', () async {
      final task = Task.create(title: 'Original');
      await repo.saveTask(task);

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await repo.saveTask(task.copyWith(title: 'Updated', updatedAt: now));

      final found = await repo.getTaskById(task.id);
      expect(found!.title, 'Updated');
    });
  });
}
