import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../models/user_model.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../shared/app_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  Future<void> _login(BuildContext context) async {
    final vm = context.read<AuthViewModel>();

    // TODO(backend): loginWithEmail calls FirebaseAuth – see AuthViewModel
    final success = await vm.loginWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      _navigateToHome(context, vm.currentUser!.role);
    } else if (vm.errorMessage != null) {
      _showError(context, vm.errorMessage!);
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    final vm = context.read<AuthViewModel>();

    // TODO(backend): loginWithGoogle calls GoogleSignIn + Firebase – see AuthViewModel
    final success = await vm.loginWithGoogle();

    if (!mounted) return;

    if (success) {
      _navigateToHome(context, vm.currentUser!.role);
    }
  }

  void _navigateToHome(BuildContext context, UserRole role) {
    if (role == UserRole.tasker) {
      context.go(AppRoutes.taskerHome);
    } else {
      context.go(AppRoutes.contractorHome);
    }
  }

  void _showError(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Login failed'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthViewModel>().clearError();
            },
          ),
        ],
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final role = vm.selectedRole;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Back button
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                child: const Icon(
                  CupertinoIcons.chevron_left,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Role badge
              if (role != null)
                RoleBadge(
                  label: role == UserRole.contractor ? 'Contractor' : 'Tasker',
                  color: role == UserRole.contractor
                      ? AppColors.contractorAccent
                      : AppColors.taskerAccent,
                ),

              const SizedBox(height: AppSpacing.md),

              const Text('Welcome\nback.', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Sign in to your account to continue.',
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Email field
              AppTextField(
                label: 'EMAIL',
                placeholder: 'you@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppSpacing.md),

              // Password field
              AppTextField(
                label: 'PASSWORD',
                placeholder: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: () => _login(context),
                prefix: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                  minimumSize: Size(0, 0),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  // TODO(backend): Implement forgot password with FirebaseAuth.sendPasswordResetEmail()
                  onPressed: () {},
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  minimumSize: Size(0, 0),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Login button
              AppPrimaryButton(
                label: 'Log In',
                isLoading: vm.isLoading,
                onPressed: vm.isLoading ? null : () => _login(context),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'or',
                      style: AppTextStyles.caption,
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Google button
              GoogleSignInButton(
                isLoading: vm.isLoading,
                onPressed: () => _loginWithGoogle(context),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Register CTA
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: AppTextStyles.caption,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RegisterLink(
                          label: 'Join as Contractor',
                          route: AppRoutes.contractorRegister,
                          color: AppColors.contractorAccent,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          child: Text('·', style: AppTextStyles.caption),
                        ),
                        _RegisterLink(
                          label: 'Join as Tasker',
                          route: AppRoutes.taskerRegister,
                          color: AppColors.taskerAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterLink extends StatelessWidget {
  final String label;
  final String route;
  final Color color;

  const _RegisterLink({
    required this.label,
    required this.route,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push(route),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      minimumSize: Size(0, 0),
    );
  }
}
