import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../viewmodels/register_viewmodel.dart';
import '../../../../shared/widgets/photo_picker_widget.dart';

class Step3ProfilePhoto extends StatelessWidget {
  final VoidCallback onSkip;

  const Step3ProfilePhoto({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text('Agrega una\nfoto de perfil.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Los contratistas tienen 3 veces más probabilidad de contratar taskers con foto.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.xxl),

        PhotoPickerWidget(
          photo: vm.profilePhoto,
          accentColor: AppColors.taskerAccent,
          onPhotoPicked: (file) {
            context.read<RegisterViewModel>().setProfilePhoto(file);
          },
        ),

        const SizedBox(height: AppSpacing.xl),

        Center(
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onSkip,
            child: Text(
              'Omitir por ahora',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
