// lib/presentation/pages/orangtua/verifikasi_otp_tautkan_page.dart
// Verifikasi Kode OTP
// - AppBar putih hanya back button
// - Judul "Verifikasi Kode OTP" (teal)
// - Subtitle
// - 4 kotak OTP (rounded square)
// - Timer countdown "Kode berlaku dalam 55:00"
// - Tombol "Verifikasi"
// - "Belum Menerima Kode? Kirim Lagi"
//
// Dialog "Akun Tertaut!" setelah verifikasi sukses
// - Icon centang hijau
// - Judul + deskripsi
// - Tombol "Ke Beranda"

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);

class VerifikasiOtpTautkanPage extends StatefulWidget {
  final String emailAnak;

  const VerifikasiOtpTautkanPage({super.key, required this.emailAnak});

  @override
  State<VerifikasiOtpTautkanPage> createState() =>
      _VerifikasiOtpTautkanPageState();
}

class _VerifikasiOtpTautkanPageState
    extends State<VerifikasiOtpTautkanPage> {
  // ── 4 controller & focusNode OTP ─────────────────────────────
  final List<TextEditingController> _otpCtrl =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(4, (_) => FocusNode());

  bool _isLoading = false;

  // ── Timer 55 menit (3300 detik) ───────────────────────────────
  static const _initialSeconds = 55 * 60;
  int _remainingSeconds = _initialSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpCtrl) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  // ── Timer ─────────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = _initialSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String get _timerLabel {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _timerExpired => _remainingSeconds <= 0;

  // ── Verifikasi ────────────────────────────────────────────────
  Future<void> _verifikasi() async {
    final otp = _otpCtrl.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan 4 digit kode OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    // TODO: panggil API verifikasi OTP
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);

    _showAkunTertautDialog();
  }

  // ── Kirim Lagi ────────────────────────────────────────────────
  Future<void> _kirimLagi() async {
    for (final c in _otpCtrl) c.clear();
    _focusNodes[0].requestFocus();
    _startTimer();
    // TODO: panggil API kirim ulang OTP
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kode OTP telah dikirim ulang'),
        backgroundColor: _teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Dialog Akun Tertaut (Image 3) ─────────────────────────────
  void _showAkunTertautDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _teal.withOpacity(0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon centang hijau
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFF2E7D32), width: 3),
                ),
                child: const Icon(Icons.check_rounded,
                    color: Color(0xFF2E7D32), size: 40),
              ),
              const SizedBox(height: 20),

              const Text(
                'Akun Tertaut!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Akun Anak Berhasil ditautkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sekarang anda dapat memantau\npembelajaran anak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Tombol ke beranda
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/orangtua/beranda',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ke Beranda',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textSecondary, size: 24),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // ── Judul ─────────────────────────────────
                    const Text(
                      'Verifikasi Kode OTP',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _teal,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Subtitle ──────────────────────────────
                    Text(
                      'Masukkan kode OTP yang telah kami kirim\nke email anak anda untuk melanjutkan',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // ── 4 Kotak OTP ───────────────────────────
                    _buildOtpRow(),
                    const SizedBox(height: 20),

                    // ── Timer ─────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Kode berlaku dalam  ',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary),
                        ),
                        Text(
                          _timerLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _timerExpired
                                ? Colors.red
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // ── Tombol Verifikasi ─────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (_isLoading || _timerExpired) ? null : _verifikasi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _teal,
                          disabledBackgroundColor:
                              _teal.withOpacity(0.4),
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white),
                              )
                            : const Text(
                                'Verifikasi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Kirim Lagi ────────────────────────────
                    GestureDetector(
                      onTap: _timerExpired ? _kirimLagi : null,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 14),
                          children: [
                            const TextSpan(
                              text: 'Belum Menerima Kode? ',
                              style: TextStyle(
                                  color: AppColors.textSecondary),
                            ),
                            TextSpan(
                              text: 'Kirim Lagi',
                              style: TextStyle(
                                color: _timerExpired
                                    ? _teal
                                    : _teal.withOpacity(0.4),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 4 Kotak OTP ───────────────────────────────────────────────
  Widget _buildOtpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (i) => _buildOtpBox(i)),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 68,
      height: 68,
      child: TextFormField(
        controller: _otpCtrl[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        onChanged: (val) {
          if (val.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          // Auto submit jika 4 digit terisi
          final otp = _otpCtrl.map((c) => c.text).join();
          if (otp.length == 4) {
            FocusScope.of(context).unfocus();
          }
          setState(() {});
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: _otpCtrl[index].text.isNotEmpty
                  ? _teal
                  : _teal.withOpacity(0.35),
              width: _otpCtrl[index].text.isNotEmpty ? 2 : 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _teal, width: 2),
          ),
        ),
      ),
    );
  }
}