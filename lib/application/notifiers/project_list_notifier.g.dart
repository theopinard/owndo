// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProjectListNotifier)
final projectListProvider = ProjectListNotifierProvider._();

final class ProjectListNotifierProvider
    extends $StreamNotifierProvider<ProjectListNotifier, List<Project>> {
  ProjectListNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'projectListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$projectListNotifierHash();

  @$internal
  @override
  ProjectListNotifier create() => ProjectListNotifier();
}

String _$projectListNotifierHash() =>
    r'd270dbb7a1c56d0476a122d5c68f59abb4e1a1a8';

abstract class _$ProjectListNotifier extends $StreamNotifier<List<Project>> {
  Stream<List<Project>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Project>>, List<Project>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Project>>, List<Project>>,
        AsyncValue<List<Project>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
