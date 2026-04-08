import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/data/remote/dropbox/dropbox_auth_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
DropboxAuthService dropboxAuth(Ref ref) {
  return DropboxAuthService();
}

@riverpod
Future<bool> isAuthenticated(Ref ref) {
  return ref.watch(dropboxAuthProvider).isAuthenticated();
}
