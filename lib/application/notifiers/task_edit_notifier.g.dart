// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_edit_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskEditNotifierHash() => r'649c808e32c2d4b5a865f0108b3713e9425d289b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TaskEditNotifier
    extends BuildlessAutoDisposeNotifier<TaskEditState> {
  late final Task? existing;
  late final String? initialProjectId;

  TaskEditState build({
    Task? existing,
    String? initialProjectId,
  });
}

/// See also [TaskEditNotifier].
@ProviderFor(TaskEditNotifier)
const taskEditNotifierProvider = TaskEditNotifierFamily();

/// See also [TaskEditNotifier].
class TaskEditNotifierFamily extends Family<TaskEditState> {
  /// See also [TaskEditNotifier].
  const TaskEditNotifierFamily();

  /// See also [TaskEditNotifier].
  TaskEditNotifierProvider call({
    Task? existing,
    String? initialProjectId,
  }) {
    return TaskEditNotifierProvider(
      existing: existing,
      initialProjectId: initialProjectId,
    );
  }

  @override
  TaskEditNotifierProvider getProviderOverride(
    covariant TaskEditNotifierProvider provider,
  ) {
    return call(
      existing: provider.existing,
      initialProjectId: provider.initialProjectId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskEditNotifierProvider';
}

/// See also [TaskEditNotifier].
class TaskEditNotifierProvider
    extends AutoDisposeNotifierProviderImpl<TaskEditNotifier, TaskEditState> {
  /// See also [TaskEditNotifier].
  TaskEditNotifierProvider({
    Task? existing,
    String? initialProjectId,
  }) : this._internal(
          () => TaskEditNotifier()
            ..existing = existing
            ..initialProjectId = initialProjectId,
          from: taskEditNotifierProvider,
          name: r'taskEditNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskEditNotifierHash,
          dependencies: TaskEditNotifierFamily._dependencies,
          allTransitiveDependencies:
              TaskEditNotifierFamily._allTransitiveDependencies,
          existing: existing,
          initialProjectId: initialProjectId,
        );

  TaskEditNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.existing,
    required this.initialProjectId,
  }) : super.internal();

  final Task? existing;
  final String? initialProjectId;

  @override
  TaskEditState runNotifierBuild(
    covariant TaskEditNotifier notifier,
  ) {
    return notifier.build(
      existing: existing,
      initialProjectId: initialProjectId,
    );
  }

  @override
  Override overrideWith(TaskEditNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TaskEditNotifierProvider._internal(
        () => create()
          ..existing = existing
          ..initialProjectId = initialProjectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        existing: existing,
        initialProjectId: initialProjectId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TaskEditNotifier, TaskEditState>
      createElement() {
    return _TaskEditNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskEditNotifierProvider &&
        other.existing == existing &&
        other.initialProjectId == initialProjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, existing.hashCode);
    hash = _SystemHash.combine(hash, initialProjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskEditNotifierRef on AutoDisposeNotifierProviderRef<TaskEditState> {
  /// The parameter `existing` of this provider.
  Task? get existing;

  /// The parameter `initialProjectId` of this provider.
  String? get initialProjectId;
}

class _TaskEditNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<TaskEditNotifier, TaskEditState>
    with TaskEditNotifierRef {
  _TaskEditNotifierProviderElement(super.provider);

  @override
  Task? get existing => (origin as TaskEditNotifierProvider).existing;
  @override
  String? get initialProjectId =>
      (origin as TaskEditNotifierProvider).initialProjectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
