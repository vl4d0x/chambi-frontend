import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../models/user_model.dart';
import '../../../../viewmodels/auth_viewmodel.dart';
import '../../../shared/app_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tasker Registration Wizard
//
// Steps:
//   0 – Basic info (name, email, password, phone)
//   1 – Skills picker
//   2 – Profile photo
//   3 – Portfolio evidence (photos)
//   4 – Bio / description
// ─────────────────────────────────────────────────────────────────────────────

class TaskerRegisterScreen extends StatefulWidget {
  const TaskerRegisterScreen({super.key});

  @override
  State<TaskerRegisterScreen> createState() => _TaskerRegisterScreenState();
}

class _TaskerRegisterScreenState extends State<TaskerRegisterScreen> {
  int _step = 0;
  static const int _totalSteps = 5;

  // Step 0 – Basic info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;

  // Step 1 – Skills
  final List<String> _selectedSkills = [];

  // Step 2 – Profile photo
  // TODO(backend): Replace String with XFile from image_picker
  String? _avatarImagePath; // mock – will be XFile

  // Step 3 – Portfolio
  // TODO(backend): Replace List<String> with List<XFile> from image_picker
  final List<String> _portfolioImages = []; // mock – will be List<XFile>

  // Step 4 – Bio
  final _bioController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // ─── Navigation ────────────────────────────────────────────────────────────

  void _nextStep() {
    final error = _validateStep(_step);
    if (error != null) {
      _showError(error);
      return;
    }
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  // ─── Validation ────────────────────────────────────────────────────────────

  String? _validateStep(int step) {
    switch (step) {
      case 0:
        if (_nameController.text.trim().isEmpty) return 'Enter your full name.';
        if (_emailController.text.trim().isEmpty) return 'Enter your email.';
        if (_passwordController.text.length < 6) {
          return 'Password must be at least 6 characters.';
        }
        return null;
      case 1:
        if (_selectedSkills.isEmpty) return 'Select at least one skill.';
        return null;
      case 2:
        // Profile photo is optional but recommended
        return null;
      case 3:
        // Portfolio is optional
        return null;
      case 4:
        if (_bioController.text.trim().length < 20) {
          return 'Write at least 20 characters about yourself.';
        }
        if (!_agreedToTerms) return 'Please accept the terms to continue.';
        return null;
      default:
        return null;
    }
  }

  // ─── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final vm = context.read<AuthViewModel>();

    // TODO(backend): registerTasker uploads images + creates Firestore doc – see AuthViewModel
    final success = await vm.registerTasker(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      skills: _selectedSkills,
      bio: _bioController.text.trim(),
      portfolioImagePaths: _portfolioImages,
      avatarImagePath: _avatarImagePath,
    );

    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.taskerHome);
    }
  }

  void _showError(String message) {
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

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    final stepLabels = [
      'Basic info',
      'Your skills',
      'Profile photo',
      'Portfolio',
      'About you',
    ];

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // ── Top bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _prevStep,
                    child: const Icon(CupertinoIcons.chevron_left,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StepProgressBar(
                            totalSteps: _totalSteps, currentStep: _step),
                        const SizedBox(height: 6),
                        Text(
                          'Step ${_step + 1} of $_totalSteps — ${stepLabels[_step]}',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Step content ──────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _buildStep(_step),
              ),
            ),

            // ── Bottom CTA ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppPrimaryButton(
                label: _step == _totalSteps - 1
                    ? 'Create Tasker Account'
                    : 'Continue',
                color: AppColors.taskerAccent,
                isLoading: vm.isLoading,
                onPressed: vm.isLoading ? null : _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _StepBasicInfo(
          nameController: _nameController,
          emailController: _emailController,
          passwordController: _passwordController,
          phoneController: _phoneController,
          obscurePassword: _obscurePassword,
          onTogglePassword: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        );
      case 1:
        return _StepSkills(
          selectedSkills: _selectedSkills,
          onToggle: (skill) {
            setState(() {
              if (_selectedSkills.contains(skill)) {
                _selectedSkills.remove(skill);
              } else {
                _selectedSkills.add(skill);
              }
            });
          },
        );
      case 2:
        return _StepProfilePhoto(
          imagePath: _avatarImagePath,
          onPickPhoto: () {
            // TODO(backend): Call ImagePicker().pickImage(source: ImageSource.gallery)
            // then setState(() => _avatarImagePath = result?.path)
            setState(() => _avatarImagePath = 'mock_avatar.jpg');
          },
        );
      case 3:
        return _StepPortfolio(
          images: _portfolioImages,
          onAddPhoto: () {
            // TODO(backend): Call ImagePicker().pickMultiImage()
            // then setState(() => _portfolioImages.addAll(results.map((e) => e.path)))
            setState(() => _portfolioImages
                .add('mock_photo_${_portfolioImages.length}.jpg'));
          },
          onRemove: (index) {
            setState(() => _portfolioImages.removeAt(index));
          },
        );
      case 4:
        return _StepBio(
          bioController: _bioController,
          agreedToTerms: _agreedToTerms,
          onToggleTerms: (v) => setState(() => _agreedToTerms = v ?? false),
        );
      default:
        return const SizedBox();
    }
  }
}

// ─── Step 0: Basic Info ───────────────────────────────────────────────────────

