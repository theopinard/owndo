// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dropboxAuth)
final dropboxAuthProvider = DropboxAuthProvider._();

final class DropboxAuthProvider
    extends
        $FunctionalProvider<
          DropboxAuthService,
          DropboxAuthService,
          DropboxAuthService
        >
    with $Provider<DropboxAuthService> {
  DropboxAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dropboxAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dropboxAuthHash();

  @$internal
  @override
  $ProviderElement<DropboxAuthService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DropboxAuthService create(Ref ref) {
    return dropboxAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DropboxAuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DropboxAuthService>(value),
    );
  }
}

String _$dropboxAuthHash() => r'c85a18649b6a35ef9be97236c296bc30470802b4';

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

final class IsAuthenticatedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isAuthenticated(ref);
  }
}

String _$isAuthenticatedHash() => r'c299502d505e97ea8dc9dfaf03a13ae8c6c533ea';

@ProviderFor(appAccessMode)
final appAccessModeProvider = AppAccessModeProvider._();

final class AppAccessModeProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppAccessMode>,
          AppAccessMode,
          FutureOr<AppAccessMode>
        >
    with $FutureModifier<AppAccessMode>, $FutureProvider<AppAccessMode> {
  AppAccessModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appAccessModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appAccessModeHash();

  @$internal
  @override
  $FutureProviderElement<AppAccessMode> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppAccessMode> create(Ref ref) {
    return appAccessMode(ref);
  }
}

String _$appAccessModeHash() => r'21272f047ef8bcec5dea906d31eb850e80cd7e3c';
