import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/application/providers/notification_provider.dart';
import 'package:owndo/application/providers/task_providers.dart';
import 'package:owndo/domain/entities/task.dart';

part 'task_edit_notifier.freezed.dart';
part 'task_edit_notifier.g.dart';

@freezed
abstract class TaskEditState with _$TaskEditState {
  const factory TaskEditState({
    required String title,
    String? description,
    String? projectId,
    required bool isNew,
    String? existingTaskId,
    int? deadline,
    int? reminderAt,
  }) = _TaskEditState;
}

@riverpod
class TaskEditNotifier extends _$TaskEditNotifier {
  @override
  TaskEditState build({Task? existing, String? initialProjectId}) {
    return TaskEditState(
      title: existing?.title ?? '',
      description: existing?.description,
      projectId: existing?.projectId ?? initialProjectId,
      isNew: existing == null,
      existingTaskId: existing?.id,
      deadline: existing?.deadline,
      reminderAt: existing?.reminderAt,
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDeadline(int? deadline) => state = state.copyWith(deadline: deadline);
  void updateReminderAt(int? reminderAt) =>
      state = state.copyWith(reminderAt: reminderAt);

  void updateDescription(String description) {
    state = state.copyWith(
      description: description.trim().isEmpty ? null : description,
    );
  }

  void updateProjectId(String? projectId) {
    state = state.copyWith(projectId: projectId);
  }

  Future<void> save() async {
    final repo = ref.read(taskRepositoryProvider);
    final notifications = ref.read(notificationServiceProvider);
    late final Task saved;
    if (state.isNew) {
      saved = Task.create(
        title: state.title.trim(),
        description: state.description,
        projectId: state.projectId,
        deadline: state.deadline,
        reminderAt: state.reminderAt,
      );
      await repo.saveTask(saved);
    } else {
      final existing = await repo.getTaskById(state.existingTaskId!);
      if (existing == null) return;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      saved = existing.copyWith(
        title: state.title.trim(),
        description: state.description,
        projectId: state.projectId,
        deadline: state.deadline,
        reminderAt: state.reminderAt,
        updatedAt: now,
      );
      await repo.saveTask(saved);
    }
    if (saved.reminderAt != null) {
      await notifications.scheduleReminder(saved);
    } else {
      await notifications.cancelReminder(saved.id);
    }
  }
}
