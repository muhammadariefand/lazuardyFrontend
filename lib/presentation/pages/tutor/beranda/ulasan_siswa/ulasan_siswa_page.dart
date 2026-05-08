// lib/presentation/pages/tutor/ulasan_siswa_page.dart
// Image 1: Ulasan Siswa
// - AppBar teal "Ulasan Siswa"
// - Subtitle "Lihat Feedback dari siswa Anda"
// - Card rating besar: angka 4.8, bintang, "Dari N ulasan siswa"
// - List card ulasan: avatar + nama + tanggal + bintang + komentar

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _starColor = Color(0xFFFFA726);

// ── Model ─────────────────────────────────────────────────────────
class _UlasanData {
  final String nama;
  final String tanggal;
  final double rating;
  final String komentar;

  const _UlasanData({
    required this.nama,
    required this.tanggal,
    required this.rating,
    required this.komentar,
  });
}

// ── Page ──────────────────────────────────────────────────────────
class UlasanSiswaPage extends StatelessWidget {
  const UlasanSiswaPage({super.key});

  // ── Dummy data ─────────────────────────────────────────────────
  static const _ulasanList = [
    _UlasanData(
      nama: 'Ahmad',
      tanggal: '1 April 2026',
      rating: 5,
      komentar:
          'Bu Sarah mengajarnya dengan sangat sabar dan jeas. Saya jadi lebih paham matematika',
    ),
    _UlasanData(
      nama: 'Ahmad',
      tanggal: '1 April 2026',
      rating: 5,
      komentar:
          'Bu Sarah mengajarnya dengan sangat sabar dan jeas. Saya jadi lebih paham matematika',
    ),
    _UlasanData(
      nama: 'Ahmad',
      tanggal: '1 April 2026',
      rating: 4,
      komentar:
          'Bu Sarah mengajarnya dengan sangat sabar dan jeas. Saya jadi lebih paham matematika',
    ),
    _UlasanData(
      nama: 'Ahmad',
      tanggal: '1 April 2026',
      rating: 5,
      komentar:
          'Bu Sarah mengajarnya dengan sangat sabar dan jeas. Saya jadi lebih paham matematika',
    ),
    _UlasanData(
      nama: 'Dewi',
      tanggal: '28 Maret 2026',
      rating: 5,
      komentar:
          'Penjelasannya sangat mudah dipahami. Saya jadi lebih percaya diri dalam pelajaran.',
    ),
  ];

  double get _rataRating =>
      _ulasanList.map((u) => u.rating).reduce((a, b) => a + b) /
      _ulasanList.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text(
                    'Lihat Feedback dari siswa Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Kartu Rating Besar ──────────────────────
                  _buildRatingCard(),
                  const SizedBox(height: 16),

                  // ── List Ulasan ─────────────────────────────
                  ..._ulasanList.map(
                    (u) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildUlasanCard(u),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
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
        left: 4,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 24),
          ),
          const Text(
            'Ulasan Siswa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu Rating Besar ────────────────────────────────────────
  Widget _buildRatingCard() {
    final avg = _rataRating;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Angka besar
          Text(
            avg.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),

          // Bintang
          _buildStars(avg, size: 32),
          const SizedBox(height: 10),

          // Jumlah ulasan
          Text(
            'Dari ${_ulasanList.length} ulasan siswa',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu Ulasan ──────────────────────────────────────────────
  Widget _buildUlasanCard(_UlasanData u) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _teal.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar + nama/tanggal + bintang
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(u.nama),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.nama,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      u.tanggal,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStars(u.rating, size: 18),
            ],
          ),
          const SizedBox(height: 10),

          // Komentar
          Text(
            u.komentar,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  Widget _buildAvatar(String nama) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          nama[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3949AB),
          ),
        ),
      ),
    );
  }

  Widget _buildStars(double rating, {double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && i < rating;
        return Icon(
          half
              ? Icons.star_half_rounded
              : filled
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
          color: (filled || half) ? _starColor : const Color(0xFFCCCCCC),
          size: size,
        );
      }),
    );
  }
}