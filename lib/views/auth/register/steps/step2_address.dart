import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/address_model.dart';
import '../../../../viewmodels/register_viewmodel.dart';
import '../../../../shared/widgets/address_picker_widget.dart';

class Step2Address extends StatelessWidget {
  const Step2Address({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text('¿Dónde estás\nubicado?', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Tu dirección ayuda a encontrar profesionales y servicios cercanos.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.xl),

        AddressPickerWidget(
          currentAddress: vm.address,
          onAddressChanged: (AddressModel address) {
            context.read<RegisterViewModel>().setAddress(address);
          },
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
