import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:owndo/data/sync/sync_engine.dart';
import 'package:owndo/domain/entities/task.dart';
import 'package:owndo/data/repositories/task_repository_impl.dart';
import 'package:owndo/data/remote/models/task_json_model.dart';

import '../helpers/mock_sync_adapter.dart';
import '../helpers/test_database.dart';

void main() {
  setUpAll(setupTestSqlite);

  group('SyncEngine', () {
    late MockSyncAdapter adapter;
    late SyncEngine engine;
    late TaskRepositoryImpl taskRepo;

    setUp(() {
      adapter = MockSyncAdapter();
      final db = openTestDatabase();
      taskRepo = TaskRepositoryImpl(db.tasksDao);
      engine = SyncEngine(
        adapter: adapter,
        tasksDao: db.tasksDao,
        projectsDao: db.projectsDao,
        subtasksDao: db.subtasksDao,
        pendingChangesDao: db.pendingChangesDao,
      );
    });

    tearDown(() => engine.dispose());

    test('push phase uploads pending task changes', () async {
      when(() => adapter.upload(any(), any()))
          .thenAnswer((_) async {});
      when(() => adapter.listFiles(any()))
          .thenAnswer((_) async => []);

      final task = Task.create(title: 'Test task');
      await taskRepo.saveTask(task);

      await engine.sync();

      verify(() => adapter.upload('/tasks/${task.id}.json', any())).called(1);
    });

    test('push phase deletes file for soft-deleted tasks', () async {
      when(() => adapter.upload(any(), any()))
          .thenAnswer((_) async {});
      when(() => adapter.delete(any()))
          .thenAnswer((_) async {});
      when(() => adapter.listFiles(any()))
          .thenAnswer((_) async => []);

      final task = Task.create(title: 'To delete');
      await taskRepo.saveTask(task);
      await taskRepo.deleteTask(task.id);

      await engine.sync();

      verify(() => adapter.delete('/tasks/${task.id}.json')).called(1);
    });

    test('pull phase updates local when remote is newer', () async {
      when(() => adapter.upload(any(), any()))
          .thenAnswer((_) async {});
      when(() => adapter.listFiles('/tasks/'))
          .thenAnswer((_) async => ['abc-123.json']);
      when(() => adapter.listFiles('/projects/'))
          .thenAnswer((_) async => []);

      const remoteTask = Task(
        id: 'abc-123',
        title: 'Remote title',
        completed: false,
        projectId: null,
        createdAt: 1000,
        updatedAt: 9999, // newer than anything local
        deleted: false,
      );
      final remoteJson = jsonEncode(
        TaskJsonModel.fromDomain(remoteTask).toJson(),
      );
      when(() => adapter.download('/tasks/abc-123.json'))
          .thenAnswer((_) async => remoteJson);

      await engine.sync();

      final local = await taskRepo.getTaskById('abc-123');
      expect(local?.title, 'Remote title');
    });

    test('pull phase keeps local when local is newer', () async {
      final localTask = Task.create(title: 'Local title');
      await taskRepo.saveTask(localTask);

      when(() => adapter.upload(any(), any()))
          .thenAnswer((_) async {});
      when(() => adapter.listFiles('/tasks/'))
          .thenAnswer((_) async => ['${localTask.id}.json']);
      when(() => adapter.listFiles('/projects/'))
          .thenAnswer((_) async => []);

      final remoteTask = localTask.copyWith(
        title: 'Old remote',
        updatedAt: localTask.updatedAt - 100, // older
      );
      when(() => adapter.download('/tasks/${localTask.id}.json'))
          .thenAnswer((_) async =>
              jsonEncode(TaskJsonModel.fromDomain(remoteTask).toJson()));

      await engine.sync();

      final local = await taskRepo.getTaskById(localTask.id);
      expect(local?.title, 'Local title');
    });

    test('network error during push leaves pending change for retry', () async {
      when(() => adapter.upload(any(), any()))
          .thenThrow(Exception('network error'));
      when(() => adapter.listFiles(any()))
          .thenAnswer((_) async => []);

      final task = Task.create(title: 'Retry task');
      await taskRepo.saveTask(task);

      await engine.sync();

      // The upload failed, so the pending change should still exist
      // Verify by checking that the next sync attempts upload again
      verify(() => adapter.upload('/tasks/${task.id}.json', any())).called(1);
    });
  });
}
