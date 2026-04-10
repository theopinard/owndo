import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:owndo/application/notifiers/task_edit_notifier.dart';
import 'package:owndo/application/providers/project_providers.dart';
import 'package:owndo/application/providers/subtask_providers.dart';
import 'package:owndo/application/providers/task_providers.dart';
import 'package:owndo/domain/entities/task.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  const AddEditTaskScreen({
    super.key,
    this.existingTask,
    this.initialProjectId,
  });

  final Task? existingTask;
  final String? initialProjectId;

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingTask?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.existingTask?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(
      taskEditProvider(
        existing: widget.existingTask,
        initialProjectId: widget.initialProjectId,
      ).notifier,
    );
    final editState = ref.watch(
      taskEditProvider(
        existing: widget.existingTask,
        initialProjectId: widget.initialProjectId,
      ),
    );
    final projectsAsync = ref.watch(projectListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTask == null ? 'New Task' : 'Edit Task'),
        actions: [
          if (widget.existingTask != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete task',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete task?'),
                    content: const Text(
                        'This will permanently remove the task and all its subtasks.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await ref
                      .read(taskRepositoryProvider)
                      .deleteTask(widget.existingTask!.id);
                  if (context.mounted) context.pop();
                }
              },
            ),
          TextButton(
            onPressed: editState.title.trim().isEmpty
                ? null
                : () async {
                    await notifier.save();
                    if (context.mounted) context.pop();
                  },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
              ),
              onChanged: notifier.updateTitle,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: notifier.updateDescription,
              maxLines: 4,
              minLines: 2,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 16),
            projectsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (projects) {
                return DropdownButtonFormField<String?>(
                  initialValue: editState.projectId,
                  decoration: const InputDecoration(
                    labelText: 'Project (optional)',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Inbox'),
                    ),
                    ...projects.map(
                      (p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.name),
                      ),
                    ),
                  ],
                  onChanged: notifier.updateProjectId,
                );
              },
            ),
            const SizedBox(height: 8),
            _DatePickerRow(
              label: 'Deadline',
              icon: Icons.event,
              timestamp: editState.deadline,
              onChanged: notifier.updateDeadline,
            ),
            const SizedBox(height: 8),
            _DatePickerRow(
              label: 'Reminder',
              icon: Icons.notifications_outlined,
              timestamp: editState.reminderAt,
              onChanged: notifier.updateReminderAt,
              includeTime: true,
            ),
            if (widget.existingTask != null) ...[
              const SizedBox(height: 24),
              _SubtaskSection(taskId: widget.existingTask!.id),
            ],
          ],
        ),
      ),
    );
  }
}

class _DatePickerRow extends StatelessWidget {
  const _DatePickerRow({
    required this.label,
    required this.icon,
    required this.timestamp,
    required this.onChanged,
    this.includeTime = false,
  });

  final String label;
  final IconData icon;
  final int? timestamp;
  final ValueChanged<int?> onChanged;
  final bool includeTime;

  String _format(int ts) {
    final d = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    final date =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    if (!includeTime) return date;
    return '$date  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final initial = timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000)
        : now;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (date == null) return;

    DateTime result = date;
    if (includeTime && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initial),
      );
      if (time == null) return;
      result = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
    onChanged(result.millisecondsSinceEpoch ~/ 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            timestamp != null ? _format(timestamp!) : label,
            style: timestamp != null
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).hintColor),
          ),
        ),
        if (timestamp != null)
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => onChanged(null),
            tooltip: 'Clear',
          ),
        TextButton(
          onPressed: () => _pick(context),
          child: Text(timestamp != null ? 'Change' : 'Set'),
        ),
      ],
    );
  }
}

class _SubtaskSection extends ConsumerStatefulWidget {
  const _SubtaskSection({required this.taskId});
  final String taskId;

  @override
  ConsumerState<_SubtaskSection> createState() => _SubtaskSectionState();
}

class _SubtaskSectionState extends ConsumerState<_SubtaskSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    ref
        .read(subtaskListProvider(widget.taskId).notifier)
        .addSubtask(title);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final subtasksAsync =
        ref.watch(subtaskListProvider(widget.taskId));
    final notifier = ref.read(
      subtaskListProvider(widget.taskId).notifier,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subtasks', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        subtasksAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Text('Error: $e'),
          data: (subtasks) => subtasks.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: subtasks
                      .map(
                        (s) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            s.title,
                            style: s.completed
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          leading: Checkbox(
                            value: s.completed,
                            onChanged: (_) => notifier.toggleComplete(s),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => notifier.deleteSubtask(s),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Add subtask…',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.add),
              onPressed: _submit,
            ),
          ],
        ),
      ],
    );
  }
}
