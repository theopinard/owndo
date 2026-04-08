import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/application/providers/auth_provider.dart';
import 'package:owndo/domain/entities/task.dart';
import 'package:owndo/presentation/screens/auth/dropbox_login_screen.dart';
import 'package:owndo/presentation/screens/inbox/inbox_screen.dart';
import 'package:owndo/presentation/screens/projects/project_list_screen.dart';
import 'package:owndo/presentation/screens/projects/project_task_list_screen.dart';
import 'package:owndo/presentation/screens/task/add_edit_task_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authAsync = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/inbox',
    redirect: (context, state) {
      final isLoggedIn = authAsync.asData?.value ?? false;
      final onLoginPage = state.matchedLocation == '/login';

      if (!isLoggedIn && !onLoginPage) return '/login';
      if (isLoggedIn && onLoginPage) return '/inbox';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const DropboxLoginScreen(),
      ),
      GoRoute(
        path: '/inbox',
        builder: (context, state) => const InboxScreen(),
      ),
      GoRoute(
        path: '/projects',
        builder: (context, state) => const ProjectListScreen(),
      ),
      GoRoute(
        path: '/projects/:id',
        builder: (context, state) =>
            ProjectTaskListScreen(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tasks/new',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'];
          return AddEditTaskScreen(initialProjectId: projectId);
        },
      ),
      GoRoute(
        path: '/tasks/:id/edit',
        builder: (context, state) {
          final task = state.extra as Task;
          return AddEditTaskScreen(existingTask: task);
        },
      ),
    ],
  );
}
