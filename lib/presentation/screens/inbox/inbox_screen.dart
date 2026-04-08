import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:owndo/application/notifiers/task_list_notifier.dart';
import 'package:owndo/application/providers/auth_provider.dart';
import 'package:owndo/presentation/screens/task/task_list_item.dart';
import 'package:owndo/presentation/widgets/adaptive_nav_shell.dart';
import 'package:owndo/presentation/widgets/empty_state_widget.dart';
import 'package:owndo/presentation/widgets/sync_status_indicator.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListProvider);
    final notifier = ref.read(taskListProvider.notifier);

    return AdaptiveNavShell(
      selectedIndex: 0,
      onDestinationSelected: (i) {
        if (i == 1) context.go('/projects');
      },
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            tooltip: _showCompleted ? 'Hide completed' : 'Show completed',
            icon: Icon(
              _showCompleted ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => setState(() => _showCompleted = !_showCompleted),
          ),
          const SyncStatusIndicator(),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(dropboxAuthProvider).signOut();
              ref.invalidate(isAuthenticatedProvider);
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/new'),
        child: const Icon(Icons.add),
      ),
      body: tasksAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tasks) {
          final visible = _showCompleted
              ? tasks
              : tasks.where((t) => !t.completed).toList();
          if (visible.isEmpty) {
            return const EmptyStateWidget(message: 'No tasks — add one below');
          }
          return ListView.builder(
            itemCount: visible.length,
            itemBuilder: (context, index) {
              final task = visible[index];
              return TaskListItem(
                task: task,
                onToggle: () => notifier.toggleComplete(task),
                onDelete: () {
                  notifier.deleteTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('"${task.title}" deleted')),
                  );
                },
                onTap: () => context.push('/tasks/${task.id}/edit', extra: task),
              );
            },
          );
        },
      ),
    );
  }
}
