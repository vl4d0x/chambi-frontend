import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  // Primary accent – #127DCE
  static const Color accent = Color(0xFF127DCE);
  static const Color accentLight = Color(0xFF1E9AF0);
  static const Color accentDark = Color(0xFF0D5FA0);

  // Backgrounds - Light Mode
  static const Color background =
      Color(0xFFF8F9FA); // Very light grey (easier on eyes than pure white)
  static const Color surface =
      Color(0xFFFFFFFF); // Pure white for cards/content
  static const Color surfaceElevated =
      Color(0xFFF1F3F4); // Subtle grey for hover states or secondary sections
  static const Color surfaceHighlight =
      Color(0xFFE8EAED); // Slightly darker for borders or active states

  // Text - Light Mode
  static const Color textPrimary =
      Color(0xFF1A1A1B); // Deep charcoal for headings and body
  static const Color textSecondary =
      Color(0xFF5F6368); // Medium gray for subheaders and labels
  static const Color textTertiary =
      Color(0xFF80868B); // Lighter gray for captions and disabled hints

  // Semantic
  static const Color success = Color(0xFF30D158);
  static const Color warning = Color(0xFFFFD60A);
  static const Color error = Color(0xFFFF453A);

  // Divider
  static const Color divider = Color(0xFF2A2A2A);

  // Role colors
  static const Color contractorAccent = Color(0xFF127DCE); // blue
  static const Color taskerAccent = Color(0xFF30D158); // green
}

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = '.SF Pro Display';

  static const TextStyle display = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.2,
    height: 1.1,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.8,
    height: 1.2,
  );

  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );

  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;
}
