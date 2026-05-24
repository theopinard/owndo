import 'package:json_annotation/json_annotation.dart';
import 'package:owndo/domain/entities/subtask.dart';

part 'subtask_json_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SubtaskJsonModel {
  const SubtaskJsonModel({
    required this.id,
    required this.taskId,
    required this.title,
    this.currentStep = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });

  final String id;
  final String taskId;
  final String title;
  @JsonKey(defaultValue: 0)
  final int currentStep;
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
        currentStep: currentStep,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deleted: deleted,
      );

  factory SubtaskJsonModel.fromDomain(Subtask subtask) => SubtaskJsonModel(
        id: subtask.id,
        taskId: subtask.taskId,
        title: subtask.title,
        currentStep: subtask.currentStep,
        createdAt: subtask.createdAt,
        updatedAt: subtask.updatedAt,
        deleted: subtask.deleted,
      );
}
