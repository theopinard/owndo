// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_edit_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskEditNotifier)
final taskEditProvider = TaskEditNotifierFamily._();

final class TaskEditNotifierProvider
    extends $NotifierProvider<TaskEditNotifier, TaskEditState> {
  TaskEditNotifierProvider._(
      {required TaskEditNotifierFamily super.from,
      required ({
        Task? existing,
        String? initialProjectId,
      })
          super.argument})
      : super(
          retry: null,
          name: r'taskEditProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskEditNotifierHash();

  @override
  String toString() {
    return r'taskEditProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TaskEditNotifier create() => TaskEditNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskEditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskEditState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskEditNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskEditNotifierHash() => r'649c808e32c2d4b5a865f0108b3713e9425d289b';

final class TaskEditNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            TaskEditNotifier,
            TaskEditState,
            TaskEditState,
            TaskEditState,
            ({
              Task? existing,
              String? initialProjectId,
            })> {
  TaskEditNotifierFamily._()
      : super(
          retry: null,
          name: r'taskEditProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TaskEditNotifierProvider call({
    Task? existing,
    String? initialProjectId,
  }) =>
      TaskEditNotifierProvider._(argument: (
        existing: existing,
        initialProjectId: initialProjectId,
      ), from: this);

  @override
  String toString() => r'taskEditProvider';
}

abstract class _$TaskEditNotifier extends $Notifier<TaskEditState> {
  late final _$args = ref.$arg as ({
    Task? existing,
    String? initialProjectId,
  });
  Task? get existing => _$args.existing;
  String? get initialProjectId => _$args.initialProjectId;

  TaskEditState build({
    Task? existing,
    String? initialProjectId,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TaskEditState, TaskEditState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TaskEditState, TaskEditState>,
        TaskEditState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              existing: _$args.existing,
              initialProjectId: _$args.initialProjectId,
            ));
  }
}
