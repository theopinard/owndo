import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owndo/application/providers/sync_provider.dart';
import 'package:owndo/data/sync/sync_engine.dart';

class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(syncStatusProvider);
    final status = statusAsync.asData?.value ?? SyncStatus.idle;

    return IconButton(
      tooltip: switch (status) {
        SyncStatus.idle => 'Synced',
        SyncStatus.syncing => 'Syncing…',
        SyncStatus.error => 'Sync error — tap to retry',
      },
      onPressed: status == SyncStatus.error
          ? () => ref.read(syncEngineProvider).sync()
          : null,
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
