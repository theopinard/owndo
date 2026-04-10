import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:owndo/data/local/database/app_database.dart';
import 'package:sqlite3/open.dart';

/// Call once at the top of each test file's main() to load the correct
/// SQLite library path on Linux (where libsqlite3-dev may not be installed
/// but libsqlite3.so.0 is always present).
void setupTestSqlite() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      return DynamicLibrary.open('libsqlite3.so.0');
    });
  }
}

AppDatabase openTestDatabase() {
  return AppDatabase.forTesting(
    DatabaseConnection(NativeDatabase.memory()),
  );
}
