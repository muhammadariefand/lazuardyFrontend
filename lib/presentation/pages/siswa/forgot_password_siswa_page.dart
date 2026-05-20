// lib/presentation/pages/siswa/forgot_password_siswa_page.dart
// Lupa Kata Sandi — input email, tombol Selanjutnya → OTP

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';

class ForgotPasswordSiswaPage extends StatefulWidget {
  const ForgotPasswordSiswaPage({super.key});

  @override
  State<ForgotPasswordSiswaPage> createState() => _ForgotPasswordSiswaPageState();
}

class _ForgotPasswordSiswaPageState extends State<ForgotPasswordSiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSelanjutnya() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // Panggil cubit untuk mengirim OTP
      try {
        context.read<AuthCubit>().studentRequestOtp(_emailCtrl.text);
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengirim OTP: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpSentSuccess) {
          if (mounted) {
            setState(() => _isLoading = false);
            Navigator.of(context).pushNamed(
              '/siswa/otp-verification-forgot-password',
              arguments: {
                'email': _emailCtrl.text,
                'context': 'forgot_password',
              },
            );
          }
        } else if (state is AuthFailure) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Back Button ───────────────────────────────
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.textPrimary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                const SizedBox(height: 56),

                // ── Judul + Deskripsi (center) ────────────────
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Lupa Kata  Sandi ?',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTeal,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Silakan masukkan email Anda, kami akan\n'
                        'mengirimkan tautan untuk mengatur\n'
                        'ulang kata sandi dan memulihkan akses\n'
                        'akun Anda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // ── Label Email ───────────────────────────────
                const Text('Email', style: AppTextStyles.label),
                const SizedBox(height: 8),

                // ── Email Field ───────────────────────────────
                TextFormField(
                  controller: _emailCtrl,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSelanjutnya(),
                  decoration: AppTheme.inputDecoration(
                    hint: 'Masukan Email Sebelumnya',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // ── Tombol Selanjutnya ────────────────────────
                PrimaryButton(
                  label: 'Selanjutya',
                  onPressed: _onSelanjutnya,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}