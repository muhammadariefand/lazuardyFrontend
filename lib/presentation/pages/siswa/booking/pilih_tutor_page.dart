// lib/presentation/pages/siswa/booking/pilih_tutor_page.dart
// \List tutor diurutkan rating, badge Online/Offline

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _starYellow = Color(0xFFFFB800);
const _navy = Color(0xFF1E2D7D);

class PilihTutorPage extends StatelessWidget {
  const PilihTutorPage({super.key});

  // Data dummy — ganti dengan API call berdasarkan mapel yang dipilih
  static const _tutorAkademik = [
    _Tutor('Ibu Sarah', 'Matematika', 4.9, 127, 'S', true, true),
    _Tutor('Ibu Dewi', 'Matematika', 4.8, 98, 'D', true, false),
    _Tutor('Ibu Indah', 'Matematika', 4.7, 64, 'I', false, true),
  ];

  static const _tutorUmum = [
    _Tutor('Pak Naim', 'Mengaji', 4.9, 10, 'N', true, true),
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final mapel = args?['mapel'] as String? ?? 'Matematika';
    final kategori = args?['kategori'] as String? ?? 'akademik';
    final tutors = kategori == 'umum' ? _tutorUmum : _tutorAkademik;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Pilih Tutor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              children: [
                const TextSpan(text: 'Menampilkan tutor untuk '),
                TextSpan(
                    text: '$mapel, ',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const TextSpan(text: 'diurutkan rating tertinggi'),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: tutors.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _TutorCard(
              tutor: tutors[i],
              mapel: mapel,
              onTap: () => Navigator.pushNamed(
                context,
                '/siswa/booking/pilih-jadwal',
                arguments: {
                  ...?args,
                  'tutor_nama': tutors[i].nama,
                  'tutor_mapel': tutors[i].mapel,
                  'tutor_rating': tutors[i].rating,
                  'tutor_ulasan': tutors[i].ulasan,
                  'tutor_inisial': tutors[i].inisial,
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _TutorCard extends StatelessWidget {
  final _Tutor tutor;
  final String mapel;
  final VoidCallback onTap;
  const _TutorCard({required this.tutor, required this.mapel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _teal.withOpacity(0.4), width: 1.2),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(children: [
          // Avatar inisial
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Text(tutor.inisial,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: _navy)),
          ),
          const SizedBox(width: 14),

          // Nama + mapel + rating
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tutor.nama,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(mapel,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.star_rounded, color: _starYellow, size: 15),
                const SizedBox(width: 3),
                Text('${tutor.rating}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text('  (${tutor.ulasan} ulasan)',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ]),
            ]),
          ),

          // Badge Online / Offline
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tutor.hasOnline) _badge('Online', const Color(0xFF4CAF50)),
              if (tutor.hasOnline && tutor.hasOffline) const SizedBox(height: 4),
              if (tutor.hasOffline) _badge('Offline', const Color(0xFFE53E3E)),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _badge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3))),
    child: Text(label,
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, color: color)));
}

class _Tutor {
  final String nama, mapel, inisial;
  final double rating;
  final int ulasan;
  final bool hasOnline, hasOffline;
  const _Tutor(this.nama, this.mapel, this.rating, this.ulasan,
      this.inisial, this.hasOnline, this.hasOffline);
}