// lib/presentation/pages/orangtua/laporan_orangtua_page.dart
// Image 5: Laporan Pembelajaran
// - AppBar teal "Laporan Pembelajaran"
// - List card per mata pelajaran:
//   nama mapel (teal bold) + tutor • tanggal
//   sub-card abu: Topik (bold) + catatan

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_bottom_nav.dart';

const _teal = Color(0xFF3AAFA9);

// ── Model ─────────────────────────────────────────────────────────
class _LaporanData {
  final String mapel;
  final String namaTutor;
  final String tanggal;
  final String topik;
  final String catatan;

  const _LaporanData({
    required this.mapel,
    required this.namaTutor,
    required this.tanggal,
    required this.topik,
    required this.catatan,
  });
}

// ── Page ──────────────────────────────────────────────────────────
class LaporanOrangtuaPage extends StatelessWidget {
  const LaporanOrangtuaPage({super.key});

  static const _laporanList = [
    _LaporanData(
      mapel: 'Matematika',
      namaTutor: 'Ibu Sarah',
      tanggal: '5 Maret 2026',
      topik: 'Aljabar, Persamaan Linear',
      catatan:
          'Siswa memahami konsep aljabar dengan cepat.\nPerlu latihan soal cerita lebih banyak.',
    ),
    _LaporanData(
      mapel: 'Fisika',
      namaTutor: 'Pak Ahmad',
      tanggal: '3 Maret 2026',
      topik: 'Hukum Newton, Gaya',
      catatan: 'Siswa masih belum memahami hukum Newton dengan baik.',
    ),
    _LaporanData(
      mapel: 'Kimia',
      namaTutor: 'Pak Budi',
      tanggal: '28 Februari 2026',
      topik: 'Tabel Periodik, Reaksi Kimia',
      catatan:
          'Menguasai tabel periodik dan reaksi kimia dasar dengan sangat baik.',
    ),
    _LaporanData(
      mapel: 'B. Inggris',
      namaTutor: 'Pak Rinai',
      tanggal: '15 Februari 2026',
      topik: 'Grammar, Vocabulary',
      catatan:
          'Siswa cukup aktif dan mampu menyusun kalimat dengan baik.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: OrangTuaBottomNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/orangtua/beranda');
          if (i == 1) Navigator.pushReplacementNamed(context, '/orangtua/jadwal');
          if (i == 3) Navigator.pushReplacementNamed(context, '/orangtua/profil');
        },
      ),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _laporanList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _buildLaporanCard(_laporanList[i]),
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: _teal,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Laporan Pembelajaran',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── Card Laporan ──────────────────────────────────────────────
  Widget _buildLaporanCard(_LaporanData l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _teal.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mapel (teal)
          Text(
            l.mapel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _teal,
            ),
          ),
          const SizedBox(height: 2),
          // Tutor + tanggal
          Text(
            '${l.namaTutor} · ${l.tanggal}',
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Sub-card abu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Topik: ${l.topik}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.catatan,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}