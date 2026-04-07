import 'package:json_annotation/json_annotation.dart';
import 'package:owndo/domain/entities/project.dart';

part 'project_json_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProjectJsonModel {
  const ProjectJsonModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });

  final String id;
  final String name;
  final int createdAt;
  final int updatedAt;
  final bool deleted;

  factory ProjectJsonModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectJsonModelToJson(this);

  Project toDomain() => Project(
        id: id,
        name: name,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deleted: deleted,
      );

  factory ProjectJsonModel.fromDomain(Project project) => ProjectJsonModel(
        id: project.id,
        name: project.name,
        createdAt: project.createdAt,
        updatedAt: project.updatedAt,
        deleted: project.deleted,
      );
}
