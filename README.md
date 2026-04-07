# OwnDo

Offline-first todo app with Dropbox sync. Available on Android, iOS, and macOS.

## Architecture

```
UI (Flutter + Riverpod)
  ↓
Domain Layer (pure Dart: entities, repository interfaces, sync adapter interface)
  ↓
Data Layer (Drift/SQLite locally, Dropbox HTTP API remotely)
  ↓
Sync Engine (push/pull/conflict resolution)
```

## Setup

### 1. Install Flutter

```bash
# Follow https://docs.flutter.dev/get-started/install
flutter --version  # requires >= 3.22
```

### 2. Scaffold the Flutter project (first time only)

```bash
flutter create . \
  --project-name owndo \
  --org com.theodore.owndo \
  --platforms android,ios,linux,macos \
  --description "Offline-first todo app with Dropbox sync"
```

### 3. Create a Dropbox App

1. Go to https://www.dropbox.com/developers/apps
2. Create a new app → **Scoped access** → **App folder**
3. Under **OAuth 2**, add redirect URI: `owndo://oauth-callback`
4. Note your **App key** and **App secret**

### 4. Install dependencies & generate code

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
flutter run -d macos \
  --dart-define=DROPBOX_APP_KEY=your_app_key \
  --dart-define=DROPBOX_APP_SECRET=your_app_secret
```

Replace `-d macos` with `-d linux`, `-d android`, or `-d ios` as needed.

### Platform-specific configuration

**Linux** — install system dependencies for `flutter_secure_storage` and `flutter_web_auth_2`:

```bash
sudo apt-get install -y \
  libsecret-1-dev \
  libjsoncpp-dev \
  libssl-dev
```

No URL scheme registration is needed on Linux. The OAuth2 flow uses a `localhost` redirect URI — add `http://localhost` to the allowed redirect URIs in your Dropbox app settings alongside `owndo://oauth-callback`.

**Android** — `android/app/src/main/AndroidManifest.xml` (inside `<application>`):
```xml
<activity android:name="com.linusu.flutter_web_auth_2.CallbackActivity"
          android:exported="true">
  <intent-filter android:label="flutter_web_auth_2">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="owndo" android:host="oauth-callback" />
  </intent-filter>
</activity>
```

**iOS** — `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>owndo</string></array>
  </dict>
</array>
```

**macOS** — `macos/Runner/Info.plist`: same URL scheme as iOS.

Both macOS entitlement files (`DebugProfile.entitlements` and `Release.entitlements`):
```xml
<key>com.apple.security.network.client</key>
<true/>
```

## Running tests

```bash
flutter test
```

## Project structure

```
lib/
├── core/           # Constants, errors, utilities
├── domain/         # Entities, repository interfaces, sync adapter interface
├── data/
│   ├── local/      # Drift database, DAOs, mappers
│   ├── remote/     # Dropbox API client, auth service, JSON models
│   ├── repositories/
│   └── sync/       # SyncEngine, SyncScheduler
├── application/    # Riverpod providers and notifiers
└── presentation/   # Screens, router, widgets
```

## Sync design

- **Local DB is the source of truth**
- Every local write records a `pending_change`
- Sync engine: push all pending changes → pull all remote files → merge (last-write-wins on `updated_at`)
- Sync runs on app start, every 45 seconds, and on foreground resume
- Dropbox conflict copies are auto-resolved (newer `updated_at` wins)
- Network errors don't block the UI — pending changes are retried next cycle
