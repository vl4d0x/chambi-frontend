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
      icon: CupertinoIcons.search,
      accentColor: AppColors.contractorAccent,
      title: 'Find trusted\nprofessionals',
      body:
          'Browse verified taskers in your area. Filter by skill, rating, and portfolio — hire with confidence.',
      illustrationEmoji: '🔍',
    ),
    _OnboardingPage(
      icon: CupertinoIcons.doc_text_fill,
      accentColor: AppColors.contractorAccent,
      title: 'Post your\ntask in seconds',
      body:
          'Describe what you need, set your budget, and let taskers come to you. No hassle, no middlemen.',
      illustrationEmoji: '📋',
    ),
    _OnboardingPage(
      icon: CupertinoIcons.checkmark_seal_fill,
      accentColor: AppColors.contractorAccent,
      title: 'Pay only when\nyou\'re happy',
      body:
          'Chat directly with taskers, agree on terms, and release payment once the job is done right.',
      illustrationEmoji: '✅',
    ),
  ];

  // ── Tasker onboarding content ──────────────────────────────────────────────
  static const _taskerPages = [
    _OnboardingPage(
      icon: CupertinoIcons.person_crop_circle_badge_plus,
      accentColor: AppColors.taskerAccent,
      title: 'Build your\nprofessional profile',
      body:
          'Showcase your skills, experience, and portfolio. A great profile gets you hired faster.',
      illustrationEmoji: '👤',
    ),
    _OnboardingPage(
      icon: CupertinoIcons.map_fill,
      accentColor: AppColors.taskerAccent,
      title: 'Find jobs\nnear you',
      body:
          'Browse local tasks that match your skills. Filter by category, pay rate, and distance.',
      illustrationEmoji: '📍',
    ),
    _OnboardingPage(
      icon: CupertinoIcons.money_dollar_circle_fill,
      accentColor: AppColors.taskerAccent,
      title: 'Earn on\nyour schedule',
      body:
          'Accept tasks when it works for you. Get paid fast, build reviews, and grow your reputation.',
      illustrationEmoji: '💰',
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
                      'Skip',
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
                    label: isLast ? 'Get Started' : 'Continue',
                    color: accentColor,
                    onPressed: _nextPage,
                  ),
                  if (_currentPage == 0) ...[
                    const SizedBox(height: AppSpacing.md),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => context.push(AppRoutes.login),
                      child: Text(
                        'Already have an account? Log in',
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
  final IconData icon;
  final Color accentColor;
  final String title;
  final String body;
  final String illustrationEmoji;

  const _OnboardingPage({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.body,
    required this.illustrationEmoji,
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

          // Large illustration area
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color: page.accentColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: page.accentColor.withOpacity(0.12)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background icon (large, faded)
                Icon(
                  page.icon,
                  size: 140,
                  color: page.accentColor.withOpacity(0.08),
                ),
                // Foreground icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: page.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Icon(page.icon, size: 38, color: page.accentColor),
                ),
              ],
            ),
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
