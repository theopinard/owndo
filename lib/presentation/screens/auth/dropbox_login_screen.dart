import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:owndo/application/providers/auth_provider.dart';

class DropboxLoginScreen extends ConsumerStatefulWidget {
  const DropboxLoginScreen({super.key});

  @override
  ConsumerState<DropboxLoginScreen> createState() => _DropboxLoginScreenState();
}

class _DropboxLoginScreenState extends ConsumerState<DropboxLoginScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _connectDropbox() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(dropboxAuthProvider).authenticate();
      ref.invalidate(isAuthenticatedProvider);
      if (mounted) context.go('/inbox');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, size: 72),
                const SizedBox(height: 24),
                Text(
                  'OwnDo',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your offline-first todo app.\nSync privately with Dropbox.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _connectDropbox,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud),
                    label: const Text('Connect Dropbox'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
