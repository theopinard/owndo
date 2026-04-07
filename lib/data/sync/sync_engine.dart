import 'dart:async';
import 'dart:convert';

import 'package:owndo/core/constants.dart';
import 'package:owndo/data/local/database/daos/pending_changes_dao.dart';
import 'package:owndo/data/local/database/daos/projects_dao.dart';
import 'package:owndo/data/local/database/daos/subtasks_dao.dart';
import 'package:owndo/data/local/database/daos/tasks_dao.dart';
import 'package:owndo/data/local/mappers/project_mapper.dart';
import 'package:owndo/data/local/mappers/subtask_mapper.dart';
import 'package:owndo/data/local/mappers/task_mapper.dart';
import 'package:owndo/data/remote/models/project_json_model.dart';
import 'package:owndo/data/remote/models/subtask_json_model.dart';
import 'package:owndo/data/remote/models/task_json_model.dart';
import 'package:owndo/domain/sync/sync_adapter.dart';

enum SyncStatus { idle, syncing, error }

// Regex that matches Dropbox conflict-copy filenames:
//   "<uuid> (conflicted copy 2024-01-01).json"
final _conflictPattern = RegExp(
  r'^(.+?) \(conflicted copy.*\)(\.json)$',
  caseSensitive: false,
);

class SyncEngine {
  SyncEngine({
    required SyncAdapter adapter,
    required TasksDao tasksDao,
    required ProjectsDao projectsDao,
    required SubtasksDao subtasksDao,
    required PendingChangesDao pendingChangesDao,
  })  : _adapter = adapter,
        _tasksDao = tasksDao,
        _projectsDao = projectsDao,
        _subtasksDao = subtasksDao,
        _pendingChangesDao = pendingChangesDao;

  final SyncAdapter _adapter;
  final TasksDao _tasksDao;
  final ProjectsDao _projectsDao;
  final SubtasksDao _subtasksDao;
  final PendingChangesDao _pendingChangesDao;

  final _statusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get statusStream => _statusController.stream;
  SyncStatus _status = SyncStatus.idle;

  bool _isSyncing = false;

  /// Run a full push + pull sync cycle.
  /// Calling while already syncing is a no-op.
  Future<void> sync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _emit(SyncStatus.syncing);

