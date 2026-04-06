import 'package:flutter/cupertino.dart';
import '../../../models/user_model.dart';
import '../register/register_wizard_screen.dart';

class ContractorRegisterScreen extends StatelessWidget {
  const ContractorRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterWizardScreen(role: UserRole.contractor);
  }
}
