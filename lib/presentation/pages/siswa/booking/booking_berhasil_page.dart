// lib/presentation/pages/siswa/booking/booking_berhasil_page.dart
// Booking Berhasil — dialog sukses dengan info sesi (Online/Offline)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';


class BookingBerhasilPage extends StatelessWidget {
  const BookingBerhasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    final tutorNama = args['tutor_nama'] as String? ?? 'Ibu Sarah';
    final mapel = args['mapel'] as String? ?? 'Matematika';
    final hari = args['hari'] as String? ?? 'Rabu, 1 April';
    final jam = args['jam'] as String? ?? '14:00 - 15:00';
    final metode = args['metode'] as String? ?? 'online';
    final modeLabel = metode == 'online' ? 'Online' : 'Offline';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              // Icon centang hijau
              Container(
                width: 68, height: 68,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.successGreen, width: 2.5)),
                child: const Icon(Icons.check_rounded, color: AppColors.successGreen, size: 38),
              ),

              const SizedBox(height: 20),

              const Text('Booking Berhasil!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),

              const SizedBox(height: 12),

              // Info ringkas sesi
              Text('Sesi dengan $tutorNama',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text('$mapel • $hari',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text('$jam • $modeLabel',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),

              const SizedBox(height: 20),

              // Info menunggu konfirmasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Menunggu konfirmasi dari tutor. Kuota sesi Anda berkurang 1.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF92400E),
                      height: 1.4),
                ),
              ),

              const SizedBox(height: 24),

              // Tombol kembali ke beranda
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/siswa/beranda', (_) => false),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('Kembali ke Dashboard',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}