// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectJsonModel _$ProjectJsonModelFromJson(Map<String, dynamic> json) =>
    ProjectJsonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: (json['created_at'] as num).toInt(),
      updatedAt: (json['updated_at'] as num).toInt(),
      deleted: json['deleted'] as bool,
    );

Map<String, dynamic> _$ProjectJsonModelToJson(ProjectJsonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted': instance.deleted,
    };
