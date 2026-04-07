import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/domain/entities/project.dart';

abstract final class ProjectMapper {
  static Project fromRow(ProjectsTableData row) {
    return Project(
      id: row.id,
      name: row.name,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  static ProjectsTableData toRow(Project project) {
    return ProjectsTableData(
      id: project.id,
      name: project.name,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
      deleted: project.deleted,
    );
  }
}
