import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:owndo/core/constants.dart';
import 'package:owndo/core/env.dart';
import 'package:owndo/core/errors.dart';

class _FileTokenStorage {
  _FileTokenStorage();

  File? _file;

  Future<File> _getFile() async {
    if (_file != null) return _file!;
    final dir = await getApplicationSupportDirectory();
    _file = File('${dir.path}/auth_tokens.json');
    return _file!;
  }

  Future<Map<String, String>> _readAll() async {
    final file = await _getFile();
    if (!file.existsSync()) return {};
    final content = await file.readAsString();
    if (content.isEmpty) return {};
    return Map<String, String>.from(jsonDecode(content) as Map);
  }

  Future<void> _writeAll(Map<String, String> data) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(data));
  }

  Future<String?> read({required String key}) async {
    final data = await _readAll();
    return data[key];
  }

  Future<void> write({required String key, required String value}) async {
    final data = await _readAll();
    data[key] = value;
    await _writeAll(data);
  }

  Future<void> delete({required String key}) async {
    final data = await _readAll();
    data.remove(key);
    await _writeAll(data);
  }
}

class _TokenStorage {
  _TokenStorage()
      : _isDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows,
        _secureStorage = const FlutterSecureStorage(),
        _fileStorage = _FileTokenStorage();

  final bool _isDesktop;
  final FlutterSecureStorage _secureStorage;
  final _FileTokenStorage _fileStorage;

  Future<String?> read({required String key}) =>
      _isDesktop ? _fileStorage.read(key: key) : _secureStorage.read(key: key);

  Future<void> write({required String key, required String value}) =>
      _isDesktop
          ? _fileStorage.write(key: key, value: value)
          : _secureStorage.write(key: key, value: value);

  Future<void> delete({required String key}) => _isDesktop
      ? _fileStorage.delete(key: key)
      : _secureStorage.delete(key: key);
}

class DropboxAuthService {
  DropboxAuthService({
    http.Client? httpClient,
  })  : _storage = _TokenStorage(),
        _client = httpClient ?? http.Client();

  final _TokenStorage _storage;
  final http.Client _client;

  static const _accessTokenKey = 'dropbox_access_token';
  static const _refreshTokenKey = 'dropbox_refresh_token';
  static const _expiresAtKey = 'dropbox_token_expires_at';

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> authenticate() async {
    if (Platform.isLinux || Platform.isMacOS) {
      await _authenticateDesktop();
    } else {
      await _authenticateMobile();
    }
  }

  // ── Desktop: localhost HTTP server callback (Linux & macOS) ────────────────

  Future<void> _authenticateDesktop() async {
    const redirectUri = AppConstants.dropboxLinuxRedirectUri;
    final pkce = _generatePkce();

    final server = await HttpServer.bind(
        InternetAddress.loopbackIPv4, AppConstants.dropboxLinuxCallbackPort);

    if (!await _launchAuthUrl(redirectUri: redirectUri, pkce: pkce)) {
      await server.close(force: true);
      throw const AuthException('Could not open browser for Dropbox login');
    }

    try {
      final callbackUri = await _waitForCallback(server);
      await _handleCallback(callbackUri, pkce: pkce, redirectUri: redirectUri);
    } finally {
      await server.close(force: true);
    }
  }

