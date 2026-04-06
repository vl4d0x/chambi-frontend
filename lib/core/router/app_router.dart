import 'package:chambi_frontend/views/auth/contractor/contractor_register_screen.dart';
import 'package:chambi_frontend/views/tasker/tasker_register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/auth_viewmodel.dart';
import '../../../../models/user_model.dart';
import '../../../../views/onboarding/role_selector_screen.dart';
import '../../../../views/onboarding/onboarding_screen.dart';
import '../../../../views/auth/login_screen.dart';

// ─── Route Names ──────────────────────────────────────────────────────────────

class AppRoutes {
  static const roleSelector = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const contractorRegister = '/register/contractor';
  static const taskerRegister = '/register/tasker';
  static const contractorHome = '/contractor';
  static const taskerHome = '/tasker';
}

// ─── Router Factory ───────────────────────────────────────────────────────────

GoRouter createRouter(AuthViewModel authViewModel) {
  return GoRouter(
    initialLocation: AppRoutes.roleSelector,
    debugLogDiagnostics: true,
    refreshListenable: authViewModel,

    // TODO(backend): Update redirect logic whien real auth persistence is added.

    // Check FirebaseAuth.instance.currentUser and redirect accordingly.
    redirect: (context, state) {
      final isAuthenticated = authViewModel.isAuthenticated;
      final role = authViewModel.currentUser?.role;
      final location = state.matchedLocation;

      // If authenticated, redirect away from auth/onboarding screens
      if (isAuthenticated) {
        final isOnAuthFlow = location == AppRoutes.roleSelector ||
            location == AppRoutes.onboarding ||
            location == AppRoutes.login ||
            location == AppRoutes.contractorRegister ||
            location == AppRoutes.taskerRegister;

        if (isOnAuthFlow) {
          return role == UserRole.tasker
              ? AppRoutes.taskerHome
              : AppRoutes.contractorHome;
        }
      }

      return null; // No redirect needed
    },

    routes: [
      // ── Pre-auth flow ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.roleSelector,
        name: 'roleSelector',
        builder: (context, state) => const RoleSelectorScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) {
          // Role is passed via extra to avoid encoding it in the URL
          final role = state.extra as UserRole? ??
              context.read<AuthViewModel>().selectedRole ??
              UserRole.contractor;
          return OnboardingScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Registration ───────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.contractorRegister,
        name: 'contractorRegister',
        builder: (context, state) => const ContractorRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.taskerRegister,
        name: 'taskerRegister',
        builder: (context, state) => const TaskerRegisterScreen(),
      ),

      // ── Contractor route tree ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.contractorHome,
        name: 'contractorHome',
        builder: (context, state) => const Placeholder(),
        // TODO: Add nested routes for contractor sub-screens (feed, post, chat, account)
      ),

      // ── Tasker route tree ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.taskerHome,
        name: 'taskerHome',
        builder: (context, state) => const Placeholder(),
        // TODO: Add nested routes for tasker sub-screens (feed, profile, chat, account)
      ),
    ],
  );
}
