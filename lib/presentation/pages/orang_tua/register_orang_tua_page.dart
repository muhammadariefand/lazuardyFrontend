// lib/presentation/pages/orang_tua/register_orang_tua_page.dart
// Register — email, password, konfirmasi password, ingat saya, OAuth

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/enums/role_enum.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

class RegisterOrangTuaPage extends StatefulWidget {
  const RegisterOrangTuaPage({super.key});

  @override
  State<RegisterOrangTuaPage> createState() => _RegisterOrangTuaPageState();
}

class _RegisterOrangTuaPageState extends State<RegisterOrangTuaPage> {
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

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().registerOtpEmail(_emailCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is RegisterOtpEmailSuccess) {
              Navigator.of(context).pushNamed(
                '/register/verifikasi-otp',
                arguments: {
                  'email': _emailCtrl.text.trim(),
                  'password': _passwordCtrl.text,
                  'role': RoleEnum.parent,
                },
              );
            }

            if (state is AuthFailure) {
              final errorDetails = state.errorDetails;
              String errorMessage;

              if (errorDetails != null && errorDetails.containsKey('email')) {
                errorMessage = errorDetails['email'][0];
              } else {
                errorMessage = state.error;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    const SizedBox(height: 20),

                    const BimbelLogo(size: 80),

                    const SizedBox(height: 16),

                    const Text(
                      'Daftar sebagai orang tua',
                      style: AppTextStyles.heading1,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Text(
                          'Sudah Punya Akun ? ',
                          style: AppTextStyles.bodySecondary,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Masuk',
                            style: AppTextStyles.linkTeal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text('Email', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: AppTheme.inputDecoration(
                        hint: 'Masukan Email Anda',
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

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kata Sandi', style: AppTextStyles.label),
                        Text(
                          'Kata sandi minimal 8 karakter',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordCtrl,
                      enabled: !isLoading,
                      obscureText: _obscurePassword,
                      decoration: AppTheme.inputDecoration(
                        hint: 'Masukkan Kata Sandi',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Password wajib diisi';
                        if (v.length < 8) return 'Minimal 8 karakter';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Konfirmasi Kata Sandi',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordCtrl,
                      enabled: !isLoading,
                      obscureText: _obscureConfirm,
                      decoration: AppTheme.inputDecoration(
                        hint: 'Masukkan Konfirmasi Kata Sandi',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          }),
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

                    RememberMeCheckbox(
                      value: _rememberMe,
                      onChanged: (v) =>
                          setState(() => _rememberMe = v ?? false),
                    ),

                    const SizedBox(height: 24),

                    PrimaryButton(
                      label: 'Daftar',
                      onPressed: _onRegister,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: 24),

                    const OrDivider(),

                    const SizedBox(height: 20),

                    GoogleSignInButton(onPressed: () {}),
                    const SizedBox(height: 12),
                    FacebookSignInButton(onPressed: () {}),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
