import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/ui/animations/animated_entrance.dart';
import '../../../shared/state/session_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    // Petit temps pour laisser apparaître la marque (calme, pro).
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final session = ref.read(sessionProvider);
    if (!session.hasOnboarded) {
      context.go(AppRoutes.onboarding);
      return;
    }
    if (!session.isAuthenticated) {
      context.go(AppRoutes.login);
      return;
    }
    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedEntrance(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.school_rounded, color: cs.onPrimary),
                ),
                const SizedBox(height: 14),
                Text(
                  AppStrings.appName,
                  style: theme.textTheme.titleLarge?.copyWith(letterSpacing: -0.2),
                ),
                const SizedBox(height: 6),
                Text(
                  'IEF • Organisation • Progression',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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

