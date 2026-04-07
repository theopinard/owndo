import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:owndo/core/errors.dart';

/// Raw HTTP client for the Dropbox API.
/// All methods require a valid [accessToken].
class DropboxApiClient {
  DropboxApiClient({http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final http.Client _client;

  static const _contentBase = 'https://content.dropboxapi.com/2/files';
  static const _apiBase = 'https://api.dropboxapi.com/2/files';

  /// Upload [content] (UTF-8 string) to [path] in Dropbox.
  /// Uses "overwrite" mode.
  Future<void> upload({
    required String accessToken,
    required String path,
    required String content,
  }) async {
    final arg = jsonEncode({'path': path, 'mode': 'overwrite'});
    final response = await _client.post(
      Uri.parse('$_contentBase/upload'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Dropbox-API-Arg': arg,
        'Content-Type': 'application/octet-stream',
      },
      body: utf8.encode(content),
    );
    _checkStatus(response, 'upload');
  }

  /// Download the file at [path] and return its content as a string.
  Future<String> download({
    required String accessToken,
    required String path,
  }) async {
    final arg = jsonEncode({'path': path});
    final response = await _client.post(
      Uri.parse('$_contentBase/download'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Dropbox-API-Arg': arg,
      },
    );
    if (response.statusCode == 409) {
      // path_not_found — file doesn't exist
      throw const NetworkException('File not found');
    }
    _checkStatus(response, 'download');
    return utf8.decode(response.bodyBytes);
  }

  /// List all file names (not paths) in the folder at [folderPath].
  Future<List<String>> listFolder({
    required String accessToken,
    required String folderPath,
  }) async {
    final response = await _client.post(
      Uri.parse('$_apiBase/list_folder'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'path': folderPath}),
    );

    if (response.statusCode == 409) {
      // Folder doesn't exist yet — treat as empty
      return [];
    }
    _checkStatus(response, 'list_folder');

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final entries = body['entries'] as List<dynamic>;
    return entries
        .whereType<Map<String, dynamic>>()
        .where((e) => e['.tag'] == 'file')
        .map((e) => (e['name'] as String))
        .toList();
  }

  /// Delete the file at [path].
  Future<void> delete({
    required String accessToken,
    required String path,
  }) async {
    final response = await _client.post(
      Uri.parse('$_apiBase/delete_v2'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'path': path}),
    );
    if (response.statusCode == 409) return; // already deleted — OK
    _checkStatus(response, 'delete');
  }

  /// Returns true if the file at [path] exists.
  Future<bool> fileExists({
    required String accessToken,
    required String path,
  }) async {
    final response = await _client.post(
      Uri.parse('$_apiBase/get_metadata'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'path': path}),
    );
    if (response.statusCode == 409) return false;
    _checkStatus(response, 'get_metadata');
    return true;
  }

  void _checkStatus(http.Response response, String operation) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw NetworkException(
      'Dropbox $operation failed (${response.statusCode}): ${response.body}',
    );
  }
}
