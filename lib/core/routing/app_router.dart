import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/child/presentation/child_profile_screen.dart';
import '../../features/curriculum/presentation/curriculum_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../shared/state/session_provider.dart';
import '../ui/animations/app_page_transitions.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => AppPageTransitions.fadeThrough(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => AppPageTransitions.fadeThrough(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => AppPageTransitions.sharedAxisHorizontal(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => AppPageTransitions.sharedAxisHorizontal(
          state: state,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        pageBuilder: (context, state) => AppPageTransitions.fadeThrough(
          state: state,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.childProfile,
        pageBuilder: (context, state) {
          final childId = state.pathParameters['childId']!;
          return AppPageTransitions.sharedAxisHorizontal(
            state: state,
            child: ChildProfileScreen(childId: childId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.curriculum,
        pageBuilder: (context, state) {
          final childId = state.pathParameters['childId']!;
          return AppPageTransitions.sharedAxisHorizontal(
            state: state,
            child: CurriculumScreen(childId: childId),
          );
        },
      ),
    ],
    redirect: (context, state) {
      final loc = state.uri.toString();

      final isSplash = loc == AppRoutes.splash;
      final isOnboarding = loc.startsWith(AppRoutes.onboarding);
      final isAuth = loc.startsWith(AppRoutes.login) || loc.startsWith(AppRoutes.register);

      // Après le splash, on redirige selon l’état mock.
      if (isSplash) {
        if (!session.hasOnboarded) return AppRoutes.onboarding;
        if (!session.isAuthenticated) return AppRoutes.login;
        return AppRoutes.dashboard;
      }

      // Si pas d’onboarding, on force l’onboarding (sauf splash).
      if (!session.hasOnboarded && !isOnboarding) {
        return AppRoutes.onboarding;
      }

      // Si pas connecté, on force la page login (sauf onboarding et auth).
      if (session.hasOnboarded && !session.isAuthenticated && !isAuth && !isOnboarding) {
        return AppRoutes.login;
      }

      // Si connecté et essaie d’aller sur login/register, on renvoie dashboard.
      if (session.isAuthenticated && isAuth) return AppRoutes.dashboard;

      return null;
    },
  );
});

