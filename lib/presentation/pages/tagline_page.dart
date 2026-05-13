// lib/presentation/pages/tagline_page.dart
// Welcome/Onboarding — logo+nama, deskripsi, tombol selanjutnya, OAuth

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

class TaglinePage extends StatelessWidget {
  const TaglinePage({super.key});

  static const _description =
      'Bimbel Lazuardy adalah platform bimbingan belajar inovatif yang dirancang untuk '
      'mewujudkan proses belajar tanpa batas dengan pengalaman yang nyaman dan terpersonalisasi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),

              // ── Logo + Nama ───────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo_lazuardi_noText.png',
                    height: 50,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Bimbel Lazuardy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),

              // ── Deskripsi ─────────────────────────────────────
              const Text(
                _description,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  height: 1.65,
                ),
              ),

              const Spacer(),

              // ── Tombol Selanjutnya ────────────────────────────
              PrimaryButton(
                label: 'Selanjutnya',
                onPressed: () {
                  Navigator.of(context).pushNamed('/siswa/login');
                },
              ),

              const SizedBox(height: 20),

              // ── Divider "atau" ────────────────────────────────
              const OrDivider(),

              const SizedBox(height: 20),

              // ── OAuth Buttons ─────────────────────────────────
              GoogleSignInButton(
                onPressed: () {
                  // TODO: Implement Google Sign In
                },
              ),

              const SizedBox(height: 12),

              FacebookSignInButton(
                onPressed: () {
                  // TODO: Implement Facebook Sign In
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}