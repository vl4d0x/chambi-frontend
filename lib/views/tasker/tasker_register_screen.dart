import 'package:flutter/cupertino.dart';
import '../../models/user_model.dart';
import '../auth/register/register_wizard_screen.dart';

class TaskerRegisterScreen extends StatelessWidget {
  const TaskerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterWizardScreen(role: UserRole.tasker);
  }
}
