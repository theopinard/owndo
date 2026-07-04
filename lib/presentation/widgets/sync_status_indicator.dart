import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owndo/application/providers/auth_provider.dart';
import 'package:owndo/application/providers/sync_provider.dart';
import 'package:owndo/data/sync/sync_engine.dart';

class SyncStatusIndicator extends ConsumerStatefulWidget {
  const SyncStatusIndicator({super.key});

  @override
  ConsumerState<SyncStatusIndicator> createState() =>
      _SyncStatusIndicatorState();
}

class _SyncStatusIndicatorState extends ConsumerState<SyncStatusIndicator> {
  bool _connecting = false;

  Future<void> _connectDropbox() async {
    setState(() => _connecting = true);
    try {
      await ref.read(dropboxAuthProvider).authenticate();
      ref.invalidate(isAuthenticatedProvider);
      ref.invalidate(appAccessModeProvider);
      ref.read(syncSchedulerProvider).start();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dropbox connection failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accessMode = ref.watch(appAccessModeProvider).asData?.value;
    if (accessMode != AppAccessMode.dropbox) {
      return IconButton(
        tooltip: 'Connect Dropbox',
        onPressed: _connecting ? null : _connectDropbox,
        icon: _connecting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.cloud_off),
      );
    }

    final statusAsync = ref.watch(syncStatusProvider);
    final status = statusAsync.asData?.value ?? SyncStatus.idle;

    return IconButton(
      tooltip: switch (status) {
        SyncStatus.idle => 'Tap to sync',
        SyncStatus.syncing => 'Syncing…',
        SyncStatus.error => 'Sync error — tap to retry',
      },
      onPressed: status == SyncStatus.syncing
          ? null
          : () => ref.read(syncEngineProvider).sync(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: switch (status) {
          SyncStatus.idle => const Icon(
            Icons.cloud_done,
            key: ValueKey('idle'),
            color: Colors.grey,
          ),
          SyncStatus.syncing => const SizedBox(
            key: ValueKey('syncing'),
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SyncStatus.error => const Icon(
            Icons.cloud_off,
            key: ValueKey('error'),
            color: Colors.red,
          ),
        },
      ),
    );
  }
}