    try {
      await _pushPhase();
      await _pullPhase();
      _emit(SyncStatus.idle);
    } catch (e, st) {
      // ignore: avoid_print
      print('[SyncEngine] sync error: $e\n$st');
      _emit(SyncStatus.error);
    } finally {
      _isSyncing = false;
    }
  }

  SyncStatus get currentStatus => _status;

  void dispose() => _statusController.close();

  // ── Push Phase ─────────────────────────────────────────────────────────────

  Future<void> _pushPhase() async {
    final changes = await _pendingChangesDao.getAllPendingChanges();

    for (final change in changes) {
      try {
        if (change.entityType == AppConstants.entityTypeTask) {
          await _pushTask(change.entityId, change.operation);
        } else if (change.entityType == AppConstants.entityTypeProject) {
          await _pushProject(change.entityId, change.operation);
        }
        // Remove pending change only on success
        await _pendingChangesDao.deletePendingChange(change.id);
      } catch (e) {
        // Partial push is acceptable — leave the pending change and retry later
        // ignore: avoid_print
        print('[SyncEngine] push failed for ${change.entityId}: $e');
      }
    }
  }

  Future<void> _pushTask(String id, String operation) async {
    final path = '/tasks/$id.json';
    if (operation == 'delete') {
      await _adapter.delete(path);
      return;
    }
    final row = await _tasksDao.getTaskById(id);
    if (row == null) return;
    final subtaskRows = await _subtasksDao.getSubtasksByTask(id);
    final subtasks = subtaskRows
        .map((s) => SubtaskJsonModel.fromDomain(SubtaskMapper.fromRow(s)))
        .toList();
    final json = jsonEncode(
      TaskJsonModel.fromDomain(TaskMapper.fromRow(row), subtasks: subtasks)
          .toJson(),
    );
    await _adapter.upload(path, json);
  }

  Future<void> _pushProject(String id, String operation) async {
    final path = '/projects/$id.json';
    if (operation == 'delete') {
      await _adapter.delete(path);
      return;
    }
    final row = await _projectsDao.getProjectById(id);
    if (row == null) return;
    final json =
        jsonEncode(ProjectJsonModel.fromDomain(ProjectMapper.fromRow(row)).toJson());
    await _adapter.upload(path, json);
  }

  // ── Pull Phase ─────────────────────────────────────────────────────────────

  Future<void> _pullPhase() async {
    await Future.wait([_pullTasks(), _pullProjects()]);
  }

  Future<void> _pullTasks() async {
    final files = await _adapter.listFiles('/tasks/');

    for (final filename in files) {
      // Handle conflict copies
      final conflictMatch = _conflictPattern.firstMatch(filename);
      if (conflictMatch != null) {
        await _resolveTaskConflict(filename, conflictMatch.group(1)!);
        continue;
      }

      if (!filename.endsWith('.json')) continue;

      try {
        final content = await _adapter.download('/tasks/$filename');
        final remoteModel = TaskJsonModel.fromJson(
          jsonDecode(content) as Map<String, dynamic>,
        );
        final remote = remoteModel.toDomain();

        final localRow = await _tasksDao.getTaskById(remote.id);
        if (localRow == null || remote.updatedAt > localRow.updatedAt) {
          await _tasksDao.upsertFromSync(TaskMapper.toRow(remote));
        }
        // Merge subtasks individually — last write wins per subtask.
        // Fetch all local subtasks once (not once per subtask).
        if (remoteModel.subtasks.isNotEmpty) {
          final localSubtaskRows =
              await _subtasksDao.getSubtasksByTask(remote.id);
          final localById = {for (final r in localSubtaskRows) r.id: r};
          for (final subtaskModel in remoteModel.subtasks) {
            final subtask = subtaskModel.toDomain();
            final local = localById[subtask.id];
            if (local == null || subtask.updatedAt > local.updatedAt) {
              await _subtasksDao.upsertFromSync(SubtaskMapper.toRow(subtask));
            }
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print('[SyncEngine] pull task $filename failed: $e');
      }
    }
  }

  Future<void> _pullProjects() async {
    final files = await _adapter.listFiles('/projects/');

    for (final filename in files) {
      final conflictMatch = _conflictPattern.firstMatch(filename);
      if (conflictMatch != null) {
        await _resolveProjectConflict(filename, conflictMatch.group(1)!);
        continue;
      }

      if (!filename.endsWith('.json')) continue;

      try {
        final content = await _adapter.download('/projects/$filename');
        final remote = ProjectJsonModel.fromJson(
          jsonDecode(content) as Map<String, dynamic>,
        ).toDomain();

        final localRow = await _projectsDao.getProjectById(remote.id);
        if (localRow == null || remote.updatedAt > localRow.updatedAt) {
          await _projectsDao.upsertFromSync(ProjectMapper.toRow(remote));
        }
      } catch (e) {
        // ignore: avoid_print
        print('[SyncEngine] pull project $filename failed: $e');
      }
    }
  }

  // ── Conflict Resolution ────────────────────────────────────────────────────

  Future<void> _resolveTaskConflict(
    String conflictFilename,
    String baseId,
  ) async {
    try {
      final canonicalFilename = '$baseId.json';
      final conflictContent =
          await _adapter.download('/tasks/$conflictFilename');
      final conflict = TaskJsonModel.fromJson(
        jsonDecode(conflictContent) as Map<String, dynamic>,
      ).toDomain();

      final localRow = await _tasksDao.getTaskById(conflict.id);

      // Tiebreak: prefer remote (pull wins) on equal timestamps
      if (localRow == null || conflict.updatedAt >= localRow.updatedAt) {
        await _tasksDao.upsertFromSync(TaskMapper.toRow(conflict));
        // Promote conflict copy to canonical path
        await _adapter.upload(
          '/tasks/$canonicalFilename',
          jsonEncode(TaskJsonModel.fromDomain(conflict).toJson()),
        );
      }
      // Delete the conflict copy regardless of winner
      await _adapter.delete('/tasks/$conflictFilename');
    } catch (_) {
      // Best-effort conflict resolution
    }
  }

  Future<void> _resolveProjectConflict(
    String conflictFilename,
    String baseId,
  ) async {
    try {
      final canonicalFilename = '$baseId.json';
      final conflictContent =
          await _adapter.download('/projects/$conflictFilename');
      final conflict = ProjectJsonModel.fromJson(
        jsonDecode(conflictContent) as Map<String, dynamic>,
      ).toDomain();

      final localRow = await _projectsDao.getProjectById(conflict.id);

      if (localRow == null || conflict.updatedAt >= localRow.updatedAt) {
        await _projectsDao.upsertFromSync(ProjectMapper.toRow(conflict));
        await _adapter.upload(
          '/projects/$canonicalFilename',
          jsonEncode(ProjectJsonModel.fromDomain(conflict).toJson()),
        );
      }
      await _adapter.delete('/projects/$conflictFilename');
    } catch (_) {
      // Best-effort
    }
  }

  void _emit(SyncStatus status) {
    _status = status;
    _statusController.add(status);
  }
}
