// lib/presentation/widgets/shared_widgets.dart
// Widget reusable yang dipakai di semua halaman & semua role

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/constants/app_assets.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

// ══════════════════════════════════════════════════════════════════
// LOGO WIDGETS
// ══════════════════════════════════════════════════════════════════

/// Logo ikon saja (logo_lazuardy_noText.png)
/// Digunakan di halaman Login, Register, OTP, Forgot/Reset Password,
/// Detail Pribadi Siswa
class BimbelLogo extends StatelessWidget {
  final double size;
  const BimbelLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoIcon,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

/// Logo horizontal: ikon + nama "Bimbel Lazuardy" di samping kanan
/// (logo_memanjang.png) — Digunakan di Onboarding, Detail Pribadi, dll.
class LogoWithName extends StatelessWidget {
  final double height;
  const LogoWithName({super.key, this.height = 60});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoHorizontal,
      height: height,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
    );
  }
}

/// Logo full: ikon + nama + tagline (logo_lazuardi.png, bg hitam)
/// Digunakan hanya di SplashPage
class LogoFull extends StatelessWidget {
  final double width;
  const LogoFull({super.key, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoFull,
      width: width,
      fit: BoxFit.contain,
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// DIVIDER
// ══════════════════════════════════════════════════════════════════

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'atau',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// OAUTH BUTTONS — pakai asset gambar nyata
// ══════════════════════════════════════════════════════════════════

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const GoogleSignInButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderColor, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.bgWhite,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.googleLogo, width: 22, height: 22, fit: BoxFit.contain),
            const SizedBox(width: 10),
            const Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class FacebookSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const FacebookSignInButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.facebookBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.facebookLogo,
              width: 22,
              height: 22,
              fit: BoxFit.contain,
              color: Colors.white,
              colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(width: 10),
            const Text(
              'Sign in with Facebook',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// BUTTON
// ══════════════════════════════════════════════════════════════════

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// CHECKBOX
// ══════════════════════════════════════════════════════════════════

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const RememberMeCheckbox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Ingat saya', style: AppTextStyles.bodySecondary),
      ],
    );
  }
}