  Future<Uri> _waitForCallback(HttpServer server) async {
    final completer = Completer<Uri>();

    server.listen((req) async {
      req.response
        ..statusCode = 200
        ..headers.contentType = ContentType.html
        ..write(
          '<html><body style="font-family:sans-serif;padding:2rem">'
          '<h2>&#10003; Connected to Dropbox</h2>'
          '<p>You can close this tab and return to OwnDo.</p>'
          '</body></html>',
        );
      await req.response.close();
      if (!completer.isCompleted) completer.complete(req.uri);
    });

    return completer.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () =>
          throw const AuthException('Dropbox login timed out (5 min)'),
    );
  }

  // ── Mobile: deep link callback (iOS / Android) ────────────────────────────

  Future<void> _authenticateMobile() async {
    const redirectUri = AppConstants.dropboxRedirectUri;
    final pkce = _generatePkce();

    // Listen for the deep link BEFORE opening the browser.
    final appLinks = AppLinks();
    final linkFuture = appLinks.uriLinkStream
        .where((uri) => uri.scheme == 'owndo')
        .first
        .timeout(
          const Duration(minutes: 5),
          onTimeout: () =>
              throw const AuthException('Dropbox login timed out (5 min)'),
        );

    if (!await _launchAuthUrl(redirectUri: redirectUri, pkce: pkce)) {
      throw const AuthException('Could not open browser for Dropbox login');
    }

    final callbackUri = await linkFuture;
    await _handleCallback(callbackUri, pkce: pkce, redirectUri: redirectUri);
  }

  // ── Shared OAuth helpers ──────────────────────────────────────────────────

  Future<bool> _launchAuthUrl({
    required String redirectUri,
    required ({String verifier, String challenge, String state}) pkce,
  }) {
    final authUrl = Uri.https('www.dropbox.com', '/oauth2/authorize', {
      'client_id': Env.dropboxAppKey,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'code_challenge': pkce.challenge,
      'code_challenge_method': 'S256',
      'state': pkce.state,
      'token_access_type': 'offline',
    });
    return launchUrl(authUrl, mode: LaunchMode.externalApplication);
  }

  Future<void> _handleCallback(
    Uri callbackUri, {
    required ({String verifier, String challenge, String state}) pkce,
    required String redirectUri,
  }) async {
    final returnedState = callbackUri.queryParameters['state'];
    if (returnedState != pkce.state) {
      throw const AuthException('OAuth2 state mismatch — possible CSRF attack');
    }

    final code = callbackUri.queryParameters['code'];
    if (code == null) {
      final error = callbackUri.queryParameters['error'] ?? 'unknown';
      throw AuthException('Dropbox auth denied: $error');
    }

    await _exchangeCodeForTokens(
        code: code, verifier: pkce.verifier, redirectUri: redirectUri);
  }

  // ── Shared ─────────────────────────────────────────────────────────────────

  Future<void> _exchangeCodeForTokens({
    required String code,
    required String verifier,
    required String redirectUri,
  }) async {
    final response = await _client.post(
      Uri.parse('https://api.dropboxapi.com/oauth2/token'),
      body: {
        'code': code,
        'grant_type': 'authorization_code',
        'client_id': Env.dropboxAppKey,
        'client_secret': Env.dropboxAppSecret,
        'redirect_uri': redirectUri,
        'code_verifier': verifier,
      },
    );

    if (response.statusCode != 200) {
      throw AuthException('Token exchange failed: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    await _storeTokens(body);
  }

  /// Returns a valid access token, refreshing silently if expired.
  Future<String> getValidAccessToken() async {
    final expiresAtStr = await _storage.read(key: _expiresAtKey);
    final expiresAt = expiresAtStr != null ? int.tryParse(expiresAtStr) : null;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Refresh 60 seconds before expiry to avoid edge cases.
    if (expiresAt != null && now < expiresAt - 60) {
      final token = await _storage.read(key: _accessTokenKey);
      if (token != null) return token;
    }

    return _refreshAccessToken();
  }

  Future<String> _refreshAccessToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken == null) {
      throw const AuthException('No refresh token — user must re-authenticate');
    }

    final response = await _client.post(
      Uri.parse('https://api.dropboxapi.com/oauth2/token'),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': Env.dropboxAppKey,
        'client_secret': Env.dropboxAppSecret,
      },
    );

    if (response.statusCode != 200) {
      throw AuthException('Token refresh failed: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    await _storeTokens(body);

    return body['access_token'] as String;
  }

  Future<void> _storeTokens(Map<String, dynamic> body) async {
    final accessToken = body['access_token'] as String;
    final expiresIn = body['expires_in'] as int? ?? 14400;
    final refreshToken = body['refresh_token'] as String?;

    final expiresAt =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) + expiresIn;

    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _expiresAtKey, value: expiresAt.toString());
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<void> signOut() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _expiresAtKey);
  }

  // ── PKCE helpers ───────────────────────────────────────────────────────────

  ({String verifier, String challenge, String state}) _generatePkce() {
    final rng = Random.secure();
    final verifierBytes = List<int>.generate(32, (_) => rng.nextInt(256));
    final verifier = base64UrlEncode(verifierBytes).replaceAll('=', '');
    final challenge =
        base64UrlEncode(sha256.convert(utf8.encode(verifier)).bytes)
            .replaceAll('=', '');
    final stateBytes = List<int>.generate(16, (_) => rng.nextInt(256));
    final state = base64UrlEncode(stateBytes).replaceAll('=', '');
    return (verifier: verifier, challenge: challenge, state: state);
  }
}
