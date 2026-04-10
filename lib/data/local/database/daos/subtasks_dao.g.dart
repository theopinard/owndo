// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtasks_dao.dart';

// ignore_for_file: type=lint
mixin _$SubtasksDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubtasksTableTable get subtasksTable => attachedDatabase.subtasksTable;
  $PendingChangesTableTable get pendingChangesTable =>
      attachedDatabase.pendingChangesTable;
  SubtasksDaoManager get managers => SubtasksDaoManager(this);
}

class SubtasksDaoManager {
  final _$SubtasksDaoMixin _db;
  SubtasksDaoManager(this._db);
  $$SubtasksTableTableTableManager get subtasksTable =>
      $$SubtasksTableTableTableManager(_db.attachedDatabase, _db.subtasksTable);
  $$PendingChangesTableTableTableManager get pendingChangesTable =>
      $$PendingChangesTableTableTableManager(
          _db.attachedDatabase, _db.pendingChangesTable);
}
