# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (Drift, Riverpod, Freezed, JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs

# Static analysis
flutter analyze

# Run all tests
flutter test

# Run a single test file
flutter test test/data/sync_engine_test.dart

# Run on Linux (requires Dropbox credentials)
flutter run -d linux \
  --dart-define=DROPBOX_APP_KEY=xxx \
  --dart-define=DROPBOX_APP_SECRET=yyy
```

Dropbox credentials are never committed — always passed via `--dart-define`.

### Dropbox app setup

In the [Dropbox developer console](https://www.dropbox.com/developers/apps), your app needs:

**Permissions tab** — enable all three scopes:
- `files.metadata.read` — list folder contents (pull phase)
- `files.content.read` — download files (pull phase)
- `files.content.write` — upload and delete files (push phase)

**OAuth 2 → Redirect URIs**:
- `http://localhost:8765` — Linux OAuth callback (fixed port)
- `owndo://oauth-callback` — Android / iOS / macOS deep link

After changing scopes or redirect URIs, sign out and re-authenticate so the new token includes the updated permissions.

## Architecture

The app follows clean architecture with four layers:

```
domain/ → data/ → application/ → presentation/
```

**domain/** — Pure Dart, no Flutter/package imports. Contains Freezed entities (`Task`, `Project`), abstract repository interfaces, and the abstract `SyncAdapter` interface. Nothing here depends on anything outside this layer.

**data/** — Two sub-layers:
- `local/` — Drift ORM (SQLite). `AppDatabase` is the single Drift database class; all generated types (`*TableData`, `*TableCompanion`, DAOs) are accessible by importing `app_database.dart`. Every user-initiated write goes through a DAO method that wraps both the entity upsert and a `pending_changes` row insert in a single transaction. Pull-phase writes from the sync engine use separate `upsertFromSync()` DAO methods that intentionally skip `pending_changes`.
- `remote/` — Dropbox HTTP API. `DropboxAuthService` handles OAuth2 PKCE and token refresh. `DropboxSyncAdapter` implements the domain `SyncAdapter` interface. On Linux the OAuth redirect uses `http://localhost`; on all other platforms it uses the `owndo://oauth-callback` custom URL scheme.
- `sync/` — `SyncEngine` orchestrates push (upload all `pending_changes`) then pull (download all remote files, merge by `updated_at`, last-write-wins). `SyncScheduler` triggers sync on app start, every 45 seconds, and on foreground resume.

**application/** — Riverpod 2.x with code generation (`@riverpod` / `@Riverpod(keepAlive: true)`). Providers wire the data layer together. `SyncScheduler` is started from `app.dart` via `ref.listenManual` once `isAuthenticatedProvider` becomes true.

**presentation/** — `go_router` with an auth redirect guard. Navigation uses `AdaptiveNavShell` which renders `NavigationRail` on screens ≥ 720px wide (Linux/macOS) and `NavigationBar` on mobile.

## Code generation

Four generators run via `build_runner`:
- **Drift** — generates `app_database.g.dart` and `*.g.dart` for each DAO
- **Riverpod** — generates `*.g.dart` for each provider/notifier file
- **Freezed** — generates `*.freezed.dart` for `Task`, `Project`, `TaskEditState`
- **json_serializable** — generates `*.g.dart` for `TaskJsonModel`, `ProjectJsonModel`

All generated files are committed. Re-run after any change to annotated classes.

## Key data design decisions

- **Soft delete**: entities are never hard-deleted; `deleted: true` acts as a tombstone so deletions propagate across devices via Dropbox.
- **`pending_changes` table**: unique constraint on `(entity_type, entity_id)` with `InsertMode.insertOrReplace` ensures only the latest pending change per entity is kept. The `PendingChangesTableCompanion` type comes from `app_database.dart` (generated), not the table definition file.
- **Sync merge**: `remote.updated_at > local.updated_at` → overwrite local. Tiebreak: remote wins. Pull-phase upserts never write to `pending_changes`.

## Testing

Tests use an in-memory Drift database. Call `setUpAll(setupTestSqlite)` at the top of every test `main()` — this loads `libsqlite3.so.0` on Linux (the unversioned `.so` symlink from `libsecret3-dev` is often absent) and suppresses Drift's multiple-database warning.
