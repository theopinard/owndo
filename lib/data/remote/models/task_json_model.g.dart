// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskJsonModel _$TaskJsonModelFromJson(Map<String, dynamic> json) =>
    TaskJsonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: json['completed'] as bool,
      projectId: json['project_id'] as String?,
      createdAt: (json['created_at'] as num).toInt(),
      updatedAt: (json['updated_at'] as num).toInt(),
      deleted: json['deleted'] as bool,
      subtasks: (json['subtasks'] as List<dynamic>?)
              ?.map((e) => SubtaskJsonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TaskJsonModelToJson(TaskJsonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'completed': instance.completed,
      'project_id': instance.projectId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted': instance.deleted,
      'subtasks': instance.subtasks,
    };
