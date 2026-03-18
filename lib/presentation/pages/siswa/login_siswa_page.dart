// lib/presentation/pages/siswa/login_siswa_page.dart
// Login — tab Siswa/Tutor/Orang Tua, form, ingat saya, OAuth

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

// Tipe role user
enum UserRole { siswa, tutor, orangTua }

class LoginSiswaPage extends StatefulWidget {
  const LoginSiswaPage({super.key});

  @override
  State<LoginSiswaPage> createState() => _LoginSiswaPageState();
}

class _LoginSiswaPageState extends State<LoginSiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  UserRole _selectedRole = UserRole.siswa;
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            _emailCtrl.text,
            _passwordCtrl.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Back Button ───────────────────────────
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    const SizedBox(height: 20),

                    // ── Logo ──────────────────────────────────
                    const BimbelLogo(size: 80),

                    const SizedBox(height: 16),

                    // ── Judul "Masuk" ─────────────────────────
                    const Text('Masuk', style: AppTextStyles.heading1),

                    const SizedBox(height: 16),

                    // ── Tab Siswa / Tutor / Orang Tua ─────────
                    _RoleTabSelector(
                      selectedRole: _selectedRole,
                      onChanged: (role) => setState(() => _selectedRole = role),
                    ),

                    const SizedBox(height: 24),

                    // ── Email Field ───────────────────────────
                    const Text('Email', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: AppTheme.inputDecoration(
                        hint: 'Masukan Email Anda',
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.textSecondary, size: 20),
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

                    // ── Password Field ────────────────────────
                    const Text('Kata Sandi', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordCtrl,
                      enabled: !isLoading,
                      obscureText: _obscurePassword,
                      decoration: AppTheme.inputDecoration(
                        hint: 'Masukan Kata Sandi',
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
                        if (v.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // ── Ingat Saya + Lupa Password ────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RememberMeCheckbox(
                          value: _rememberMe,
                          onChanged: (v) =>
                              setState(() => _rememberMe = v ?? false),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: navigasi lupa password
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 36),
                          ),
                          child: const Text(
                            'Lupa kata Sandi ?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Tombol Masuk ──────────────────────────
                    PrimaryButton(
                      label: 'Masuk',
                      onPressed: _onLogin,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: 24),

                    // ── Divider ───────────────────────────────
                    const OrDivider(),

                    const SizedBox(height: 20),

                    // ── OAuth ─────────────────────────────────
                    GoogleSignInButton(onPressed: () {}),
                    const SizedBox(height: 12),
                    FacebookSignInButton(onPressed: () {}),

                    const SizedBox(height: 20),

                    // ── Daftar Link ───────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum Punya Akun? ',
                            style: AppTextStyles.bodySecondary),
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/register'),
                          child: const Text('Daftar',
                              style: AppTextStyles.linkTeal),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Role Tab Selector Widget ─────────────────────────────────────
class _RoleTabSelector extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onChanged;

  const _RoleTabSelector({
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.tabBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: UserRole.values.map((role) {
          final isSelected = selectedRole == role;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: Text(
                  _roleLabel(role),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.siswa:
        return 'Siswa';
      case UserRole.tutor:
        return 'Tutor';
      case UserRole.orangTua:
        return 'Orang Tua';
    }
  }
}