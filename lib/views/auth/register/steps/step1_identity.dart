import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../viewmodels/register_viewmodel.dart';
import '../../../../shared/app_widgets.dart';

class Step1Identity extends StatefulWidget {
  const Step1Identity({super.key});

  @override
  State<Step1Identity> createState() => _Step1IdentityState();
}

class _Step1IdentityState extends State<Step1Identity> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill if Google path already set name
    final vm = context.read<RegisterViewModel>();
    if (vm.name.isNotEmpty) _nameController.text = vm.name;
    if (vm.phone.isNotEmpty) _phoneController.text = vm.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncToVm() {
    final vm = context.read<RegisterViewModel>();
    vm.name = _nameController.text;
    vm.phone = _phoneController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text('¿Cómo te\nllamamos?', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Tu nombre aparecerá en tu perfil público.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.xl),

        AppTextField(
          label: 'NOMBRE COMPLETO',
          placeholder: 'Jane Smith',
          controller: _nameController,
          textInputAction: TextInputAction.next,
          onChanged: (_) => _syncToVm(),
        ),
        const SizedBox(height: AppSpacing.md),

        AppTextField(
          label: 'TELÉFONO',
          placeholder: '+1 (555) 000-0000',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onChanged: (_) => _syncToVm(),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
