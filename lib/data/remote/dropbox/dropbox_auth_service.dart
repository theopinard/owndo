import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:owndo/core/constants.dart';
import 'package:owndo/core/errors.dart';

class DropboxAuthService {
  DropboxAuthService({
    FlutterSecureStorage? storage,
    http.Client? httpClient,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _client = httpClient ?? http.Client();

  final FlutterSecureStorage _storage;
  final http.Client _client;

  static const _accessTokenKey = 'dropbox_access_token';
  static const _refreshTokenKey = 'dropbox_refresh_token';
  static const _expiresAtKey = 'dropbox_token_expires_at';

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Starts the Dropbox OAuth2 PKCE flow.
  ///
  /// **Linux**: opens the system browser, catches the callback on a temporary
  /// `dart:io` localhost HTTP server — no webkit2gtk / webview required.
  ///
  /// **Android / iOS / macOS**: opens the system browser via `url_launcher`,
  /// then waits for the `owndo://oauth-callback` deep link via `app_links`.
  Future<void> authenticate() async {
    if (Platform.isLinux) {
      await _authenticateLinux();
    } else {
      await _authenticateMobile();
    }
  }

  // ── Linux: pure Dart localhost server ─────────────────────────────────────

  Future<void> _authenticateLinux() async {
    final verifier = _generateCodeVerifier();
    final challenge = _generateCodeChallenge(verifier);
    final state = _generateState();

    // Bind to the fixed port registered in the Dropbox app console.
    // See AppConstants.dropboxLinuxRedirectUri.
    final server = await HttpServer.bind(
        InternetAddress.loopbackIPv4, AppConstants.dropboxLinuxCallbackPort);
    const redirectUri = AppConstants.dropboxLinuxRedirectUri;

    final authUrl = Uri.https('www.dropbox.com', '/oauth2/authorize', {
      'client_id': AppConstants.dropboxAppKey,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'code_challenge': challenge,
      'code_challenge_method': 'S256',
      'state': state,
      'token_access_type': 'offline',
    });

    if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
      await server.close(force: true);
      throw const AuthException('Could not open browser for Dropbox login');
    }

    try {
      final callbackUri = await _waitForCallback(server);

      final returnedState = callbackUri.queryParameters['state'];
      if (returnedState != state) {
        throw const AuthException(
            'OAuth2 state mismatch — possible CSRF attack');
      }

      final code = callbackUri.queryParameters['code'];
      if (code == null) {
        final error = callbackUri.queryParameters['error'] ?? 'unknown';
        throw AuthException('Dropbox auth denied: $error');
      }

      await _exchangeCodeForTokens(
          code: code, verifier: verifier, redirectUri: redirectUri);
    } finally {
      await server.close(force: true);
    }
  }

  /// Waits for the OAuth callback on [server], shows a success page, and
  /// returns the callback URI containing the code/state parameters.
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

  // ── Mobile / macOS: url_launcher + app_links deep link ────────────────────

  Future<void> _authenticateMobile() async {
    final verifier = _generateCodeVerifier();
    final challenge = _generateCodeChallenge(verifier);
    final state = _generateState();

    final authUrl = Uri.https('www.dropbox.com', '/oauth2/authorize', {
      'client_id': AppConstants.dropboxAppKey,
      'response_type': 'code',
      'redirect_uri': AppConstants.dropboxRedirectUri,
      'code_challenge': challenge,
      'code_challenge_method': 'S256',
      'state': state,
      'token_access_type': 'offline',
    });

    // Start listening for the deep link BEFORE opening the browser so we
    // don't miss the callback if the OS delivers it quickly.
    final appLinks = AppLinks();
    final linkFuture = appLinks.uriLinkStream
        .where((uri) => uri.scheme == 'owndo')
        .first
        .timeout(
          const Duration(minutes: 5),
          onTimeout: () =>
              throw const AuthException('Dropbox login timed out (5 min)'),
        );

    if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
      throw const AuthException('Could not open browser for Dropbox login');
    }

    final callbackUri = await linkFuture;

    final returnedState = callbackUri.queryParameters['state'];
    if (returnedState != state) {
      throw const AuthException('OAuth2 state mismatch — possible CSRF attack');
    }

    final code = callbackUri.queryParameters['code'];
    if (code == null) {
      final error = callbackUri.queryParameters['error'] ?? 'unknown';
      throw AuthException('Dropbox auth denied: $error');
    }

    await _exchangeCodeForTokens(
        code: code,
        verifier: verifier,
        redirectUri: AppConstants.dropboxRedirectUri);
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
        'client_id': AppConstants.dropboxAppKey,
        'client_secret': AppConstants.dropboxAppSecret,
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
        'client_id': AppConstants.dropboxAppKey,
        'client_secret': AppConstants.dropboxAppSecret,
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

  String _generateCodeVerifier() {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  String _generateState() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}
