// lib/presentation/pages/tagline_page.dart
// Welcome/Onboarding — logo+nama, deskripsi, tombol selanjutnya, OAuth

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/core/constants/app_assets.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';

class TaglinePage extends StatelessWidget {
  const TaglinePage({super.key});

  static const _description =
      'Bimbel Lazuardy adalah platform bimbingan belajar inovatif yang dirancang untuk '
      'mewujudkan proses belajar tanpa batas dengan pengalaman yang nyaman dan terpersonalisasi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Kita asumsikan default navigasi ke beranda siswa, karena di sini tidak ada pilihan role
            Navigator.of(context).pushReplacementNamed('/siswa/beranda');
          }
          if (state is AuthOAuthRegistrationRequired) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Silakan lengkapi pendaftaran Anda.')),
            );
            Navigator.of(context).pushNamed('/login');
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: AppColors.errorRed),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SafeArea(
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
                    AppAssets.logoIcon,
                    height: 50,
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: const Text(
                      'Bimbel Lazuardy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
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
                  Navigator.of(context).pushNamed('/login');
                },
              ),

              const SizedBox(height: 20),

              // ── Divider "atau" ────────────────────────────────
              const OrDivider(),

              const SizedBox(height: 20),

              // ── OAuth Buttons ─────────────────────────────────
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                GoogleSignInButton(
                  onPressed: () {
                    context.read<AuthCubit>().loginWithGoogle();
                  },
                ),

                const SizedBox(height: 12),

                FacebookSignInButton(
                  onPressed: () {
                    context.read<AuthCubit>().loginWithFacebook();
                  },
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    },
  ));
  }
}