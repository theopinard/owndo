// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectRepository)
final projectRepositoryProvider = ProjectRepositoryProvider._();

final class ProjectRepositoryProvider extends $FunctionalProvider<
    ProjectRepository,
    ProjectRepository,
    ProjectRepository> with $Provider<ProjectRepository> {
  ProjectRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'projectRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$projectRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProjectRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProjectRepository create(Ref ref) {
    return projectRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectRepository>(value),
    );
  }
}

String _$projectRepositoryHash() => r'49ec8c771b041c30e39e62c1b7f4bf82b19b538f';

@ProviderFor(projectList)
final projectListProvider = ProjectListProvider._();

final class ProjectListProvider extends $FunctionalProvider<
        AsyncValue<List<Project>>, List<Project>, Stream<List<Project>>>
    with $FutureModifier<List<Project>>, $StreamProvider<List<Project>> {
  ProjectListProvider._()
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
  String debugGetCreateSourceHash() => _$projectListHash();

  @$internal
  @override
  $StreamProviderElement<List<Project>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Project>> create(Ref ref) {
    return projectList(ref);
  }
}

String _$projectListHash() => r'eb33eddd113a8fc62612dd782011c98d4a41fe99';
