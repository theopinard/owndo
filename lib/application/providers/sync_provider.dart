import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/application/providers/auth_provider.dart';
import 'package:owndo/application/providers/database_provider.dart';
import 'package:owndo/data/remote/dropbox/dropbox_api_client.dart';
import 'package:owndo/data/remote/dropbox/dropbox_sync_adapter.dart';
import 'package:owndo/data/sync/sync_engine.dart';
import 'package:owndo/data/sync/sync_scheduler.dart';

part 'sync_provider.g.dart';

@Riverpod(keepAlive: true)
DropboxSyncAdapter dropboxSyncAdapter(Ref ref) {
  final auth = ref.watch(dropboxAuthProvider);
  return DropboxSyncAdapter(auth, DropboxApiClient());
}

@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final adapter = ref.watch(dropboxSyncAdapterProvider);
  final db = ref.watch(appDatabaseProvider);
  final engine = SyncEngine(
    adapter: adapter,
    tasksDao: db.tasksDao,
    projectsDao: db.projectsDao,
    subtasksDao: db.subtasksDao,
    pendingChangesDao: db.pendingChangesDao,
  );
  ref.onDispose(engine.dispose);
  return engine;
}

@Riverpod(keepAlive: true)
SyncScheduler syncScheduler(Ref ref) {
  final engine = ref.watch(syncEngineProvider);
  final scheduler = SyncScheduler(engine);
  ref.onDispose(scheduler.stop);
  return scheduler;
}

@riverpod
Stream<SyncStatus> syncStatus(Ref ref) {
  return ref.watch(syncEngineProvider).statusStream;
}
