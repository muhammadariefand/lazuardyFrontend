// lib/presentation/pages/siswa/ulasan_tutor_page.dart
// Riwayat Ulasan Tutor — list kartu ulasan dengan bintang parsial

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _starYellow = Color(0xFFFFB800);

class UlasanTutorPage extends StatelessWidget {
  const UlasanTutorPage({super.key});

  // Data dummy — ganti dengan data dari Cubit/API
  static const _ulasanList = [
    _UlasanItem(
      tutorNama: 'Ibu Sarah',
      mapel: 'Matematika',
      tanggal: '5 Maret 2026',
      rating: 5.0,
      ulasan: 'Penjelasan sangat jelas dan sabar, saya jadi paham aljabar',
    ),
    _UlasanItem(
      tutorNama: 'Pak Ahmad',
      mapel: 'Fisika',
      tanggal: '3 Maret 2026',
      rating: 4.0,
      ulasan: 'Bagus, tapi perlu banyak contoh soal.',
    ),
    _UlasanItem(
      tutorNama: 'Pak Budi',
      mapel: 'Kimia',
      tanggal: '28 Februari 2026',
      rating: 5.0,
      ulasan: 'Metode mengajar sangat interaktif dan menyenangkan',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ulasan Tutor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: _ulasanList.isEmpty
          ? _buildEmpty()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _ulasanList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _UlasanCard(item: _ulasanList[i]),
            ),
    );
  }

  Widget _buildEmpty() => const Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('⭐', style: TextStyle(fontSize: 48)),
      SizedBox(height: 12),
      Text('Belum ada ulasan',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
    ]),
  );
}

// ── Kartu ulasan ──────────────────────────────────────────────────
class _UlasanCard extends StatelessWidget {
  final _UlasanItem item;
  const _UlasanCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header: nama tutor + bintang
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.tutorNama,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: _teal)),
            _StarRow(rating: item.rating),
          ],
        ),
        const SizedBox(height: 3),

        // Mapel + tanggal
        Text('${item.mapel} • ${item.tanggal}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 12),

        // Teks ulasan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            item.ulasan,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textPrimary, height: 1.5),
          ),
        ),
      ]),
    );
  }
}

// ── Bintang parsial ───────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final double rating; // 1.0 – 5.0, mendukung setengah bintang
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starVal = i + 1;
        IconData icon;
        if (rating >= starVal) {
          icon = Icons.star_rounded;           // penuh
        } else if (rating >= starVal - 0.5) {
          icon = Icons.star_half_rounded;      // setengah
        } else {
          icon = Icons.star_outline_rounded;   // kosong
        }
        return Icon(icon, color: _starYellow, size: 16);
      }),
    );
  }
}

// ── Model ─────────────────────────────────────────────────────────
class _UlasanItem {
  final String tutorNama, mapel, tanggal, ulasan;
  final double rating;
  const _UlasanItem({
    required this.tutorNama,
    required this.mapel,
    required this.tanggal,
    required this.rating,
    required this.ulasan,
  });
}