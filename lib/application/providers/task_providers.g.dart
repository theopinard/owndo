// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskRepositoryHash() => r'1f26073ed4f48c84140fdb121dd13bb519a12937';

/// See also [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider = AutoDisposeProvider<TaskRepository>.internal(
  taskRepository,
  name: r'taskRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRepositoryRef = AutoDisposeProviderRef<TaskRepository>;
String _$inboxTasksHash() => r'dc79cfc6efc4d950c1c2f22cf5585cc8c0520b87';

/// See also [inboxTasks].
@ProviderFor(inboxTasks)
final inboxTasksProvider = AutoDisposeStreamProvider<List<Task>>.internal(
  inboxTasks,
  name: r'inboxTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$inboxTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InboxTasksRef = AutoDisposeStreamProviderRef<List<Task>>;
String _$projectTasksHash() => r'c52840a48816ceee275651f8e75df7efddd4785d';

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

/// See also [projectTasks].
@ProviderFor(projectTasks)
const projectTasksProvider = ProjectTasksFamily();

/// See also [projectTasks].
class ProjectTasksFamily extends Family<AsyncValue<List<Task>>> {
  /// See also [projectTasks].
  const ProjectTasksFamily();

  /// See also [projectTasks].
  ProjectTasksProvider call(
    String projectId,
  ) {
    return ProjectTasksProvider(
      projectId,
    );
  }

  @override
  ProjectTasksProvider getProviderOverride(
    covariant ProjectTasksProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'projectTasksProvider';
}

/// See also [projectTasks].
class ProjectTasksProvider extends AutoDisposeStreamProvider<List<Task>> {
  /// See also [projectTasks].
  ProjectTasksProvider(
    String projectId,
  ) : this._internal(
          (ref) => projectTasks(
            ref as ProjectTasksRef,
            projectId,
          ),
          from: projectTasksProvider,
          name: r'projectTasksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectTasksHash,
          dependencies: ProjectTasksFamily._dependencies,
          allTransitiveDependencies:
              ProjectTasksFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    Stream<List<Task>> Function(ProjectTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectTasksProvider._internal(
        (ref) => create(ref as ProjectTasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Task>> createElement() {
    return _ProjectTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectTasksProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectTasksRef on AutoDisposeStreamProviderRef<List<Task>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectTasksProviderElement
    extends AutoDisposeStreamProviderElement<List<Task>> with ProjectTasksRef {
  _ProjectTasksProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectTasksProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
