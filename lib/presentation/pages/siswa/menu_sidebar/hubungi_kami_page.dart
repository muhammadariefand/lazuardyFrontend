// lib/presentation/pages/hubungi_kami_page.dart
// Hubungi Kami — 3 kartu kontak (WA, Email, Alamat)

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';


class HubungiKamiPage extends StatelessWidget {
  const HubungiKamiPage({super.key});

  static const _wa    = '+6281234567890';
  static const _email = 'lazuardy@gmail.com';
  static const _alamat = 'Jl. Pendidikan No. 1, Bandung';

  Future<void> _openWA() async {
    final uri = Uri.parse('https://wa.me/${_wa.replaceAll('+', '')}');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openEmail() async {
    final uri = Uri.parse('mailto:$_email');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  Future<void> _openMaps() async {
    final uri = Uri.parse(
        'https://maps.google.com/?q=${Uri.encodeComponent(_alamat)}');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
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
        title: const Text('Hubungi Kami',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 8),
          const Text(
            'Ada kendala mengenai aplikasi Lazuardy?\nAyoo tanyakan melalui:',
            style: TextStyle(
                fontSize: 13, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 20),

          // ── WhatsApp ───────────────────────────────────────
          _KontakCard(
            iconWidget: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(
                color: AppColors.successGreen, shape: BoxShape.circle),
              child: const Icon(Icons.chat_rounded, color: Colors.white, size: 22),
            ),
            label: 'Nomor WhatsApp',
            value: '+62 812 34567890',
            onTap: _openWA,
          ),
          const SizedBox(height: 12),

          // ── Email ──────────────────────────────────────────
          _KontakCard(
            iconWidget: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: Colors.red.shade50, shape: BoxShape.circle),
              child: Icon(Icons.mail_rounded, color: Colors.red.shade600, size: 22),
            ),
            label: 'Email',
            value: _email,
            onTap: _openEmail,
          ),
          const SizedBox(height: 12),

          // ── Alamat ─────────────────────────────────────────
          _KontakCard(
            iconWidget: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: Colors.blue.shade50, shape: BoxShape.circle),
              child: const Icon(Icons.location_on_rounded,
                  color: Colors.redAccent, size: 22),
            ),
            label: 'Alamat',
            value: _alamat,
            onTap: _openMaps,
          ),
        ]),
      ),
    );
  }
}

class _KontakCard extends StatelessWidget {
  final Widget iconWidget;
  final String label, value;
  final VoidCallback onTap;

  const _KontakCard({
    required this.iconWidget,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04),
                blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          iconWidget,
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ]),
        ]),
      ),
    );
  }
}