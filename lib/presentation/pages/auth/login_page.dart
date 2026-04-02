// lib/presentation/pages/login_page.dart
// Halaman Login terpadu — tab Siswa / Tutor / Orang Tua
// Routing:
// Siswa     --> login: /siswa/beranda  | daftar: /siswa/register
// Tutor     --> login: /tutor/beranda  | daftar: /tutor/register
// Orang Tua --> login saja (tidak ada daftar, gunakan akun anak)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

enum UserRole { siswa, tutor, orangTua }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  void _onRoleChanged(UserRole role) {
    setState(() {
      _selectedRole = role;
      _emailCtrl.clear();
      _passwordCtrl.clear();
      _formKey.currentState?.reset();
    });
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            _emailCtrl.text.trim(),
            _passwordCtrl.text,
          );
    }
  }

  // Navigasi beranda sesuai role setelah login sukses
  void _navigateAfterLogin() {
    switch (_selectedRole) {
      case UserRole.siswa:
        Navigator.of(context).pushReplacementNamed('/siswa/beranda');
        break;
      case UserRole.tutor:
        Navigator.of(context).pushReplacementNamed('/tutor/beranda');
        break;
      case UserRole.orangTua:
        Navigator.of(context).pushReplacementNamed('/orang-tua/beranda');
        break;
    }
  }

  // Navigasi daftar sesuai role (tidak dipanggil untuk Orang Tua)
  void _navigateToRegister() {
    switch (_selectedRole) {
      case UserRole.siswa:
        Navigator.of(context).pushNamed('/siswa/register');
        break;
      case UserRole.tutor:
        Navigator.of(context).pushNamed('/tutor/register');
        break;
      case UserRole.orangTua:
        break; // tidak akan terjadi
    }
  }

  String get _forgotPasswordRoute {
    switch (_selectedRole) {
      case UserRole.siswa:
      case UserRole.orangTua:
        return '/siswa/forgot-password';
      case UserRole.tutor:
        return '/tutor/forgot-password';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) _navigateAfterLogin();
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ));
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
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 20),
                    const BimbelLogo(size: 80),
                    const SizedBox(height: 16),
                    const Text('Masuk', style: AppTextStyles.heading1),
                    const SizedBox(height: 16),

                    // Tab role
                    _RoleTabSelector(selected: _selectedRole, onChanged: _onRoleChanged),
                    const SizedBox(height: 20),

                    // Info banner khusus Orang Tua
                    if (_selectedRole == UserRole.orangTua) ...[
                      const _InfoBanner(
                        message: 'Gunakan email dan password akun anak Anda untuk masuk sebagai orang tua.',
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email
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
                        if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Kata Sandi
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
                            color: AppColors.textSecondary, size: 20,
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

                    // Ingat saya + Lupa password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RememberMeCheckbox(
                          value: _rememberMe,
                          onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(_forgotPasswordRoute),
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
                    PrimaryButton(label: 'Masuk', onPressed: _onLogin, isLoading: isLoading),
                    const SizedBox(height: 24),
                    const OrDivider(),
                    const SizedBox(height: 20),
                    GoogleSignInButton(onPressed: () {}),
                    const SizedBox(height: 12),
                    FacebookSignInButton(onPressed: () {}),
                    const SizedBox(height: 20),

                    // Daftar — HANYA untuk Siswa & Tutor, Orang Tua tidak muncul
                    if (_selectedRole != UserRole.orangTua)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum Punya Akun? ',
                              style: AppTextStyles.bodySecondary),
                          GestureDetector(
                            onTap: _navigateToRegister,
                            child: const Text('Daftar', style: AppTextStyles.linkTeal),
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

// ── Tab Selector ───────────────────────────────────────────────────
class _RoleTabSelector extends StatelessWidget {
  final UserRole selected;
  final ValueChanged<UserRole> onChanged;
  const _RoleTabSelector({required this.selected, required this.onChanged});

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
          final isSelected = selected == role;
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
                  _label(role),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(UserRole role) {
    switch (role) {
      case UserRole.siswa: return 'Siswa';
      case UserRole.tutor: return 'Tutor';
      case UserRole.orangTua: return 'Orang Tua';
    }
  }
}

// ── Info Banner kuning ─────────────────────────────────────────────
class _InfoBanner extends StatelessWidget {
  final String message;
  const _InfoBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE082), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFFF59E0B), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF92400E),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}