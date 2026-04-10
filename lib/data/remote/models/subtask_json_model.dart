import 'package:json_annotation/json_annotation.dart';
import 'package:owndo/domain/entities/subtask.dart';

part 'subtask_json_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SubtaskJsonModel {
  const SubtaskJsonModel({
    required this.id,
    required this.taskId,
    required this.title,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });

  final String id;
  final String taskId;
  final String title;
  final bool completed;
  final int createdAt;
  final int updatedAt;
  final bool deleted;

  factory SubtaskJsonModel.fromJson(Map<String, dynamic> json) =>
      _$SubtaskJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubtaskJsonModelToJson(this);

  Subtask toDomain() => Subtask(
        id: id,
        taskId: taskId,
        title: title,
        completed: completed,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deleted: deleted,
      );

  factory SubtaskJsonModel.fromDomain(Subtask subtask) => SubtaskJsonModel(
        id: subtask.id,
        taskId: subtask.taskId,
        title: subtask.title,
        completed: subtask.completed,
        createdAt: subtask.createdAt,
        updatedAt: subtask.updatedAt,
        deleted: subtask.deleted,
      );
}
