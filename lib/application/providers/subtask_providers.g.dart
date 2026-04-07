// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subtaskListNotifierHash() =>
    r'c29952c0c17c4b955eded278401bb5199499ab34';

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

abstract class _$SubtaskListNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<Subtask>> {
  late final String taskId;

  Stream<List<Subtask>> build(
    String taskId,
  );
}

/// See also [SubtaskListNotifier].
@ProviderFor(SubtaskListNotifier)
const subtaskListNotifierProvider = SubtaskListNotifierFamily();

/// See also [SubtaskListNotifier].
class SubtaskListNotifierFamily extends Family<AsyncValue<List<Subtask>>> {
  /// See also [SubtaskListNotifier].
  const SubtaskListNotifierFamily();

  /// See also [SubtaskListNotifier].
  SubtaskListNotifierProvider call(
    String taskId,
  ) {
    return SubtaskListNotifierProvider(
      taskId,
    );
  }

  @override
  SubtaskListNotifierProvider getProviderOverride(
    covariant SubtaskListNotifierProvider provider,
  ) {
    return call(
      provider.taskId,
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
  String? get name => r'subtaskListNotifierProvider';
}

/// See also [SubtaskListNotifier].
class SubtaskListNotifierProvider extends AutoDisposeStreamNotifierProviderImpl<
    SubtaskListNotifier, List<Subtask>> {
  /// See also [SubtaskListNotifier].
  SubtaskListNotifierProvider(
    String taskId,
  ) : this._internal(
          () => SubtaskListNotifier()..taskId = taskId,
          from: subtaskListNotifierProvider,
          name: r'subtaskListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$subtaskListNotifierHash,
          dependencies: SubtaskListNotifierFamily._dependencies,
          allTransitiveDependencies:
              SubtaskListNotifierFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  SubtaskListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  Stream<List<Subtask>> runNotifierBuild(
    covariant SubtaskListNotifier notifier,
  ) {
    return notifier.build(
      taskId,
    );
  }

  @override
  Override overrideWith(SubtaskListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SubtaskListNotifierProvider._internal(
        () => create()..taskId = taskId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<SubtaskListNotifier, List<Subtask>>
      createElement() {
    return _SubtaskListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubtaskListNotifierProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubtaskListNotifierRef
    on AutoDisposeStreamNotifierProviderRef<List<Subtask>> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _SubtaskListNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<SubtaskListNotifier,
        List<Subtask>> with SubtaskListNotifierRef {
  _SubtaskListNotifierProviderElement(super.provider);

  @override
  String get taskId => (origin as SubtaskListNotifierProvider).taskId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
