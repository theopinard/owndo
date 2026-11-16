import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owndo/domain/entities/task.dart';
import 'package:owndo/presentation/screens/task/task_list_item.dart';
import 'package:owndo/presentation/widgets/empty_state_widget.dart';

/// Shared list presentation; screens own navigation and task actions.
class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    required this.showCompleted,
    required this.emptyMessage,
    required this.onToggle,
    required this.onDelete,
    required this.onOpen,
  });

  final AsyncValue<List<Task>> tasks;
  final bool showCompleted;
  final String emptyMessage;
  final ValueChanged<Task> onToggle;
  final ValueChanged<Task> onDelete;
  final ValueChanged<Task> onOpen;

  @override
  Widget build(BuildContext context) {
    return tasks.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (items) {
        final visible = showCompleted
            ? items
            : items.where((task) => !task.completed).toList();
        if (visible.isEmpty) {
          return EmptyStateWidget(message: emptyMessage);
        }
        return ListView.builder(
          itemCount: visible.length,
          itemBuilder: (context, index) {
            final task = visible[index];
            return TaskListItem(
              task: task,
              onToggle: () => onToggle(task),
              onDelete: () => onDelete(task),
              onTap: () => onOpen(task),
            );
          },
        );
      },
    );
  }
}
