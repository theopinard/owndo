import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:owndo/core/utils/uuid_factory.dart';

part 'subtask.freezed.dart';

@freezed
abstract class Subtask with _$Subtask {
  const factory Subtask({
    required String id,
    required String taskId,
    required String title,
    @Default(0) int currentStep,
    required int createdAt,
    required int updatedAt,
    required bool deleted,
  }) = _Subtask;

  const Subtask._();

  bool isCompleted(int totalSteps) => currentStep >= totalSteps;

  factory Subtask.create({required String taskId, required String title}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return Subtask(
      id: UuidFactory.generate(),
      taskId: taskId,
      title: title,
      currentStep: 0,
      createdAt: now,
      updatedAt: now,
      deleted: false,
    );
  }
}
