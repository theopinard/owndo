// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_changes_dao.dart';

// ignore_for_file: type=lint
mixin _$PendingChangesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PendingChangesTableTable get pendingChangesTable =>
      attachedDatabase.pendingChangesTable;
  PendingChangesDaoManager get managers => PendingChangesDaoManager(this);
}

class PendingChangesDaoManager {
  final _$PendingChangesDaoMixin _db;
  PendingChangesDaoManager(this._db);
  $$PendingChangesTableTableTableManager get pendingChangesTable =>
      $$PendingChangesTableTableTableManager(
          _db.attachedDatabase, _db.pendingChangesTable);
}
