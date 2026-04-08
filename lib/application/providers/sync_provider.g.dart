// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dropboxSyncAdapter)
final dropboxSyncAdapterProvider = DropboxSyncAdapterProvider._();

final class DropboxSyncAdapterProvider extends $FunctionalProvider<
    DropboxSyncAdapter,
    DropboxSyncAdapter,
    DropboxSyncAdapter> with $Provider<DropboxSyncAdapter> {
  DropboxSyncAdapterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dropboxSyncAdapterProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dropboxSyncAdapterHash();

  @$internal
  @override
  $ProviderElement<DropboxSyncAdapter> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DropboxSyncAdapter create(Ref ref) {
    return dropboxSyncAdapter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DropboxSyncAdapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DropboxSyncAdapter>(value),
    );
  }
}

String _$dropboxSyncAdapterHash() =>
    r'8addebc986057b10b955cc77fced3020402e5433';

@ProviderFor(syncEngine)
final syncEngineProvider = SyncEngineProvider._();

final class SyncEngineProvider
    extends $FunctionalProvider<SyncEngine, SyncEngine, SyncEngine>
    with $Provider<SyncEngine> {
  SyncEngineProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncEngineProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncEngineHash();

  @$internal
  @override
  $ProviderElement<SyncEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncEngine create(Ref ref) {
    return syncEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncEngine>(value),
    );
  }
}

String _$syncEngineHash() => r'6ee0ba409a66b0897eb9caffec3a09884f6abd26';

@ProviderFor(syncScheduler)
final syncSchedulerProvider = SyncSchedulerProvider._();

final class SyncSchedulerProvider
    extends $FunctionalProvider<SyncScheduler, SyncScheduler, SyncScheduler>
    with $Provider<SyncScheduler> {
  SyncSchedulerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncSchedulerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncSchedulerHash();

  @$internal
  @override
  $ProviderElement<SyncScheduler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncScheduler create(Ref ref) {
    return syncScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncScheduler>(value),
    );
  }
}

String _$syncSchedulerHash() => r'4ab18f603b06b2cefc2d6e8e633d6c91101b558f';

@ProviderFor(syncStatus)
final syncStatusProvider = SyncStatusProvider._();

final class SyncStatusProvider extends $FunctionalProvider<
        AsyncValue<SyncStatus>, SyncStatus, Stream<SyncStatus>>
    with $FutureModifier<SyncStatus>, $StreamProvider<SyncStatus> {
  SyncStatusProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncStatusProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncStatusHash();

  @$internal
  @override
  $StreamProviderElement<SyncStatus> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<SyncStatus> create(Ref ref) {
    return syncStatus(ref);
  }
}

String _$syncStatusHash() => r'c9297f688533e6071eab8cda9c436983eda2364f';
