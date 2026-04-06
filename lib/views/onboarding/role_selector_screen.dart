import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../models/user_model.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxxl),

              // Logo / wordmark
              _buildLogo(),

              const SizedBox(height: AppSpacing.xxl),

              // Headline
              Text.rich(
                TextSpan(
                  style: AppTextStyles.display,
                  children: [
                    const TextSpan(text: '¿Cómo te gustaría usar '),
                    TextSpan(
                      text: 'chambi',
                      style: AppTextStyles.display.copyWith(
                        fontFamily: 'Lexend',
                      ),
                    ),
                    const TextSpan(text: '?'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'chambi es una plataforma que conecta profesionales con clientes.',
                style: AppTextStyles.bodySecondary,
              ),

              const Spacer(),

              // Role cards
              const _RoleCard(
                role: UserRole.contractor,
                title: 'Busco ayuda profesional',
                subtitle:
                    'Publica trabajos y encuentra trabajadores confiables cerca de ti',
                icon: CupertinoIcons.briefcase_fill,
                accentColor: AppColors.contractorAccent,
              ),
              const SizedBox(height: AppSpacing.md),
              const _RoleCard(
                role: UserRole.tasker,
                title: 'Quiero trabajar',
                subtitle: 'Explora trabajos y expande tu base de clientes',
                icon: CupertinoIcons.hammer_fill,
                accentColor: AppColors.taskerAccent,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Already have account
              Center(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.push(AppRoutes.login),
                  child: Text(
                    '¿Ya tienes una cuenta? Inicia sesión',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/logo.svg',
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 10),
        Text(
          'chambi',
          style: AppTextStyles.title.copyWith(
            fontSize: 30,
            fontFamily: 'Lexend',
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthViewModel>().selectRole(role);
        // Navigate to onboarding, passing role as extra
        context.push(AppRoutes.onboarding, extra: role);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.title.copyWith(fontSize: 17)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),

            // Arrow
            const Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
