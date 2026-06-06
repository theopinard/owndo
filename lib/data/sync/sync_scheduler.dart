import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:owndo/core/constants.dart';
import 'package:owndo/data/sync/sync_engine.dart';

class SyncScheduler {
  SyncScheduler(this._engine);

  final SyncEngine _engine;

  Timer? _pollTimer;
  Timer? _pushDebounce;
  Timer? _retryTimer;
  AppLifecycleListener? _lifecycleListener;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  Duration _currentInterval = AppConstants.syncBaseInterval;
  int _consecutiveErrors = 0;
  bool _isOnline = true;

  /// Start the scheduler: runs sync immediately, then adaptively polls.
  /// Also triggers sync on app foreground resume and network reconnect.
  void start() {
    _attemptSync();
    _schedulePoll();

    _lifecycleListener = AppLifecycleListener(
      onResume: () => _attemptSync(),
    );

    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final online = !results.every((r) => r == ConnectivityResult.none);
      if (!_isOnline && online) {
        // Came back online — reset backoff and sync immediately.
        _consecutiveErrors = 0;
        _retryTimer?.cancel();
        _attemptSync();
      }
      _isOnline = online;
    });
  }

  /// Notify that a local write happened. Triggers sync after a short debounce.
  void notifyLocalWrite() {
    _pushDebounce?.cancel();
    _pushDebounce = Timer(AppConstants.syncPushDebounce, () {
      _currentInterval = AppConstants.syncBaseInterval;
      _attemptSync();
    });
  }

  void stop() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _pushDebounce?.cancel();
    _pushDebounce = null;
    _retryTimer?.cancel();
    _retryTimer = null;
    _connectivitySub?.cancel();
    _connectivitySub = null;
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
  }

  void _schedulePoll() {
    _pollTimer?.cancel();
    _pollTimer = Timer(_currentInterval, () {
      _attemptSync();
      _schedulePoll();
    });
  }

  Future<void> _attemptSync() async {
    if (!_isOnline) return;

    final result = await _engine.sync();

    if (_engine.currentStatus == SyncStatus.error) {
      _consecutiveErrors++;
      _scheduleRetry();
    } else {
      _consecutiveErrors = 0;
      _retryTimer?.cancel();
      _adaptInterval(result);
    }
  }

  void _adaptInterval(SyncResult result) {
    if (result.hadRemoteChanges) {
      // Activity detected — reset to base interval.
      _currentInterval = AppConstants.syncBaseInterval;
    } else {
      // No changes — extend interval (double, capped at max).
      _currentInterval = Duration(
        milliseconds: min(
          _currentInterval.inMilliseconds * 2,
          AppConstants.syncMaxInterval.inMilliseconds,
        ),
      );
    }
    _schedulePoll();
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    final delaySec = min(
      AppConstants.syncBaseRetryDelay.inSeconds *
          pow(2, _consecutiveErrors - 1).toInt(),
      AppConstants.syncMaxRetryDelay.inSeconds,
    );
    _retryTimer = Timer(Duration(seconds: delaySec), () => _attemptSync());
  }
}
