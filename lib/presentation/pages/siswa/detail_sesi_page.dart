// lib/presentation/pages/siswa/detail_sesi_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);

class DetailSesiPage extends StatelessWidget {
  const DetailSesiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Detail Sesi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 8),

          // Kartu tutor
          _buildTutorCard(),
          const SizedBox(height: 16),

          // Info sesi
          _buildInfoCard(),
          const SizedBox(height: 16),

          // Alamat
          _buildAlamatCard(context),
          const SizedBox(height: 16),

          // Info pengingat
          _buildInfoBanner('Pengingat otomatis akan dikirim 1 jam sebelum sesi dimulai.', const Color(0xFFFFF8E1), const Color(0xFFF59E0B)),
          const SizedBox(height: 24),

          // Tombol batalkan
          SizedBox(width: double.infinity, height: 52,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/siswa/batalkan-sesi'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE53E3E), width: 1.5),
                foregroundColor: const Color(0xFFE53E3E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.cancel_outlined, size: 20),
              label: const Text('Batalkan Sesi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            )),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _buildTutorCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _teal.withOpacity(0.4)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
    child: Row(children: [
      Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center, child: Text('S', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.grey.shade500))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Ibu Sarah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _teal)),
        Row(children: [
          const Text('Matematika', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(20)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.chat_rounded, size: 12, color: Colors.white),
              SizedBox(width: 4),
              Text('WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
            ])),
        ]),
      ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(20)),
        child: const Text('Terjadwal', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B)))),
    ]),
  );

  Widget _buildInfoCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _teal.withOpacity(0.4)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
    child: Column(children: [
      _infoRow(Icons.access_time_outlined, 'Tanggal', 'Rabu, 1 April 2026'),
      const Divider(height: 20),
      _infoRow(Icons.calendar_today_outlined, 'Waktu', '14:00 - 15:00'),
      const Divider(height: 20),
      _infoRow(Icons.videocam_outlined, 'Mode', 'Offline'),
    ]),
  );

  Widget _infoRow(IconData icon, String label, String value) => Row(children: [
    Icon(icon, size: 22, color: AppColors.textSecondary),
    const SizedBox(width: 14),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ]),
  ]);

  Widget _buildAlamatCard(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _teal.withOpacity(0.4)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [
        Icon(Icons.location_on_outlined, size: 20, color: AppColors.textSecondary),
        SizedBox(width: 8),
        Text('Alamat Lokasi sesi', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ]),
      const SizedBox(height: 8),
      const Text('Jl. Melati Indah No. 24, RT 03/RW 05, Kel. Sumberrejo, Kec. Ngaglik, Kab. Sleman, DIY',
        style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5)),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () async {
          final uri = Uri.parse('https://maps.google.com/?q=Jl.+Melati+Indah+No.+24+Sleman');
          if (await canLaunchUrl(uri)) launchUrl(uri);
        },
        child: const Row(children: [
          Icon(Icons.open_in_new_rounded, size: 14, color: _teal),
          SizedBox(width: 4),
          Text('Buka di Google Maps', style: TextStyle(fontSize: 13, color: _teal, fontWeight: FontWeight.w500)),
        ]),
      ),
    ]),
  );

  Widget _buildInfoBanner(String message, Color bg, Color iconColor) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Icon(Icons.info_outline_rounded, color: iconColor, size: 18),
      const SizedBox(width: 10),
      Expanded(child: Text(message, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4))),
    ]),
  );
}