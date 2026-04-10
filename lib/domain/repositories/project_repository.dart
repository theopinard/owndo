import 'package:owndo/domain/entities/project.dart';

abstract interface class ProjectRepository {
  Stream<List<Project>> watchProjects();
  Future<Project?> getProjectById(String id);
  Future<void> saveProject(Project project);
  Future<void> deleteProject(String projectId);
}
