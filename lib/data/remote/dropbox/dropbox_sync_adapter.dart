import 'package:owndo/core/constants.dart';
import 'package:owndo/data/remote/dropbox/dropbox_api_client.dart';
import 'package:owndo/data/remote/dropbox/dropbox_auth_service.dart';
import 'package:owndo/domain/sync/sync_adapter.dart';

/// Implements [SyncAdapter] using the Dropbox API.
/// All paths are app-relative (e.g. '/tasks/abc.json') and are prefixed
/// with [AppConstants.dropboxRootPath] before being sent to Dropbox.
class DropboxSyncAdapter implements SyncAdapter {
  const DropboxSyncAdapter(this._auth, this._api);

  final DropboxAuthService _auth;
  final DropboxApiClient _api;

  @override
  Future<void> upload(String path, String content) async {
    final token = await _auth.getValidAccessToken();
    await _api.upload(
      accessToken: token,
      path: _absolutePath(path),
      content: content,
    );
  }

  @override
  Future<String> download(String path) async {
    final token = await _auth.getValidAccessToken();
    return _api.download(accessToken: token, path: _absolutePath(path));
  }

  @override
  Future<List<String>> listFiles(String directoryPath) async {
    final token = await _auth.getValidAccessToken();
    return _api.listFolder(
      accessToken: token,
      folderPath: _absolutePath(directoryPath),
    );
  }

  @override
  Future<void> delete(String path) async {
    final token = await _auth.getValidAccessToken();
    await _api.delete(accessToken: token, path: _absolutePath(path));
  }

  @override
  Future<bool> fileExists(String path) async {
    final token = await _auth.getValidAccessToken();
    return _api.fileExists(accessToken: token, path: _absolutePath(path));
  }

  String _absolutePath(String relativePath) {
    final rel = relativePath.startsWith('/') ? relativePath : '/$relativePath';
    return '${AppConstants.dropboxRootPath}$rel';
  }
}
