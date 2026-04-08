import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:owndo/application/notifiers/project_list_notifier.dart';
import 'package:owndo/presentation/widgets/adaptive_nav_shell.dart';
import 'package:owndo/presentation/widgets/empty_state_widget.dart';
import 'package:owndo/presentation/widgets/sync_status_indicator.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectListProvider);
    final notifier = ref.read(projectListProvider.notifier);

    return AdaptiveNavShell(
      selectedIndex: 1,
      onDestinationSelected: (i) {
        if (i == 0) context.go('/inbox');
      },
      appBar: AppBar(
        title: const Text('Projects'),
        actions: const [SyncStatusIndicator()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(context, notifier),
        child: const Icon(Icons.add),
      ),
      body: projectsAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (projects) {
          if (projects.isEmpty) {
            return const EmptyStateWidget(
              message: 'No projects yet',
              icon: Icons.folder_outlined,
            );
          }
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Dismissible(
                key: ValueKey(project.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => notifier.deleteProject(project.id),
                child: ListTile(
                  leading: const Icon(Icons.folder_outlined),
                  title: Text(project.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Delete project',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => notifier.deleteProject(project.id),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => context.push('/projects/${project.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddProjectDialog(
    BuildContext context,
    ProjectListNotifier notifier,
  ) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Project'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Project name'),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              notifier.addProject(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                notifier.addProject(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
