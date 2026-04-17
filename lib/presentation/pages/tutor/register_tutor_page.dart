// lib/presentation/pages/tutor/register_tutor_page.dart
// Register — email, password, konfirmasi password, ingat saya, OAuth

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/otp/otp_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/otp/otp_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

class RegisterTutorPage extends StatefulWidget {
  const RegisterTutorPage({super.key});

  @override
  State<RegisterTutorPage> createState() => _RegisterTutorPageState();
}

class _RegisterTutorPageState extends State<RegisterTutorPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // TODO: Panggil register use case / cubit
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isLoading = false);
        // Navigasi ke halaman detail pribadi
        Navigator.of(context).pushNamed('/register/detail');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: BlocConsumer<OtpCubit, OtpState>(
              listener: (context, state) {
                if (state is OtpSendSuccess){
                  Navigator.of(context).pushNamed('/tutor/otp-verification', arguments: _emailCtrl.text);
                }
                if (state is OtpSendError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                return Column(
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

                    const SizedBox(height: 20),

                    // ── Logo ──────────────────────────────────────
                    const BimbelLogo(size: 80),

                    const SizedBox(height: 16),

                    // ── Judul ─────────────────────────────────────
                    const Text('Daftar sebagai tutor',
                        style: AppTextStyles.heading1),

                    const SizedBox(height: 6),

                    // ── Sudah Punya Akun ──────────────────────────
                    Row(
                      children: [
                        const Text('Sudah Punya Akun ? ',
                            style: AppTextStyles.bodySecondary),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Text('Masuk', style: AppTextStyles.linkTeal),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Email ─────────────────────────────────────
                    const Text('Email', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: AppTheme.inputDecoration(
                        hint: 'Masukan Email Anda',
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.textSecondary, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── Kata Sandi ────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kata Sandi', style: AppTextStyles.label),
                        Text(
                          'Kata sandi minimal 8 karakter',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordCtrl,
                      enabled: !_isLoading,
                      obscureText: _obscurePassword,
                      decoration: AppTheme.inputDecoration(
                        hint: 'Masukkan Kata Sandi',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.textSecondary, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password wajib diisi';
                        if (v.length < 8) return 'Minimal 8 karakter';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── Konfirmasi Kata Sandi ─────────────────────
                    const Text('Konfirmasi Kata Sandi', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordCtrl,
                      enabled: !_isLoading,
                      obscureText: _obscureConfirm,
                      decoration: AppTheme.inputDecoration(
                        hint: 'Masukkan Konfirmasi Kata Sandi',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.textSecondary, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Konfirmasi password wajib diisi';
                        }
                        if (v != _passwordCtrl.text) {
                          return 'Password tidak sama';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // ── Ingat Saya ────────────────────────────────
                    RememberMeCheckbox(
                      value: _rememberMe,
                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    ),

                    const SizedBox(height: 24),

                    // ── Tombol Daftar ─────────────────────────────
                    PrimaryButton(
                      label: 'Daftar',
                      onPressed: _onRegister,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 24),

                    // ── Divider ───────────────────────────────────
                    const OrDivider(),

                    const SizedBox(height: 20),

                    // ── OAuth ─────────────────────────────────────
                    GoogleSignInButton(onPressed: () {}),
                    const SizedBox(height: 12),
                    FacebookSignInButton(onPressed: () {}),

                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}