// lib/presentation/pages/siswa/booking/konfirmasi_booking_page.dart
// Konfirmasi Booking — detail booking + kuota sesi info
// Online: Tutor/Mapel/Hari/Jam/Mode
// Offline: + Alamat + Link Maps

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _orange = Color(0xFFF59E0B);

class KonfirmasiBookingPage extends StatefulWidget {
  const KonfirmasiBookingPage({super.key});
  @override
  State<KonfirmasiBookingPage> createState() => _KonfirmasiBookingPageState();
}

class _KonfirmasiBookingPageState extends State<KonfirmasiBookingPage> {
  bool _isLoading = false;

  void _onKonfirmasi() async {
    setState(() => _isLoading = true);
    // TODO: panggil use case booking
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
      Navigator.pushReplacementNamed(context, '/siswa/booking/berhasil',
          arguments: args);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    final tutorNama = args['tutor_nama'] as String? ?? 'Ibu Sarah';
    final mapel = args['mapel'] as String? ?? 'Matematika';
    final hari = args['hari'] as String? ?? 'Rabu, 1 April';
    final jam = args['jam'] as String? ?? '14:00 - 15:00';
    final metode = args['metode'] as String? ?? 'online';
    final isOffline = metode == 'offline';
    final alamat = args['alamat'] as String? ?? '';
    final maps = args['maps'] as String? ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Konfirmasi Booking',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onKonfirmasi,
            style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: _isLoading
                ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text('Konfirmasi Booking',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 4),

          // ── Detail Booking ───────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Detail Booking',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 14),
              _row('Tutor', tutorNama),
              _divider(),
              _row('Mata Pelajaran', mapel),
              _divider(),
              _row('Hari', hari),
              _divider(),
              _row('Jam', jam),
              _divider(),
              _row('Mode', metode == 'online' ? 'Online' : 'Offline'),
              if (isOffline && alamat.isNotEmpty) ...[
                _divider(),
                _row('Alamat', alamat),
              ],
              if (isOffline && maps.isNotEmpty) ...[
                _divider(),
                _row('Link Maps', maps),
              ],
            ]),
          ),

          const SizedBox(height: 16),

          // ── Kuota Sesi info ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.menu_book_outlined, color: _orange, size: 20),
              const SizedBox(width: 10),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Kuota Sesi',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                        color: Color(0xFF92400E))),
                SizedBox(height: 4),
                Text(
                  '1 sesi akan dikurangkan dari kuota Anda Jika tutor menoak kuota, kuota akan dikembalikan. '
                  'Pembatalan dapat dilakukan maksimal 12 jam setelah waktu booking. '
                  'Jika melewati batas waktu tersebut, maka kuota akan hangus.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.5),
                ),
              ])),
            ]),
          ),

          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      Flexible(child: Text(value,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
    ]));

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade200);
}