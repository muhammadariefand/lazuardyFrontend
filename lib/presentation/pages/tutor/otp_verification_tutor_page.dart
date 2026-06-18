// lib/presentation/pages/tutor/otp_verification_tutor_page.dart
// Verifikasi Kode OTP
// Fitur: 4 box OTP dengan auto-focus, countdown timer, kirim lagi

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_state.dart';

class OtpVerificationTutorPage extends StatefulWidget {
  /// Email tujuan pengiriman OTP (untuk ditampilkan di deskripsi jika perlu)
  final String? email;

  /// Context asal: 'register' atau 'forgot_password'
  final String context;

  const OtpVerificationTutorPage({
    super.key,
    this.email,
    this.context = 'register',
  });

  @override
  State<OtpVerificationTutorPage> createState() => _OtpVerificationTutorPageState();
}

class _OtpVerificationTutorPageState extends State<OtpVerificationTutorPage> {
  // 4 controller & focus node untuk tiap digit OTP
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(4, (_) => FocusNode());

  // Countdown timer: 55 menit = 3300 detik
  static const _initialSeconds = 3300;
  int _remainingSeconds = _initialSeconds;
  Timer? _timer;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-fokus ke box pertama
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

  // ── Timer countdown ──────────────────────────────────────────
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
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  bool get _timerExpired => _remainingSeconds == 0;

  // ── Ambil nilai OTP lengkap ──────────────────────────────────
  String get _otpValue =>
      _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otpValue.length == 4;

  // ── Handle input per digit ───────────────────────────────────
  void _onDigitChanged(int index, String value) {
    if (value.length == 1) {
      // Maju ke box berikutnya
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Mundur ke box sebelumnya saat hapus
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  // ── Verifikasi OTP ───────────────────────────────────────────
  void _onVerify() {
    if (!_isOtpComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan 4 digit kode OTP'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.context == 'forgot_password') {
       // TODO: verify password reset OTP
       Navigator.of(context).pushNamed('/reset-password');
    } else {
       context.read<TutorRegistrationCubit>().verifyOtp(otp: _otpValue);
    }
  }

  // ── Kirim ulang OTP ──────────────────────────────────────────
  void _onResend() {
    if (!_timerExpired) return;

    // Reset semua field
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    _startTimer();

    // TODO: Panggil use case kirim ulang OTP
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kode OTP telah dikirim ulang'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TutorRegistrationCubit, TutorRegistrationState>(
      listener: (context, state) {
        if (state is TutorRegistrationLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is OtpVerifiedSuccess) {
            Navigator.of(context).pushNamed('/tutor/detail-pribadi');
          } else if (state is TutorRegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgWhite,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

              // ── Back button ───────────────────────────────
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.textPrimary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              const SizedBox(height: 48),

              // ── Judul + Deskripsi ─────────────────────────
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Verifikasi Kode OTP',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textTeal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Masukkan kode OTP yang telah kami\nkirim ke email Anda untuk melanjutkan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ── 4 OTP Boxes ───────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (i) => _OtpBox(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    isFilled: _controllers[i].text.isNotEmpty,
                    onChanged: (v) => _onDigitChanged(i, v),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Timer ─────────────────────────────────────
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Kode berlaku dalam  ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      TextSpan(
                        text: _timerText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _timerExpired
                              ? AppColors.errorRed
                              : AppColors.textTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Tombol Verifikasi ─────────────────────────
              PrimaryButton(
                label: 'Verifikasi',
                onPressed: _onVerify,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 24),

              // ── Kirim Lagi ────────────────────────────────
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Belum Menerima Kode? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: _timerExpired ? _onResend : null,
                      child: Text(
                        'Kirim Lagi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _timerExpired
                              ? AppColors.primary
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── OTP Single Box Widget ─────────────────────────────────────────
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFilled;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.isFilled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFilled ? AppColors.primary : AppColors.borderColor,
          width: isFilled ? 2.0 : 1.2,
        ),
        boxShadow: isFilled
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textTeal,
        ),
        decoration: const InputDecoration(
          counterText: '', // sembunyikan counter "0/1"
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}