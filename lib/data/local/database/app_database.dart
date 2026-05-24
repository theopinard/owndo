import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:owndo/data/local/database/daos/pending_changes_dao.dart';
import 'package:owndo/data/local/database/daos/projects_dao.dart';
import 'package:owndo/data/local/database/daos/subtasks_dao.dart';
import 'package:owndo/data/local/database/daos/tasks_dao.dart';
import 'package:owndo/data/local/database/tables/pending_changes_table.dart';
import 'package:owndo/data/local/database/tables/projects_table.dart';
import 'package:owndo/data/local/database/tables/subtasks_table.dart';
import 'package:owndo/data/local/database/tables/tasks_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [TasksTable, ProjectsTable, SubtasksTable, PendingChangesTable],
  daos: [TasksDao, ProjectsDao, SubtasksDao, PendingChangesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Constructor for testing with an in-memory database.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(tasksTable, tasksTable.description);
          }
          if (from < 3) {
            await m.createTable(subtasksTable);
          }
          if (from < 4) {
            await m.addColumn(tasksTable, tasksTable.deadline);
            await m.addColumn(tasksTable, tasksTable.reminderAt);
          }
          if (from < 5) {
            await m.addColumn(tasksTable, tasksTable.subtaskSteps);
            await m.addColumn(subtasksTable, subtasksTable.currentStep);
            // Migrate: set currentStep = 1 for previously completed subtasks.
            await customStatement(
              'UPDATE subtasks SET current_step = 1 WHERE completed = 1',
            );
            // Drop the old completed column is not straightforward in SQLite,
            // so we leave it (Drift ignores columns not in the schema).
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'owndo_db');
  }
}
