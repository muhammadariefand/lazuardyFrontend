// lib/presentation/pages/siswa/notifikasi_page.dart
// IHalaman Notifikasi — list 4 tipe notif

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';


// ── Tipe notif ────────────────────────────────────────────────────
enum _NotifType { sesiMulai, booking, laporan, sesiSelesai }

class _NotifItem {
  final _NotifType type;
  final String judul, subjudul, waktu;
  const _NotifItem({
    required this.type,
    required this.judul,
    required this.subjudul,
    required this.waktu,
  });
}

class NotifikasiSiswaPage extends StatelessWidget {
  const NotifikasiSiswaPage({super.key});

  static const _notifList = [
    _NotifItem(
      type: _NotifType.sesiMulai,
      judul: 'Sesi dimulai 1 jam lagi',
      subjudul: 'Matematika dengan Ibu Sarah pukul 14:00',
      waktu: 'Hari ini,  13:00',
    ),
    _NotifItem(
      type: _NotifType.booking,
      judul: 'Booking diterima',
      subjudul: 'Pak Ahmad menerima booking fisika anda',
      waktu: 'Kemarin,  09:00',
    ),
    _NotifItem(
      type: _NotifType.laporan,
      judul: 'Laporan tersedia',
      subjudul: 'Laporan sesi B.Inggris  sudah bisa dilihat',
      waktu: '28 Maret 2026, 10.00',
    ),
    _NotifItem(
      type: _NotifType.sesiSelesai,
      judul: 'Sesi Selesai',
      subjudul: 'Konfirmasi penyelesaian sesi Kimia',
      waktu: '27 Maret 2026, 14.00',
    ),
  ];

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
        title: const Text('Notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: _notifList.isEmpty
          ? _buildEmpty()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _NotifCard(item: _notifList[i]),
            ),
    );
  }

  Widget _buildEmpty() => const Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('🔔', style: TextStyle(fontSize: 48)),
      SizedBox(height: 12),
      Text('Tidak ada notifikasi',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
    ]),
  );
}

// ── Kartu notifikasi ──────────────────────────────────────────────
class _NotifCard extends StatelessWidget {
  final _NotifItem item;
  const _NotifCard({required this.item});

  IconData get _icon {
    switch (item.type) {
      case _NotifType.sesiMulai:   return Icons.access_time_rounded;
      case _NotifType.booking:     return Icons.calendar_month_rounded;
      case _NotifType.laporan:     return Icons.menu_book_rounded;
      case _NotifType.sesiSelesai: return Icons.star_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03),
              blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Icon
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),

        // Konten
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.judul,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 3),
            Text(item.subjudul,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4)),
            const SizedBox(height: 4),
            Text(item.waktu,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400)),
          ]),
        ),
      ]),
    );
  }
}