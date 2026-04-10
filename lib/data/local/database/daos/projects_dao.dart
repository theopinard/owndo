import 'package:drift/drift.dart';
import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/data/local/database/tables/projects_table.dart';
import 'package:owndo/data/local/database/tables/pending_changes_table.dart';

part 'projects_dao.g.dart';

@DriftAccessor(tables: [ProjectsTable, PendingChangesTable])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(super.db);

  Stream<List<ProjectsTableData>> watchProjects() {
    return (select(projectsTable)
          ..where((p) => p.deleted.equals(false))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .watch();
  }

  Future<ProjectsTableData?> getProjectById(String id) {
    return (select(projectsTable)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertProjectWithPendingChange(
    ProjectsTableData row,
    PendingChangesTableCompanion change,
  ) async {
    await transaction(() async {
      await into(projectsTable).insertOnConflictUpdate(row);
      await into(pendingChangesTable)
          .insert(change, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> upsertFromSync(ProjectsTableData row) async {
    await into(projectsTable).insertOnConflictUpdate(row);
  }
}
