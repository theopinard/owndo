// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubtaskJsonModel _$SubtaskJsonModelFromJson(Map<String, dynamic> json) =>
    SubtaskJsonModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      createdAt: (json['created_at'] as num).toInt(),
      updatedAt: (json['updated_at'] as num).toInt(),
      deleted: json['deleted'] as bool,
    );

Map<String, dynamic> _$SubtaskJsonModelToJson(SubtaskJsonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'title': instance.title,
      'completed': instance.completed,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted': instance.deleted,
    };
