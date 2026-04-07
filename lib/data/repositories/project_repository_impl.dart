import 'package:owndo/core/constants.dart';
import 'package:owndo/core/utils/uuid_factory.dart';
import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/data/local/database/daos/projects_dao.dart';
import 'package:owndo/data/local/mappers/project_mapper.dart';
import 'package:owndo/domain/entities/project.dart';
import 'package:owndo/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl(this._projectsDao);

  final ProjectsDao _projectsDao;

  @override
  Stream<List<Project>> watchProjects() {
    return _projectsDao
        .watchProjects()
        .map((rows) => rows.map(ProjectMapper.fromRow).toList());
  }

  @override
  Future<Project?> getProjectById(String id) async {
    final row = await _projectsDao.getProjectById(id);
    return row == null ? null : ProjectMapper.fromRow(row);
  }

  @override
  Future<void> saveProject(Project project) async {
    final existing = await _projectsDao.getProjectById(project.id);
    final operation = existing == null ? 'create' : 'update';
    final change = PendingChangesTableCompanion.insert(
      id: UuidFactory.generate(),
      entityType: AppConstants.entityTypeProject,
      entityId: project.id,
      operation: operation,
      updatedAt: project.updatedAt,
    );
    await _projectsDao.upsertProjectWithPendingChange(
      ProjectMapper.toRow(project),
      change,
    );
  }

  @override
  Future<void> deleteProject(String projectId) async {
    final existing = await _projectsDao.getProjectById(projectId);
    if (existing == null) return;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final deleted = ProjectMapper.fromRow(existing).copyWith(
      deleted: true,
      updatedAt: now,
    );
    final change = PendingChangesTableCompanion.insert(
      id: UuidFactory.generate(),
      entityType: AppConstants.entityTypeProject,
      entityId: projectId,
      operation: 'delete',
      updatedAt: now,
    );
    await _projectsDao.upsertProjectWithPendingChange(
      ProjectMapper.toRow(deleted),
      change,
    );
  }
}
