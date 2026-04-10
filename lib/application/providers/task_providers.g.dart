// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'a4efc2375477ce9d79fbd6a43441f790aea3ac99';

@ProviderFor(inboxTasks)
final inboxTasksProvider = InboxTasksProvider._();

final class InboxTasksProvider extends $FunctionalProvider<
        AsyncValue<List<Task>>, List<Task>, Stream<List<Task>>>
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  InboxTasksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'inboxTasksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$inboxTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return inboxTasks(ref);
  }
}

String _$inboxTasksHash() => r'ce4cf49b3ce055f81ab79deb3b9e4937d7ee3f9c';

@ProviderFor(projectTasks)
final projectTasksProvider = ProjectTasksFamily._();

final class ProjectTasksProvider extends $FunctionalProvider<
        AsyncValue<List<Task>>, List<Task>, Stream<List<Task>>>
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  ProjectTasksProvider._(
      {required ProjectTasksFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'projectTasksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$projectTasksHash();

  @override
  String toString() {
    return r'projectTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return projectTasks(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectTasksHash() => r'f4a38eee4206323d71cb3bbf181b50a481b127de';

final class ProjectTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  ProjectTasksFamily._()
      : super(
          retry: null,
          name: r'projectTasksProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ProjectTasksProvider call(
    String projectId,
  ) =>
      ProjectTasksProvider._(argument: projectId, from: this);

  @override
  String toString() => r'projectTasksProvider';
}
