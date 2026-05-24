import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:owndo/core/constants.dart';
import 'package:owndo/data/sync/sync_engine.dart';

class SyncScheduler {
  SyncScheduler(this._engine);

  final SyncEngine _engine;
  Timer? _timer;
  AppLifecycleListener? _lifecycleListener;
  StreamSubscription<SyncStatus>? _statusSub;
  Timer? _retryTimer;

  /// Start the scheduler: runs sync immediately, then every [AppConstants.syncInterval].
  /// Also triggers sync on app foreground resume and retries quickly after errors.
  void start() {
    _engine.sync();
    _timer = Timer.periodic(AppConstants.syncInterval, (_) => _engine.sync());
    _lifecycleListener = AppLifecycleListener(
      onResume: () => _engine.sync(),
    );
    _statusSub = _engine.statusStream.listen((status) {
      _retryTimer?.cancel();
      if (status == SyncStatus.error) {
        _retryTimer = Timer(const Duration(seconds: 10), () => _engine.sync());
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _retryTimer?.cancel();
    _retryTimer = null;
    _statusSub?.cancel();
    _statusSub = null;
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
  }
}
