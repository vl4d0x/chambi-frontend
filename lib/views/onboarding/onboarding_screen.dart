import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../models/user_model.dart';
import '../../shared/app_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final UserRole role;

  const OnboardingScreen({super.key, required this.role});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<_OnboardingPage> get _pages =>
      widget.role == UserRole.contractor ? _contractorPages : _taskerPages;

  // ── Contractor onboarding content ──────────────────────────────────────────
  static const _contractorPages = [
    _OnboardingPage(
      accentColor: AppColors.contractorAccent,
      title: 'Encuentra profesionales\nconfiables',
      body:
          'Busca entre multiples trabajadores verificados en tu área. Lee reseñas, compara perfiles y elige al mejor para tu trabajo.',
      imagePath: 'assets/images/onboard-contratist-1.png',
    ),
    _OnboardingPage(
      accentColor: AppColors.contractorAccent,
      title: 'Publica tu\ntrabajo en segundos',
      body:
          'Escribe lo que necesitas, establece tu presupuesto y deja que los trabajadores vengan a ti. Sin complicaciones, sin intermediarios.',
      imagePath: 'assets/images/onboard-contratist-2.png',
    ),
    _OnboardingPage(
      accentColor: AppColors.contractorAccent,
      title: 'Paga sólo cuando el trabajo esté hecho',
      body:
          'Confía en nuestro sistema de pago seguro. Paga a los trabajadores sólo cuando estés satisfecho con el trabajo realizado.',
      imagePath: 'assets/images/onboard-contratist-3.png',
    ),
  ];

  // ── Tasker onboarding content ──────────────────────────────────────────────
  static const _taskerPages = [
    _OnboardingPage(
      accentColor: AppColors.taskerAccent,
      title: 'Crea tu\nperfil profesional',
      body:
          'Muestra tus habilidades, experiencia y portafolio. Un buen perfil te ayuda a conseguir más trabajo.',
      imagePath: 'assets/images/onboard-tasker-1.png',
    ),
    _OnboardingPage(
      accentColor: AppColors.taskerAccent,
      title: 'Encuentra trabajos\ncerca de ti',
      body:
          'Explora tareas locales que se ajusten a tus habilidades. Filtra por categoría, pago y distancia.',
      imagePath: 'assets/images/onboard-tasker-2.png',
    ),
    _OnboardingPage(
      accentColor: AppColors.taskerAccent,
      title: 'Trabaja cuando\nquieras',
      body:
          'Acepta trabajos a tu ritmo. Cobra rápido, acumula reseñas y haz crecer tu reputación.',
      imagePath: 'assets/images/onboard-tasker-3.png',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 340),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page – go to login
      context.push(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.role == UserRole.contractor
        ? AppColors.contractorAccent
        : AppColors.taskerAccent;

    final isLast = _currentPage == _pages.length - 1;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => context.pop(),
                    child: const Icon(
                      CupertinoIcons.chevron_left,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  // Progress dots
                  Row(
                    children: List.generate(_pages.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? accentColor : AppColors.divider,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => context.push(AppRoutes.login),
                    child: Text(
                      'Omitir',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) =>
                    _OnboardingPageView(page: _pages[index]),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  AppPrimaryButton(
                    label: isLast ? 'Comenzar' : 'Continuar',
                    color: accentColor,
                    onPressed: _nextPage,
                  ),
                  if (_currentPage == 0) ...[
                    const SizedBox(height: AppSpacing.md),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => context.push(AppRoutes.login),
                      child: Text(
                        '¿Ya tienes una cuenta? Inicia sesión',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Individual onboarding page data ─────────────────────────────────────────

class _OnboardingPage {
  final Color accentColor;
  final String title;
  final String body;
  final String imagePath;

  const _OnboardingPage({
    required this.accentColor,
    required this.title,
    required this.body,
    required this.imagePath,
  });
}

// ─── Individual onboarding page widget ───────────────────────────────────────

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),

          // Illustration image
          Image.asset(
            page.imagePath,
            width: double.infinity,
            height: 300,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: AppSpacing.xl),

          // Title
          Text(page.title, style: AppTextStyles.headline),

          const SizedBox(height: AppSpacing.md),

          // Body
          Text(
            page.body,
            style: AppTextStyles.bodySecondary.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
