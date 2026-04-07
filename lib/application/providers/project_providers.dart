import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/application/providers/database_provider.dart';
import 'package:owndo/data/repositories/project_repository_impl.dart';
import 'package:owndo/domain/entities/project.dart';
import 'package:owndo/domain/repositories/project_repository.dart';

part 'project_providers.g.dart';

@riverpod
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProjectRepositoryImpl(db.projectsDao);
}

@riverpod
Stream<List<Project>> projectList(ProjectListRef ref) {
  return ref.watch(projectRepositoryProvider).watchProjects();
}
