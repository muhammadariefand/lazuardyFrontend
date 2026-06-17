// lib/presentation/pages/siswa/kode_pembayaran_page.dart
// Nomor VA + copy, countdown 24 jam, cara pembayaran

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _priceRed = AppColors.errorRed;

class KodePembayaranPage extends StatefulWidget {
  const KodePembayaranPage({super.key});
  @override
  State<KodePembayaranPage> createState() => _KodePembayaranPageState();
}

class _KodePembayaranPageState extends State<KodePembayaranPage> {
  // Countdown 24 jam = 86400 detik
  static const _totalSeconds = 86400;
  int _remainingSeconds = _totalSeconds;
  Timer? _timer;
  bool _copied = false;

  static const _vaNumber = '8900 9876 5432 1098';
  static const _totalBayar = 200000;

  static const _caraPembayaran = [
    'Buka aplikasi mobile banking atau ATM',
    'Pilih menu Transfer/Virtual Account',
    'Masukan nomor Virtual Account',
    'Konfirmasi jumlah pembayaran',
    'Pembayaran akan diverifikasi otomatis',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String get _timerText {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  void _copyVA() async {
    await Clipboard.setData(
        const ClipboardData(text: '890098765432 1098'));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Nomor VA berhasil disalin'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(
        const Duration(seconds: 2), () => setState(() => _copied = false));
  }

  void _onSudahBayar() {
    Navigator.pushReplacementNamed(context, '/siswa/pembayaran-berhasil');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final bank = args?['bank'] ?? 'MANDIRI';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Kode Pembayaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _onSudahBayar,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text('Saya Sudah Bayar',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 4),

          // ── Kartu utama VA ───────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10)
              ],
            ),
            child: Column(children: [
              // Metode pembayaran
              const Text('Metode Pembayaran',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(
                'Transfer Bank $bank',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),

              const SizedBox(height: 20),

              // Nomor VA
              const Text('Nomor Virtual Account',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 8),

              // VA box dengan copy button
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_vaNumber,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: 1.2)),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _copyVA,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _copied
                              ? const Icon(Icons.check_circle_rounded,
                                  color: AppColors.successGreen, size: 22,
                                  key: ValueKey('check'))
                              : Icon(Icons.copy_rounded,
                                  color: Colors.grey.shade500, size: 22,
                                  key: const ValueKey('copy')),
                        ),
                      ),
                    ]),
              ),

              const SizedBox(height: 20),

              // Total pembayaran
              const Text('Total Pembayaran',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(_formatRupiah(_totalBayar),
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: _priceRed)),

              const SizedBox(height: 16),

              // Countdown timer
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.access_time_rounded,
                    color: AppColors.warningYellow, size: 18),
                const SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Bayar sebelum ',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warningYellow),
                      ),
                      TextSpan(
                        text: _timerText,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.warningYellow),
                      ),
                    ],
                  ),
                ),
              ]),
            ]),
          ),

          const SizedBox(height: 16),

          // ── Cara pembayaran ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8)
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text('Cara Pembayaran:',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              const SizedBox(height: 10),
              ..._caraPembayaran.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${e.key + 1}. ',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500)),
                          Expanded(
                            child: Text(e.value,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    height: 1.4)),
                          ),
                        ]),
                  )),
            ]),
          ),

          const SizedBox(height: 12),

          // ── Info escrow ──────────────────────────────────────
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Icon(Icons.shield_outlined,
                  color: Colors.grey.shade500, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Dana Anda aman Melalui escrow lembaga',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}