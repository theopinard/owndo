import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/data/remote/dropbox/dropbox_auth_service.dart';

part 'auth_provider.g.dart';

enum AppAccessMode { unknown, offline, dropbox }

@Riverpod(keepAlive: true)
DropboxAuthService dropboxAuth(Ref ref) {
  return DropboxAuthService();
}

@Riverpod(keepAlive: true)
Future<bool> isAuthenticated(Ref ref) {
  return ref.watch(dropboxAuthProvider).isAuthenticated();
}

@Riverpod(keepAlive: true)
Future<AppAccessMode> appAccessMode(Ref ref) async {
  final auth = ref.watch(dropboxAuthProvider);
  if (await auth.isAuthenticated()) return AppAccessMode.dropbox;
  if (await auth.isOfflineModeEnabled()) return AppAccessMode.offline;
  return AppAccessMode.unknown;
}
