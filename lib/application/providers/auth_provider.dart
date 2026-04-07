import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/data/remote/dropbox/dropbox_auth_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
DropboxAuthService dropboxAuth(DropboxAuthRef ref) {
  return DropboxAuthService();
}

@riverpod
Future<bool> isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(dropboxAuthProvider).isAuthenticated();
}
