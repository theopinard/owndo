import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owndo/application/providers/subtask_providers.dart';
import 'package:owndo/domain/entities/task.dart';

class TaskListItem extends ConsumerWidget {
  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtasks =
        ref.watch(subtaskListNotifierProvider(task.id)).valueOrNull ?? [];
    final subtaskNotifier =
        ref.read(subtaskListNotifierProvider(task.id).notifier);

    final titleStyle = task.completed
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: subtasks.isEmpty
          ? ListTile(
              leading: Checkbox(
                value: task.completed,
                onChanged: (_) => onToggle(),
              ),
              title: Text(task.title, style: titleStyle),
              onTap: onTap,
            )
          : ExpansionTile(
              leading: Checkbox(
                value: task.completed,
                onChanged: (_) => onToggle(),
              ),
              title: GestureDetector(
                onTap: onTap,
                child: Text(task.title, style: titleStyle),
              ),
              children: subtasks.map((s) {
                final subtaskStyle = s.completed
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      )
                    : null;
                return ListTile(
                  dense: true,
                  contentPadding:
                      const EdgeInsets.only(left: 72, right: 16),
                  leading: Checkbox(
                    value: s.completed,
                    onChanged: (_) => subtaskNotifier.toggleComplete(s),
                  ),
                  title: Text(s.title, style: subtaskStyle),
                );
              }).toList(),
            ),
    );
  }
}
