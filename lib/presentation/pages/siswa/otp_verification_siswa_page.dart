// lib/presentation/pages/siswa/otp_verification_siswa_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Tambahkan ini
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart'; // Tambahkan ini
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart'; // Tambahkan ini
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

class OtpVerificationSiswaPage extends StatefulWidget {
  final String? email;
  final String context;

  const OtpVerificationSiswaPage({
    super.key,
    this.email,
    this.context = 'register',
  });

  @override
  State<OtpVerificationSiswaPage> createState() => _OtpVerificationSiswaPageState();
}

class _OtpVerificationSiswaPageState extends State<OtpVerificationSiswaPage> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  static const _initialSeconds = 3300;
  int _remainingSeconds = _initialSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = _initialSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String get _timerText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get _timerExpired => _remainingSeconds == 0;
  String get _otpValue => _controllers.map((c) => c.text).join();
  bool get _isOtpComplete => _otpValue.length == 4;

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  // ── Fungsi Verifikasi Baru ───────────────────────────────────
  void _onVerify(String email) {
    if (!_isOtpComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 4 digit kode OTP'), backgroundColor: Colors.orange),
      );
      return;
    }

    // Panggil Cubit
    context.read<AuthCubit>().studentVerifyOtpRegisterEmail(
          email: email,
          otp: _otpValue,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil arguments sebagai Map
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String emailArg = args?['email'] as String? ?? widget.email ?? "";
    final String passwordArg = args?['password'] as String? ?? "";

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is VerifyOtpRegisterEmailSuccess) {
                // Navigasi ke halaman detail pribadi sambil meneruskan email dan password
                Navigator.of(context).pushNamed('/siswa/detail-pribadi', arguments: {
                  'email': emailArg,
                  'password': passwordArg,
                });
              }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.errorRed,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  const SizedBox(height: 48),
                  Center(
                    child: Column(
                      children: [
                        const Text('Verifikasi Kode OTP', style: AppTextStyles.heading1),
                        const SizedBox(height: 12),
                        Text(
                          'Masukkan kode OTP yang telah kami\nkirim ke email $emailArg',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.55),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (i) => _OtpBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        isFilled: _controllers[i].text.isNotEmpty,
                        onChanged: (v) => _onDigitChanged(i, v),
                        enabled: state is! AuthLoading, // Matikan input saat loading
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Kode berlaku dalam  ', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                          TextSpan(
                            text: _timerText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _timerExpired ? AppColors.errorRed : AppColors.textTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    label: 'Verifikasi',
                    onPressed: () => _onVerify(emailArg),
                    isLoading: state is AuthLoading, // Loading otomatis dari Cubit
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Belum Menerima Kode? ', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                        GestureDetector(
                          onTap: (state is! AuthLoading && _timerExpired) ? _onResend : null,
                          child: Text(
                            'Kirim Lagi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _timerExpired ? AppColors.primary : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onResend() {
    if (!_timerExpired) return;
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    _startTimer();
    // Di sini kamu bisa memanggil lagi cubit.studentRegisterOtpEmail(email)
  }
}

// Tambahkan parameter 'enabled' di _OtpBox agar input bisa dikunci saat loading
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFilled;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.isFilled,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 68, height: 68,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFilled ? AppColors.primary : AppColors.borderColor,
          width: isFilled ? 2.0 : 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textTeal),
        decoration: const InputDecoration(counterText: '', border: InputBorder.none),
        onChanged: onChanged,
      ),
    );
  }
}