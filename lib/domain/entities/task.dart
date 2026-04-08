import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:owndo/core/utils/uuid_factory.dart';

part 'task.freezed.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    required bool completed,
    String? projectId,
    required int createdAt,
    required int updatedAt,
    required bool deleted,
  }) = _Task;

  factory Task.create({
    required String title,
    String? description,
    String? projectId,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return Task(
      id: UuidFactory.generate(),
      title: title,
      description: description,
      completed: false,
      projectId: projectId,
      createdAt: now,
      updatedAt: now,
      deleted: false,
    );
  }
}
