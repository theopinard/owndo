import 'package:drift/drift.dart';
import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/data/local/database/tables/pending_changes_table.dart';

part 'pending_changes_dao.g.dart';

@DriftAccessor(tables: [PendingChangesTable])
class PendingChangesDao extends DatabaseAccessor<AppDatabase>
    with _$PendingChangesDaoMixin {
  PendingChangesDao(super.db);

  Future<List<PendingChangesTableData>> getAllPendingChanges() {
    return (select(pendingChangesTable)
          ..orderBy([(c) => OrderingTerm.asc(c.updatedAt)]))
        .get();
  }

  Future<void> deletePendingChange(String id) {
    return (delete(pendingChangesTable)
          ..where((c) => c.id.equals(id)))
        .go();
  }
}
