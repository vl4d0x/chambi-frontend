import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/register_viewmodel.dart';
import '../../../shared/app_widgets.dart';
import 'steps/step0_credentials.dart';
import 'steps/step1_identity.dart';
import 'steps/step2_address.dart';
import 'steps/step3_profile_photo.dart';
import 'steps/step4_portfolio.dart';

class RegisterWizardScreen extends StatelessWidget {
  final UserRole role;

  const RegisterWizardScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(role: role),
      child: _WizardBody(role: role),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _WizardBody extends StatefulWidget {
  final UserRole role;
  const _WizardBody({required this.role});

  @override
  State<_WizardBody> createState() => _WizardBodyState();
}

class _WizardBodyState extends State<_WizardBody> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _goBack(RegisterViewModel vm) {
    if (vm.canGoBack) {
      vm.previousStep();
      _animateToPage(vm.currentStep);
    } else {
      context.pop();
    }
  }

  Future<void> _goNext(RegisterViewModel vm) async {
    // Step 0: run async email check before proceeding
    if (vm.currentStep == 0 && !vm.isGooglePath) {
      await vm.validateEmailAsync();
    }

    final error = vm.validateCurrentStep();
    if (error != null) {
      _showError(error);
      return;
    }

    if (vm.currentStep == vm.totalSteps - 1) {
      await _submit(vm);
    } else {
      vm.nextStep();
      _animateToPage(vm.currentStep);
    }
  }

  Future<void> _submit(RegisterViewModel vm) async {
    final authVm = context.read<AuthViewModel>();
    final success = await vm.submit(authVm);
    if (!mounted) return;
    if (success) {
      final route = widget.role == UserRole.tasker
          ? AppRoutes.taskerHome
          : AppRoutes.contractorHome;
      context.go(route);
    } else if (vm.submitError != null) {
      _showError(vm.submitError!);
    }
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Verifica tus datos'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    final accentColor = widget.role == UserRole.contractor
        ? AppColors.contractorAccent
        : AppColors.taskerAccent;

    final isLastStep = vm.currentStep == vm.totalSteps - 1;
    final submitLabel = widget.role == UserRole.contractor
        ? 'Crear cuenta'
        : 'Crear cuenta';

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // ── Top bar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () => _goBack(vm),
                    child: const Icon(
                      CupertinoIcons.chevron_left,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StepProgressBar(
                          totalSteps: vm.totalSteps,
                          currentStep: vm.currentStep,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Paso ${vm.currentStep + 1} de ${vm.totalSteps}',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Step content ───────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    child: Step0Credentials(
                      role: widget.role,
                      onGoogleSuccess: () => _animateToPage(1),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    child: const Step1Identity(),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    child: const Step2Address(),
                  ),
                  if (widget.role == UserRole.tasker) ...[
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg),
                      child: Step3ProfilePhoto(
                        onSkip: () {
                          vm.nextStep();
                          _animateToPage(vm.currentStep);
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg),
                      child: Step4Portfolio(
                        onSkip: () => _submit(vm),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Bottom CTA ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppPrimaryButton(
                label: isLastStep ? submitLabel : 'Continuar',
                color: accentColor,
                isLoading: vm.isCheckingEmail || vm.isSubmitting,
                onPressed: (vm.isCheckingEmail || vm.isSubmitting)
                    ? null
                    : () => _goNext(vm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
