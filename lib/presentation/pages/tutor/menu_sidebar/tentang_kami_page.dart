// lib/presentation/pages/tentang_kami_page.dart
// Tentang Kami — logo full, 2 paragraf, footer sosmed

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazuadry_mobile_fe/core/constants/app_assets.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _fbBlue = Color(0xFF1877F2);
const _igGradStart = Color(0xFFF58529);
const _igGradEnd = Color(0xFF833AB4);

class TentangKamiPage extends StatelessWidget {
  const TentangKamiPage({super.key});

  static const _fbUrl = 'https://facebook.com/bimbellazuardy';
  static const _igUrl = 'https://instagram.com/bimbellazuardy';

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Tentang Kami',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const SizedBox(height: 8),

                // ── Logo full (ikon+nama+tagline) ───────────────
                // Pakai logo_lazuardi.png (background hitam)
                // Wrap dengan container putih agar bersih
                Image.asset(
                  AppAssets.logoFull,
                  height: 160,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 28),

                // ── Deskripsi ───────────────────────────────────
                const Text(
                  'Bimbel Lazuardi adalah platform bimbingan belajar privat yang hadir untuk membantu siswa belajar dengan lebih fokus, fleksibel, dan sesuai kebutuhan. Kami percaya bahwa setiap siswa memiliki cara belajar yang berbeda, sehingga pendekatan privat menjadi solusi terbaik untuk mendukung prestasi akademik mereka.',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.7),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dengan aplikasi Lazuardi, siswa dapat dengan mudah menemukan tutor berpengalaman yang siap mengajar berbagai mata pelajaran. Proses belajar dapat dilakukan secara tatap muka maupun online, sehingga memberikan keleluasaan bagi siswa dalam memilih metode belajar yang paling nyaman.',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.7),
                ),
              ]),
            ),
          ),

          // ── Footer sosmed (sticky bottom) ──────────────────────
          Column(children: [
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(children: [
                const Text(
                  'Temukan kami di sosial media',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Facebook button
                    _SosmedButton(
                      label: 'Facebook',
                      icon: Icons.facebook_rounded,
                      color: _fbBlue,
                      onTap: () => _open(_fbUrl),
                    ),
                    // Instagram button
                    _SosmedButton(
                      label: 'Instagram',
                      icon: Icons.camera_alt_outlined,
                      color: _igGradStart,
                      onTap: () => _open(_igUrl),
                      isGradient: true,
                    ),
                  ],
                ),
              ]),
            ),
          ]),
        ],
      ),
    );
  }
}

class _SosmedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isGradient;

  const _SosmedButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ]),
      ),
    );
  }
}