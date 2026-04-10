// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskListNotifier)
final taskListProvider = TaskListNotifierProvider._();

final class TaskListNotifierProvider
    extends $StreamNotifierProvider<TaskListNotifier, List<Task>> {
  TaskListNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskListNotifierHash();

  @$internal
  @override
  TaskListNotifier create() => TaskListNotifier();
}

String _$taskListNotifierHash() => r'4e084b1a8c26e58a99c3317679595b428b9875ce';

abstract class _$TaskListNotifier extends $StreamNotifier<List<Task>> {
  Stream<List<Task>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Task>>, List<Task>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Task>>, List<Task>>,
        AsyncValue<List<Task>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
