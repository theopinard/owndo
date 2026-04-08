import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

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
    if (state.isNew) {
      final task = Task.create(
        title: state.title.trim(),
        description: state.description,
        projectId: state.projectId,
      );
      await repo.saveTask(task);
    } else {
      final existing = await repo.getTaskById(state.existingTaskId!);
      if (existing == null) return;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await repo.saveTask(
        existing.copyWith(
          title: state.title.trim(),
          description: state.description,
          projectId: state.projectId,
          updatedAt: now,
        ),
      );
    }
  }
}
