import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:owndo/core/utils/uuid_factory.dart';

part 'project.freezed.dart';

@freezed
abstract class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required int createdAt,
    required int updatedAt,
    required bool deleted,
  }) = _Project;

  factory Project.create({required String name}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return Project(
      id: UuidFactory.generate(),
      name: name,
      createdAt: now,
      updatedAt: now,
      deleted: false,
    );
  }
}
