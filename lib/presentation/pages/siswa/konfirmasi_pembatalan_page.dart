// lib/presentation/pages/siswa/konfirmasi_pembatalan_page.dart

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);

class KonfirmasiPembatalanPage extends StatelessWidget {
  const KonfirmasiPembatalanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsArgs = ModalRoute.of(context)?.settings.arguments;
    final args = settingsArgs is Map ? settingsArgs.cast<String, String>() : null;
    final alasan = args?['alasan'] ?? 'Lainnya';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal, foregroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Konfirmasi Pembatalan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Row(children: [
          Expanded(child: SizedBox(height: 52, child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.textPrimary,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Kembali', style: TextStyle(fontSize: 15)),
          ))),
          const SizedBox(width: 12),
          Expanded(child: SizedBox(height: 52, child: ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/siswa/sesi-dibatalkan'),
            style: ElevatedButton.styleFrom(backgroundColor: _teal, foregroundColor: Colors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Ya, Batalkan Sesi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ))),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 8),

          // Detail pembatalan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Detail Pembatalan', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 14),
              _row('Tutor', 'Ibu Sarah'),
              _divider(),
              _row('Mata Pelajaran', 'Matematika'),
              _divider(),
              _row('Hari', 'Rabu, 1 April 2026'),
              _divider(),
              _row('Jam', '14:00 - 15:00'),
              _divider(),
              _row('Mode', 'Offline'),
              _divider(),
              _row('Alasan', alasan),
            ]),
          ),

          const SizedBox(height: 16),

          // Warning merah
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFE53E3E), size: 18),
              SizedBox(width: 10),
              Expanded(child: Text(
                'Pembatalan dilakukan kurang dari 12 jam sebelum sesi dimulai. Kuota sesi akan hangus dan tidak dapat dikembalikan.',
                style: TextStyle(fontSize: 12, color: Color(0xFFE53E3E), height: 1.5))),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ]));

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade200);
}