// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubtaskListNotifier)
final subtaskListProvider = SubtaskListNotifierFamily._();

final class SubtaskListNotifierProvider
    extends $StreamNotifierProvider<SubtaskListNotifier, List<Subtask>> {
  SubtaskListNotifierProvider._(
      {required SubtaskListNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'subtaskListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$subtaskListNotifierHash();

  @override
  String toString() {
    return r'subtaskListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SubtaskListNotifier create() => SubtaskListNotifier();

  @override
  bool operator ==(Object other) {
    return other is SubtaskListNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subtaskListNotifierHash() =>
    r'4f35d37d1aa944ef68b9080074d17e38a25a7213';

final class SubtaskListNotifierFamily extends $Family
    with
        $ClassFamilyOverride<SubtaskListNotifier, AsyncValue<List<Subtask>>,
            List<Subtask>, Stream<List<Subtask>>, String> {
  SubtaskListNotifierFamily._()
      : super(
          retry: null,
          name: r'subtaskListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SubtaskListNotifierProvider call(
    String taskId,
  ) =>
      SubtaskListNotifierProvider._(argument: taskId, from: this);

  @override
  String toString() => r'subtaskListProvider';
}

abstract class _$SubtaskListNotifier extends $StreamNotifier<List<Subtask>> {
  late final _$args = ref.$arg as String;
  String get taskId => _$args;

  Stream<List<Subtask>> build(
    String taskId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Subtask>>, List<Subtask>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Subtask>>, List<Subtask>>,
        AsyncValue<List<Subtask>>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
