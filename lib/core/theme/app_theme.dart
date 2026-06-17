// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand color (Teal)
  static const primary = Color(0xFF2C8AA4);
  static const primaryDark = Color(0xFF2D8B85);
  static const primaryLight = Color(0xFFE8F7F7);

  // Secondary brand color (Dark Blue) used in primary buttons and main accents
  static const secondary = Color(0xFF27346A); 
  static const secondaryLight = Color(0xFF3B4D95);

  // Background colors
  static const bgWhite = Color(0xFFFFFFFF);
  static const bgTeal = Color(0xFF32868A); // The darker teal background from the design
  static const bgGrey = Color(0xFFF8FAFC);
  static const tabBg = Color(0xFFF0F0F0);
  static const avatarBg = Color(0xFFE2E8F0); // Soft blue/grey for user avatars

  // Text colors
  static const textPrimary = Color(0xFF1A1A2E); // Dark text
  static const textSecondary = Color(0xFF6B7280); // Grey text
  static const textWhite = Color(0xFFFFFFFF); // White text on dark backgrounds
  static const textTeal = Color(0xFF2E7D7A);

  // Border and utilities
  static const borderColor = Color(0xFFE5E7EB);
  static const errorRed = Color(0xFFE53E3E);
  static const successGreen = Color(0xFF10B981);
  static const warningYellow = Color(0xFFF59E0B);
  
  // Specific branding
  static const facebookBlue = Color(0xFF1877F2);
  static const checkboxTeal = Color(0xFF2C8AA4);
}

class AppTextStyles {
  AppTextStyles._();

  static const heading1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textTeal,
    height: 1.3,
  );

  static const heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const bodySecondary = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const linkTeal = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.errorRed,
          background: AppColors.bgWhite,
          surface: AppColors.bgWhite,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgWhite,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgWhite,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: AppTextStyles.heading2,
        ),
        cardTheme: CardThemeData(
          color: AppColors.bgWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderColor, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );

  /// Dekorasi input field standar sesuai desain
  static InputDecoration inputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      helperText: helperText,
      helperStyle: const TextStyle(
        fontSize: 11,
        color: AppColors.textSecondary,
      ),
      filled: true,
      fillColor: AppColors.bgWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.borderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
      ),
    );
  }
}