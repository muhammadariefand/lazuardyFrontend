// lib/presentation/pages/siswa/rekomendasi_tutor_page.dart
// Rekomendasi Tutor "Lihat semua" — list diurutkan rating+ulasan,
// tap kartu → langsung ke pilih jadwal (skip kategori karena dari rekomendasi)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';


class RekomendasiTutorPage extends StatelessWidget {
  const RekomendasiTutorPage({super.key});

  static const _tutorList = [
    _TutorItem('Ibu Sarah',  'Matematika', 4.9, 127, 'S', true,  true),
    _TutorItem('Ibu Dewi',   'Matematika', 4.8, 98,  'D', true,  false),
    _TutorItem('Ibu Indah',  'Matematika', 4.7, 64,  'I', false, true),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Rekomendasi Tutor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subjudul
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                children: [
                  TextSpan(text: 'Menampilkan tutor untuk '),
                  TextSpan(
                    text: 'Terbaik, ',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  TextSpan(
                      text: 'diurutkan rating tertinggi dan ulasan terbanyak'),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _tutorList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final t = _tutorList[i];
                return _TutorCard(
                  tutor: t,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/siswa/booking/pilih-jadwal',
                    arguments: {
                      'tutor_nama': t.nama,
                      'tutor_mapel': t.mapel,
                      'tutor_rating': t.rating,
                      'tutor_ulasan': t.ulasan,
                      'tutor_inisial': t.inisial,
                      'mapel': t.mapel,
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Kartu tutor ───────────────────────────────────────────────────
class _TutorCard extends StatelessWidget {
  final _TutorItem tutor;
  final VoidCallback onTap;
  const _TutorCard({required this.tutor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          // Avatar inisial
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(tutor.inisial,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.secondary)),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tutor.nama,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(tutor.mapel,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.star_rounded, color: AppColors.warningYellow, size: 15),
                const SizedBox(width: 3),
                Text('${tutor.rating}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text('  (${tutor.ulasan} ulasan)',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ]),
            ]),
          ),

          // Badge Online / Offline
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tutor.hasOnline)  _badge('Online',  AppColors.successGreen),
              if (tutor.hasOnline && tutor.hasOffline) const SizedBox(height: 4),
              if (tutor.hasOffline) _badge('Offline', AppColors.errorRed),
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
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)));
}

// ── Model ─────────────────────────────────────────────────────────
class _TutorItem {
  final String nama, mapel, inisial;
  final double rating;
  final int ulasan;
  final bool hasOnline, hasOffline;
  const _TutorItem(this.nama, this.mapel, this.rating, this.ulasan,
      this.inisial, this.hasOnline, this.hasOffline);
}