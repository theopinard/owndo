import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:owndo/core/utils/uuid_factory.dart';

part 'subtask.freezed.dart';

@freezed
class Subtask with _$Subtask {
  const factory Subtask({
    required String id,
    required String taskId,
    required String title,
    required bool completed,
    required int createdAt,
    required int updatedAt,
    required bool deleted,
  }) = _Subtask;

  factory Subtask.create({required String taskId, required String title}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return Subtask(
      id: UuidFactory.generate(),
      taskId: taskId,
      title: title,
      completed: false,
      createdAt: now,
      updatedAt: now,
      deleted: false,
    );
  }
}
