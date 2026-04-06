import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../viewmodels/auth_viewmodel.dart';
import '../../../../shared/app_widgets.dart';

class ContractorRegisterScreen extends StatefulWidget {
  const ContractorRegisterScreen({super.key});

  @override
  State<ContractorRegisterScreen> createState() =>
      _ContractorRegisterScreenState();
}

class _ContractorRegisterScreenState extends State<ContractorRegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_nameController.text.trim().isEmpty) return 'Please enter your name.';
    if (_emailController.text.trim().isEmpty) return 'Please enter your email.';
    if (_passwordController.text.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return 'Passwords do not match.';
    }
    if (_addressController.text.trim().isEmpty) {
      return 'Please enter your address.';
    }
    if (_cityController.text.trim().isEmpty) return 'Please enter your city.';
    if (!_agreedToTerms) return 'Please accept the terms to continue.';
    return null;
  }

  Future<void> _register(BuildContext context) async {
    final error = _validate();
    if (error != null) {
      _showError(context, error);
      return;
    }

    final vm = context.read<AuthViewModel>();

    // TODO(backend): registerContractor creates Firebase user + Firestore doc – see AuthViewModel
    final success = await vm.registerContractor(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      zipCode: _zipController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.contractorHome);
    }
  }

  void _showError(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Check your info'),
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: const Border(),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.pop(),
          child: const Icon(CupertinoIcons.chevron_left,
              color: AppColors.textSecondary),
        ),
        middle: Text(
          'Contractor account',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              const RoleBadge(
                label: 'Contractor',
                color: AppColors.contractorAccent,
              ),
              const SizedBox(height: AppSpacing.md),

              const Text('Create your\naccount.',
                  style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Set up your contractor profile to start hiring.',
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Personal info section ──────────────────────────────────────
              const _SectionHeader(label: 'PERSONAL INFO'),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'FULL NAME',
                placeholder: 'Jane Smith',
                controller: _nameController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'EMAIL',
                placeholder: 'jane@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'PHONE',
                placeholder: '+1 (555) 000-0000',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Security section ───────────────────────────────────────────
              const _SectionHeader(label: 'SECURITY'),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'PASSWORD',
                placeholder: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
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
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'CONFIRM PASSWORD',
                placeholder: '••••••••',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.next,
                prefix: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                  minimumSize: Size(0, 0),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Address section ────────────────────────────────────────────
              const _SectionHeader(label: 'ADDRESS'),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Your address helps taskers find you and estimate travel.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'STREET ADDRESS',
                placeholder: '123 Main Street, Apt 4B',
                controller: _addressController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                      label: 'CITY',
                      placeholder: 'New York',
                      controller: _cityController,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: AppTextField(
                      label: 'ZIP CODE',
                      placeholder: '10001',
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Terms ──────────────────────────────────────────────────────
              GestureDetector(
                onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoCheckbox(
                      value: _agreedToTerms,
                      activeColor: AppColors.contractorAccent,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          // TODO(backend): Link to real terms URL
                          'I agree to the Terms of Service and Privacy Policy',
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              AppPrimaryButton(
                label: 'Create Contractor Account',
                color: AppColors.contractorAccent,
                isLoading: vm.isLoading,
                onPressed: vm.isLoading ? null : () => _register(context),
              ),

              const SizedBox(height: AppSpacing.lg),

              Center(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.pop(),
                  child: Text(
                    'Already have an account? Log in',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
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

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(height: 1, color: AppColors.divider),
        ),
      ],
    );
  }
}
