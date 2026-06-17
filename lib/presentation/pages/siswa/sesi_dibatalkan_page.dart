// lib/presentation/pages/siswa/sesi_dibatalkan_page.dart

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';


class SesiDibatalkanPage extends StatelessWidget {
  const SesiDibatalkanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16)]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Icon X merah
              Container(width: 72, height: 72,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.errorRed, width: 2)),
                child: const Icon(Icons.close_rounded, color: AppColors.errorRed, size: 38)),
              const SizedBox(height: 20),
              const Text('Sesi Dibatalkan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              const Text('Matematika dengan Ibu Sarah', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              const Text('Rabu, 1 April 2026', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              const Text('14:00 - 15:00 • Offline', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              // Banner kuota hangus
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Kuota sesi hangus', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.errorRed)),
                    SizedBox(height: 4),
                    Text('Pembatalan dilakukan kurang dari 12 jam sebelum sesi. Kuota sesi tidak dikembalikan.',
                      style: TextStyle(fontSize: 12, color: AppColors.errorRed, height: 1.4)),
                  ])),
                ]),
              ),
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/siswa/beranda', (_) => false),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Kembali ke Beranda', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                )),
            ]),
          ),
        ),
      ),
    );
  }
}