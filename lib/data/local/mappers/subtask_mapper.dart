import 'package:owndo/data/local/database/app_database.dart';
import 'package:owndo/domain/entities/subtask.dart';

abstract final class SubtaskMapper {
  static Subtask fromRow(SubtasksTableData row) {
    return Subtask(
      id: row.id,
      taskId: row.taskId,
      title: row.title,
      currentStep: row.currentStep,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  static SubtasksTableData toRow(Subtask subtask) {
    return SubtasksTableData(
      id: subtask.id,
      taskId: subtask.taskId,
      title: subtask.title,
      currentStep: subtask.currentStep,
      createdAt: subtask.createdAt,
      updatedAt: subtask.updatedAt,
      deleted: subtask.deleted,
    );
  }
}
