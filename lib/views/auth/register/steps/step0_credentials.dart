import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/user_model.dart';
import '../../../../viewmodels/register_viewmodel.dart';
import '../../../../shared/app_widgets.dart';

class Step0Credentials extends StatefulWidget {
  final UserRole role;
  final VoidCallback onGoogleSuccess;

  const Step0Credentials({
    super.key,
    required this.role,
    required this.onGoogleSuccess,
  });

  @override
  State<Step0Credentials> createState() => _Step0CredentialsState();
}

class _Step0CredentialsState extends State<Step0Credentials> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _syncToVm() {
    final vm = context.read<RegisterViewModel>();
    vm.email = _emailController.text;
    vm.password = _passwordController.text;
    vm.confirmPassword = _confirmController.text;
  }

  Future<void> _handleGoogle() async {
    setState(() => _isGoogleLoading = true);
    final vm = context.read<RegisterViewModel>();
    await vm.startWithGoogle();
    setState(() => _isGoogleLoading = false);
    widget.onGoogleSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.role == UserRole.contractor
        ? AppColors.contractorAccent
        : AppColors.taskerAccent;
    final roleLabel =
        widget.role == UserRole.contractor ? 'Contractor' : 'Tasker';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),

        RoleBadge(label: roleLabel, color: accentColor),
        const SizedBox(height: AppSpacing.md),

        const Text('Crea tu\ncuenta.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Usarás estas credenciales para iniciar sesión.',
          style: AppTextStyles.bodySecondary,
        ),

        const SizedBox(height: AppSpacing.xl),

        AppTextField(
          label: 'EMAIL',
          placeholder: 'nombre@ejemplo.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => _syncToVm(),
        ),
        const SizedBox(height: AppSpacing.md),

        AppTextField(
          label: 'CONTRASEÑA',
          placeholder: '••••••••',
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          onChanged: (_) => _syncToVm(),
          prefix: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword
                  ? CupertinoIcons.eye_slash
                  : CupertinoIcons.eye,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        AppTextField(
          label: 'CONFIRMAR CONTRASEÑA',
          placeholder: '••••••••',
          controller: _confirmController,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          onChanged: (_) => _syncToVm(),
          prefix: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () =>
                setState(() => _obscureConfirm = !_obscureConfirm),
            child: Icon(
              _obscureConfirm
                  ? CupertinoIcons.eye_slash
                  : CupertinoIcons.eye,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'o',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.divider)),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        GoogleSignInButton(
          isLoading: _isGoogleLoading,
          onPressed: _handleGoogle,
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
