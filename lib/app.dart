import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owndo/application/providers/auth_provider.dart';
import 'package:owndo/application/providers/sync_provider.dart';
import 'package:owndo/presentation/router/app_router.dart';

class OwnDoApp extends ConsumerStatefulWidget {
  const OwnDoApp({super.key});

  @override
  ConsumerState<OwnDoApp> createState() => _OwnDoAppState();
}

class _OwnDoAppState extends ConsumerState<OwnDoApp> {
  @override
  void initState() {
    super.initState();
    // Start the sync scheduler once authenticated
    ref.listenManual(isAuthenticatedProvider, (_, next) {
      if (next.valueOrNull == true) {
        ref.read(syncSchedulerProvider).start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'OwnDo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
