import 'package:json_annotation/json_annotation.dart';
import 'package:owndo/data/remote/models/subtask_json_model.dart';
import 'package:owndo/domain/entities/task.dart';

part 'task_json_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TaskJsonModel {
  const TaskJsonModel({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    this.projectId,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    this.subtasks = const [],
    this.deadline,
    this.reminderAt,
  });

  final String id;
  final String title;
  final String? description;
  final bool completed;
  final String? projectId;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  @JsonKey(defaultValue: [])
  final List<SubtaskJsonModel> subtasks;
  final int? deadline;
  final int? reminderAt;

  factory TaskJsonModel.fromJson(Map<String, dynamic> json) =>
      _$TaskJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskJsonModelToJson(this);

  Task toDomain() => Task(
        id: id,
        title: title,
        description: description,
        completed: completed,
        projectId: projectId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deleted: deleted,
        deadline: deadline,
        reminderAt: reminderAt,
      );

  factory TaskJsonModel.fromDomain(
    Task task, {
    List<SubtaskJsonModel> subtasks = const [],
  }) =>
      TaskJsonModel(
        id: task.id,
        title: task.title,
        description: task.description,
        completed: task.completed,
        projectId: task.projectId,
        createdAt: task.createdAt,
        updatedAt: task.updatedAt,
        deleted: task.deleted,
        subtasks: subtasks,
        deadline: task.deadline,
        reminderAt: task.reminderAt,
      );
}
