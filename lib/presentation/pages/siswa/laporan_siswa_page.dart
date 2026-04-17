// lib/presentation/pages/siswa/laporan_siswa_page.dart

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/siswa_bottom_nav.dart';

const _teal = Color(0xFF3AAFA9);

class LaporanSiswaPage extends StatelessWidget {
  const LaporanSiswaPage({super.key});

  static const _laporanList = [
    _Laporan('Matematika', 'Ibu Sarah', '5 Maret 2026', 'Aljabar, Persamaan Linear',
        'Siswa memahami konsep aljabar dengan cepat. Perlu latihan soal cerita lebih banyak.'),
    _Laporan('Fisika', 'Pak Ahmad', '3 Maret 2026', 'Hukum Newton, Gaya',
        'Siswa masih belum memahami hukum Newton dengan baik.'),
    _Laporan('Kimia', 'Pak Budi', '28 Februari 2026', 'Tabel Periodik, Reaksi Kimia',
        'Menguasai tabel periodik dan reaksi kimia dasar dengan sangat baik.'),
    _Laporan('B. Inggris', 'Pak Rinai', '15 Februari 2026', 'Grammar, Vocabulary',
        'Siswa menunjukkan kemajuan dalam kosakata dan tata bahasa.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SiswaBottomNav(currentIndex: 2, onTap: (i) {
        if (i == 0) Navigator.pushReplacementNamed(context, '/siswa/beranda');
        if (i == 1) Navigator.pushReplacementNamed(context, '/siswa/jadwal');
        if (i == 3) Navigator.pushReplacementNamed(context, '/siswa/profil');
      }),
      body: Column(children: [
        // Teal header
        Container(color: _teal, padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(alignment: Alignment.centerLeft,
            child: Text('Laporan Pembelajaran', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)))),

        Expanded(child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _laporanList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, i) => _LaporanCard(laporan: _laporanList[i]),
        )),
      ]),
    );
  }
}

class _LaporanCard extends StatelessWidget {
  final _Laporan laporan;
  const _LaporanCard({required this.laporan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(laporan.mapel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _teal)),
        const SizedBox(height: 3),
        Text('${laporan.tutor} • ${laporan.tanggal}',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Topik: ${laporan.topik}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(laporan.catatan, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5)),
          ])),
      ]),
    );
  }
}

class _Laporan {
  final String mapel, tutor, tanggal, topik, catatan;
  const _Laporan(this.mapel, this.tutor, this.tanggal, this.topik, this.catatan);
}