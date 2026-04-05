import 'package:chambi_frontend/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

// ─── Primary Button ───────────────────────────────────────────────────────────

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final double? width;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.accent;

    return SizedBox(
      width: width ?? double.infinity,
      height: 54,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                ),
              ),
      ),
    );
  }
}

// ─── Secondary / Ghost Button ─────────────────────────────────────────────────

class AppSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? borderColor;

  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.accent;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: CupertinoColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: border, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: border,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Text Field ───────────────────────────────────────────────────────────────

class AppTextField extends StatelessWidget {
  final String placeholder;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final String? label;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;

  const AppTextField({
    super.key,
    required this.placeholder,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.prefix,
    this.label,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.6,
              )),
          const SizedBox(height: AppSpacing.sm),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.divider),
          ),
          child: CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: null, // we handle decoration via Container
            placeholderStyle: AppTextStyles.body.copyWith(
              color: AppColors.textTertiary,
            ),
            style: AppTextStyles.body,
            prefix: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.md),
                    child: prefix,
                  )
                : null,
            cursorColor: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

// ─── Google Sign-In Button ────────────────────────────────────────────────────

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Simple G logo via text (replace with SVG asset later)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighlight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Continue with Google',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Role Badge ───────────────────────────────────────────────────────────────

class RoleBadge extends StatelessWidget {
  final String label;
  final Color color;

  const RoleBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.label.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}

// ─── Step Progress Indicator ──────────────────────────────────────────────────

class StepProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isActive = index == currentStep;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 6 : 0),
            height: 3,
            decoration: BoxDecoration(
              color: isCompleted || isActive
                  ? AppColors.accent
                  : AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Skill Chip ───────────────────────────────────────────────────────────────

class SkillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SkillChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? CupertinoColors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