class _StepBasicInfo extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const _StepBasicInfo({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const RoleBadge(label: 'Tasker', color: AppColors.taskerAccent),
        const SizedBox(height: AppSpacing.md),
        const Text('Tell us who\nyou are.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text('Start with the basics.',
            style: AppTextStyles.bodySecondary),
        const SizedBox(height: AppSpacing.xl),
        AppTextField(
          label: 'FULL NAME',
          placeholder: 'Carlos Ramirez',
          controller: nameController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'EMAIL',
          placeholder: 'carlos@example.com',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'PHONE',
          placeholder: '+1 (555) 000-0000',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'PASSWORD',
          placeholder: '••••••••',
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          prefix: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onTogglePassword,
            child: Icon(
              obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              size: 18,
              color: AppColors.textTertiary,
            ),
            minimumSize: Size(0, 0),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ─── Step 1: Skills ───────────────────────────────────────────────────────────

class _StepSkills extends StatelessWidget {
  final List<String> selectedSkills;
  final ValueChanged<String> onToggle;

  const _StepSkills({required this.selectedSkills, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text('What are your\nspecialties?',
            style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Select all that apply. You can update these later.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: SkillCategories.all.map((skill) {
            return SkillChip(
              label: skill,
              isSelected: selectedSkills.contains(skill),
              onTap: () => onToggle(skill),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (selectedSkills.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.taskerAccent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border:
                  Border.all(color: AppColors.taskerAccent.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.checkmark_circle_fill,
                    color: AppColors.taskerAccent, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${selectedSkills.length} skill${selectedSkills.length == 1 ? '' : 's'} selected',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.taskerAccent,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ─── Step 2: Profile Photo ────────────────────────────────────────────────────

class _StepProfilePhoto extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPickPhoto;

  const _StepProfilePhoto({this.imagePath, required this.onPickPhoto});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = imagePath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text('Add a\nprofile photo.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Contractors are 3x more likely to hire taskers with a photo.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Center(
          child: GestureDetector(
            onTap: onPickPhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          hasPhoto ? AppColors.taskerAccent : AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: hasPhoto
                      ? ClipOval(
                          // TODO(backend): Replace with Image.file(File(imagePath!))
                          child: Container(
                            color: AppColors.taskerAccent.withOpacity(0.15),
                            child: const Icon(
                              CupertinoIcons.person_fill,
                              size: 56,
                              color: AppColors.taskerAccent,
                            ),
                          ),
                        )
                      : const Icon(
                          CupertinoIcons.person_fill,
                          size: 56,
                          color: AppColors.textTertiary,
                        ),
                ),
                // Edit badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.taskerAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(
                    CupertinoIcons.camera_fill,
                    color: CupertinoColors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: CupertinoButton(
            onPressed: onPickPhoto,
            child: Text(
              hasPhoto ? 'Change photo' : 'Choose from library',
              style: AppTextStyles.body.copyWith(
                color: AppColors.taskerAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Center(
          child: Text(
            'You can also take a photo',
            style: AppTextStyles.caption,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ─── Step 3: Portfolio ────────────────────────────────────────────────────────

class _StepPortfolio extends StatelessWidget {
  final List<String> images;
  final VoidCallback onAddPhoto;
  final ValueChanged<int> onRemove;

  const _StepPortfolio({
    required this.images,
    required this.onAddPhoto,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text('Show your\nwork.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Add photos of past jobs. A strong portfolio wins more clients.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Photo grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: images.length + 1, // +1 for add button
          itemBuilder: (context, index) {
            if (index == images.length) {
              // Add button
              return GestureDetector(
                onTap: onAddPhoto,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                        color: AppColors.divider, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.add,
                          color: AppColors.textTertiary, size: 22),
                      const SizedBox(height: 4),
                      Text('Add',
                          style: AppTextStyles.caption.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
              );
            }

            // Image tile
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.taskerAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    // TODO(backend): Replace with Image.file(File(images[index]))
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.photo_fill,
                      color: AppColors.taskerAccent.withOpacity(0.4),
                      size: 28,
                    ),
                  ),
                ),
                // Remove button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onRemove(index),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.xmark,
                        color: CupertinoColors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          '${images.length} / 10 photos added',
          style: AppTextStyles.caption,
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ─── Step 4: Bio ──────────────────────────────────────────────────────────────

class _StepBio extends StatelessWidget {
  final TextEditingController bioController;
  final bool agreedToTerms;
  final ValueChanged<bool?> onToggleTerms;

  const _StepBio({
    required this.bioController,
    required this.agreedToTerms,
    required this.onToggleTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text('Introduce\nyourself.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Write a short description about your experience, work style, and what makes you stand out.',
          style: AppTextStyles.bodySecondary.copyWith(height: 1.6),
        ),
        const SizedBox(height: AppSpacing.xl),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.divider),
          ),
          child: CupertinoTextField(
            controller: bioController,
            placeholder:
                'e.g. I\'m a licensed plumber with 8 years of experience. I specialize in residential repairs and am known for clean, reliable work...',
            placeholderStyle: AppTextStyles.body.copyWith(
              color: AppColors.textTertiary,
            ),
            style: AppTextStyles.body,
            maxLines: 8,
            minLines: 8,
            decoration: null,
            padding: const EdgeInsets.all(AppSpacing.md),
            cursorColor: AppColors.taskerAccent,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Terms
        GestureDetector(
          onTap: () => onToggleTerms(!agreedToTerms),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoCheckbox(
                value: agreedToTerms,
                activeColor: AppColors.taskerAccent,
                onChanged: onToggleTerms,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    // TODO(backend): Link to real terms of service URL
                    'I agree to the Terms of Service and Privacy Policy',
                    style: AppTextStyles.caption,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
