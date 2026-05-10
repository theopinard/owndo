abstract final class AppConstants {
  static const String dropboxRedirectUri = 'owndo://oauth-callback';

  // Fixed port for the Linux localhost OAuth callback.
  // Register http://localhost:8765 as a redirect URI in your Dropbox app console.
  static const int dropboxLinuxCallbackPort = 8765;
  static const String dropboxLinuxRedirectUri =
      'http://localhost:$dropboxLinuxCallbackPort';
  static const String dropboxRootPath = '/apps/todo-app';
  static const String tasksPath = '$dropboxRootPath/tasks';
  static const String projectsPath = '$dropboxRootPath/projects';
  static const String syncMetaPath = '$dropboxRootPath/sync_meta.json';

  static const Duration syncInterval = Duration(seconds: 45);

  // Pending-change entity type constants
  static const String entityTypeTask = 'task';
  static const String entityTypeProject = 'project';
}
