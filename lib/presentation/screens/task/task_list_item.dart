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

  void _showResetSheet(BuildContext context, SubtaskListNotifier notifier) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.replay),
              title: const Text('Reset all subtasks'),
              onTap: () {
                Navigator.pop(ctx);
                notifier.resetAllSubtasks();
              },
            ),
          ],
        ),
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
                onLongPress: subtasks.any((s) => s.currentStep > 0)
                    ? () => _showResetSheet(context, subtaskNotifier)
                    : null,
                child: titleWidget,
              ),
              children: subtasks.map((s) {
                final isComplete = s.isCompleted(task.subtaskSteps);
                final subtaskStyle = isComplete
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      )
                    : null;
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 72, right: 16),
                  leading: task.subtaskSteps == 1
                      ? Checkbox(
                          value: isComplete,
                          onChanged: (_) =>
                              subtaskNotifier.advanceStep(s, task.subtaskSteps),
                        )
                      : _MiniStepIndicator(
                          currentStep: s.currentStep,
                          totalSteps: task.subtaskSteps,
                          onTap: () =>
                              subtaskNotifier.advanceStep(s, task.subtaskSteps),
                        ),
                  title: Text(s.title, style: subtaskStyle),
                );
              }).toList(),
            ),
    );
  }
}

class _MiniStepIndicator extends StatelessWidget {
  const _MiniStepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.onTap,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isComplete = currentStep >= totalSteps;
    final progress = currentStep / totalSteps;
    final activeColor = isComplete ? Colors.green : Theme.of(context).colorScheme.primary;
    final trackColor = Theme.of(context).colorScheme.outline.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: trackColor,
              color: activeColor,
            ),
            if (totalSteps >= 5)
              Text(
                '$currentStep/$totalSteps',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isComplete ? Colors.green : Theme.of(context).colorScheme.onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
