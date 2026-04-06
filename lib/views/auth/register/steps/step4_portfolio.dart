import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../viewmodels/register_viewmodel.dart';
import '../../../../shared/widgets/portfolio_picker_widget.dart';

class Step4Portfolio extends StatelessWidget {
  final VoidCallback onSkip;

  const Step4Portfolio({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text('Muestra tu\ntrabajo.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Agrega hasta 10 fotos de proyectos anteriores para ganar más clientes.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.xl),

        PortfolioPickerWidget(
          photos: vm.portfolioPhotos,
          maxPhotos: RegisterViewModel.maxPortfolioPhotos,
          onPhotosAdded: (files) {
            context.read<RegisterViewModel>().addPortfolioPhotos(files);
          },
          onPhotoRemoved: (index) {
            context.read<RegisterViewModel>().removePortfolioPhoto(index);
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
