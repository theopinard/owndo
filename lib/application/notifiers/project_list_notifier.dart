import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/application/providers/project_providers.dart';
import 'package:owndo/domain/entities/project.dart';

part 'project_list_notifier.g.dart';

@riverpod
class ProjectListNotifier extends _$ProjectListNotifier {
  @override
  Stream<List<Project>> build() {
    return ref.watch(projectRepositoryProvider).watchProjects();
  }

  Future<void> addProject(String name) async {
    final project = Project.create(name: name.trim());
    await ref.read(projectRepositoryProvider).saveProject(project);
  }

  Future<void> deleteProject(String id) async {
    await ref.read(projectRepositoryProvider).deleteProject(id);
  }
}
