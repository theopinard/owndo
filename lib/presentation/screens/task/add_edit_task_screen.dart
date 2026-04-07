import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:owndo/application/notifiers/task_edit_notifier.dart';
import 'package:owndo/application/providers/project_providers.dart';
import 'package:owndo/application/providers/subtask_providers.dart';
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
      taskEditNotifierProvider(
        existing: widget.existingTask,
        initialProjectId: widget.initialProjectId,
      ).notifier,
    );
    final editState = ref.watch(
      taskEditNotifierProvider(
        existing: widget.existingTask,
        initialProjectId: widget.initialProjectId,
      ),
    );
    final projectsAsync = ref.watch(projectListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTask == null ? 'New Task' : 'Edit Task'),
        actions: [
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
        .read(subtaskListNotifierProvider(widget.taskId).notifier)
        .addSubtask(title);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final subtasksAsync =
        ref.watch(subtaskListNotifierProvider(widget.taskId));
    final notifier = ref.read(
      subtaskListNotifierProvider(widget.taskId).notifier,
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
