import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:owndo/application/providers/project_providers.dart';
import 'package:owndo/application/providers/task_providers.dart';
import 'package:owndo/domain/entities/task.dart';
import 'package:owndo/presentation/screens/task/task_list_item.dart';
import 'package:owndo/presentation/widgets/empty_state_widget.dart';
import 'package:owndo/presentation/widgets/sync_status_indicator.dart';

class ProjectTaskListScreen extends ConsumerStatefulWidget {
  const ProjectTaskListScreen({super.key, required this.projectId});

  final String projectId;

  @override
  ConsumerState<ProjectTaskListScreen> createState() =>
      _ProjectTaskListScreenState();
}

class _ProjectTaskListScreenState extends ConsumerState<ProjectTaskListScreen> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(projectTasksProvider(widget.projectId));
    final projectAsync = ref.watch(
      projectListProvider.selectAsync(
        (projects) =>
            projects.where((p) => p.id == widget.projectId).firstOrNull,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: projectAsync,
          builder: (context, snap) => Text(snap.data?.name ?? 'Project'),
        ),
        actions: [
          IconButton(
            tooltip: _showCompleted ? 'Hide completed' : 'Show completed',
            icon: Icon(
              _showCompleted ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => setState(() => _showCompleted = !_showCompleted),
          ),
          const SyncStatusIndicator(),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tasks) {
          final visible = _showCompleted
              ? tasks
              : tasks.where((t) => !t.completed).toList();
          if (visible.isEmpty) {
            return const EmptyStateWidget(message: 'No tasks in this project');
          }
          return ListView.builder(
            itemCount: visible.length,
            itemBuilder: (context, index) {
              final task = visible[index];
              return TaskListItem(
                task: task,
                onToggle: () => _toggleTask(task),
                onDelete: () => _deleteTask(task.id),
                onTap: () =>
                    context.push('/tasks/${task.id}/edit', extra: task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/tasks/new?projectId=${widget.projectId}'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _toggleTask(Task task) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    ref.read(taskRepositoryProvider).saveTask(
          task.copyWith(completed: !task.completed, updatedAt: now),
        );
  }

  void _deleteTask(String id) {
    ref.read(taskRepositoryProvider).deleteTask(id);
  }
}
