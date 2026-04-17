// lib/presentation/pages/siswa/pembayaran_berhasil_page.dart
// Dialog sukses pembayaran — icon centang hijau

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _green = Color(0xFF4CAF50);

class PembayaranBerhasilPage extends StatelessWidget {
  const PembayaranBerhasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // Tidak ada AppBar — full dialog style
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _teal.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon centang hijau dalam lingkaran
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _green, width: 2.5),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: _green, size: 40),
                ),

                const SizedBox(height: 20),

                // Judul
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 10),

                // Deskripsi
                const Text(
                  'Paket 8 Sesi telah aktif',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                const Text(
                  '8 sesi ditambahkan ke akun Anda',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),

                const SizedBox(height: 28),

                // Tombol kembali ke beranda
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/siswa/beranda', (_) => false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
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