import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owndo/application/providers/subtask_providers.dart';
import 'package:owndo/domain/entities/task.dart';

// Returns a human-friendly relative label for a deadline timestamp.
String _deadlineLabel(int deadline) {
  final now = DateTime.now();
  final d = DateTime.fromMillisecondsSinceEpoch(deadline * 1000);
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(d.year, d.month, d.day);
  final diff = due.difference(today).inDays;

  if (diff < -1) return '${-diff} days ago';
  if (diff == -1) return 'Yesterday';
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff < 7) return _weekday(d.weekday);
  if (d.year == now.year) return '${_month(d.month)} ${d.day}';
  return '${_month(d.month)} ${d.day}, ${d.year}';
}

Color _deadlineColor(int deadline, ColorScheme cs) {
  final now = DateTime.now();
  final d = DateTime.fromMillisecondsSinceEpoch(deadline * 1000);
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(d.year, d.month, d.day);
  final diff = due.difference(today).inDays;
  if (diff < 0) return cs.error;
  if (diff == 0) return Colors.orange;
  if (diff == 1) return cs.primary;
  return cs.outline;
}

String _weekday(int d) =>
    const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1];

String _month(int m) => const [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ][m - 1];

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

  Widget _deadlineBadge(BuildContext context) {
    if (task.deadline == null || task.completed) return const SizedBox.shrink();
    final color = _deadlineColor(task.deadline!, Theme.of(context).colorScheme);
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            _deadlineLabel(task.deadline!),
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtasks =
        ref.watch(subtaskListProvider(task.id)).asData?.value ?? [];
    final subtaskNotifier = ref.read(subtaskListProvider(task.id).notifier);

    final titleStyle = task.completed
        ? TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Theme.of(context).colorScheme.outline,
          )
        : null;

    final titleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(task.title, style: titleStyle),
        _deadlineBadge(context),
      ],
    );

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
              title: titleWidget,
              onTap: onTap,
            )
          : ExpansionTile(
              leading: Checkbox(
                value: task.completed,
                onChanged: (_) => onToggle(),
              ),
              title: GestureDetector(
                onTap: onTap,
                child: titleWidget,
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
                  contentPadding: const EdgeInsets.only(left: 72, right: 16),
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
