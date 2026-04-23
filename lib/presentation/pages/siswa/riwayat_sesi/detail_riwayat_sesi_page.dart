// lib/presentation/pages/siswa/detail_riwayat_sesi_page.dart
// Detail Riwayat Sesi — berdasarkan status sesi, tampilkan info & action berbeda
// - Menunggu Konfirmasi: + banner Konfirmasi Penyelesaian + tombol
// - Selesai (belum rating): + tombol Beri Rating Tutor
// - Selesai (sudah rating): tanpa tombol rating
// - Dibatalkan: banner merah + info strikethrough

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _navy = Color(0xFF1E2D7D);
const _green = Color(0xFF4CAF50);
const _orange = Color(0xFFF59E0B);
const _red = Color(0xFFE53E3E);
const _purple = Color(0xFF8B5CF6);

// Status enum (sama dengan riwayat_sesi_page, idealnya di shared model)
enum _SesiStatus { menungguKonfirmasi, selesai, dibatalkan }

class DetailRiwayatSesiPage extends StatefulWidget {
  const DetailRiwayatSesiPage({super.key});
  @override
  State<DetailRiwayatSesiPage> createState() =>
      _DetailRiwayatSesiPageState();
}

class _DetailRiwayatSesiPageState extends State<DetailRiwayatSesiPage> {
  bool _isKonfirmasiLoading = false;

  // Data dummy — nanti diambil dari args atau Cubit
  static const _tutorNama = 'Ibu Sarah';
  static const _tutorInisial = 'S';
  static const _mapel = 'Matematika';
  static const _tanggal = '5 Maret 2026';
  static const _waktu = '13:00 - 14:00';
  static const _mode = 'Online';
  static const _topik = 'Aljabar, Persamaan Linear';
  static const _catatan =
      'Siswa memahami konsep aljabar dengan cepat. Perlu latihan soal cerita lebih banyak.';
  static const _sudahRating = false; // ubah ke true untuk state sudah rating

  // Status diambil dari arguments
  _SesiStatus _getStatus(Map? args) {
    final s = args?['status'] as String? ?? 'menunggu';
    if (s == 'selesai') return _SesiStatus.selesai;
    if (s == 'dibatalkan') return _SesiStatus.dibatalkan;
    return _SesiStatus.menungguKonfirmasi;
  }

  void _onKonfirmasiSelesai() async {
    setState(() => _isKonfirmasiLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    // TODO: panggil use case konfirmasi selesai
    if (mounted) {
      setState(() => _isKonfirmasiLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sesi berhasil dikonfirmasi selesai'),
          backgroundColor: _green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final status = _getStatus(args);
    final isDibatalkan = status == _SesiStatus.dibatalkan;
    final isSelesai = status == _SesiStatus.selesai;
    final isMenunggu = status == _SesiStatus.menungguKonfirmasi;

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
        title: const Text(
          'Detail Sesi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),

      // ── Sticky bottom button ───────────────────────────────────
      bottomNavigationBar: _buildBottomBar(status, context),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 4),

          // ── Kartu tutor + status ────────────────────────────
          _buildTutorCard(status),
          const SizedBox(height: 16),

          // ── Banner dibatalkan (hanya status Dibatalkan) ──────
          if (isDibatalkan) ...[
            _buildDibatalkanBanner(),
            const SizedBox(height: 16),
          ],

          // ── Info tanggal/waktu/mode ──────────────────────────
          _buildInfoCard(isDibatalkan),
          const SizedBox(height: 16),

          // ── Laporan tutor (hanya Menunggu & Selesai) ─────────
          if (!isDibatalkan) ...[
            _buildLaporanTutor(),
            const SizedBox(height: 16),
          ],

          // ── Banner Konfirmasi Penyelesaian (hanya Menunggu) ──
          if (isMenunggu) _buildKonfirmasiBanner(),

          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  // ── Bottom bar kondisional ─────────────────────────────────────
  Widget? _buildBottomBar(_SesiStatus status, BuildContext context) {
    if (status == _SesiStatus.selesai && !_sudahRating) {
      // Belum rating → tombol Beri Rating Tutor
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(
              context,
              '/siswa/riwayat-sesi/rating',
              arguments: {
                'tutor_nama': _tutorNama,
                'tutor_inisial': _tutorInisial,
                'mapel': _mapel,
              },
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.star_rounded, size: 20),
            label: const Text('Beri Rating Tutor',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      );
    }
    return null; // tidak ada bottom bar untuk status lain
  }

  // ── Kartu tutor ────────────────────────────────────────────────
  Widget _buildTutorCard(_SesiStatus status) {
    Color badgeColor;
    String badgeLabel;
    switch (status) {
      case _SesiStatus.menungguKonfirmasi:
        badgeColor = _purple;
        badgeLabel = 'Menunggu Konfirmasi';
        break;
      case _SesiStatus.selesai:
        badgeColor = _green;
        badgeLabel = 'Selesai';
        break;
      case _SesiStatus.dibatalkan:
        badgeColor = _red;
        badgeLabel = 'Dibatalkan';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(_tutorInisial,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _navy)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(_tutorNama,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const Text(_mapel,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          _whatsappBadge(),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor.withOpacity(0.3)),
          ),
          child: Text(badgeLabel,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: badgeColor)),
        ),
      ]),
    );
  }

  // ── Banner dibatalkan ──────────────────────────────────────────
  Widget _buildDibatalkanBanner() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _red.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 28, height: 28, decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: _red, width: 1.5)),
        child: const Icon(Icons.close_rounded, color: _red, size: 16)),
      const SizedBox(width: 12),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Sesi Dibatalkan',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _red)),
        SizedBox(height: 4),
        Text('Sesi ini telah dibatalkan. Kuota sesi telah dikembalikan ke akun Anda.',
            style: TextStyle(fontSize: 13, color: _red, height: 1.4)),
      ])),
    ]),
  );

  // ── Info card (tanggal/waktu/mode) ─────────────────────────────
  Widget _buildInfoCard(bool isDibatalkan) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _teal.withOpacity(0.4)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
    ),
    child: Column(children: [
      _infoRow(Icons.access_time_outlined, 'Tanggal', _tanggal, strikethrough: isDibatalkan),
      const Divider(height: 20),
      _infoRow(Icons.calendar_today_outlined, 'Waktu', _waktu, strikethrough: isDibatalkan),
      const Divider(height: 20),
      _infoRow(Icons.videocam_outlined, 'Mode', _mode, strikethrough: isDibatalkan),
    ]),
  );

  Widget _infoRow(IconData icon, String label, String value, {bool strikethrough = false}) =>
    Row(children: [
      Icon(icon, size: 22, color: AppColors.textSecondary),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Text(value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: strikethrough ? AppColors.textSecondary : AppColors.textPrimary,
              decoration: strikethrough ? TextDecoration.lineThrough : TextDecoration.none,
            )),
      ]),
    ]);

  // ── Laporan Tutor ──────────────────────────────────────────────
  Widget _buildLaporanTutor() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _teal.withOpacity(0.4)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Laporan Tutor',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Pembelajaran',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text('Topik: $_topik',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(_catatan,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5)),
        ]),
      ),
    ]),
  );

  // ── Banner Konfirmasi Penyelesaian ─────────────────────────────
  Widget _buildKonfirmasiBanner() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF8E1),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFFFE082)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [
        Icon(Icons.info_outline_rounded, color: _orange, size: 20),
        SizedBox(width: 8),
        Text('Konfirmasi Penyelesaian',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF92400E))),
      ]),
      const SizedBox(height: 6),
      const Text(
        'Tutor telah menandai sesi ini selesai. Konfirmasi jika sudah benar. Auto-konfirmasi dalam 24 jam',
        style: TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.5),
      ),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity, height: 48,
        child: ElevatedButton.icon(
          onPressed: _isKonfirmasiLoading ? null : _onKonfirmasiSelesai,
          style: ElevatedButton.styleFrom(
            backgroundColor: _teal,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: _isKonfirmasiLoading
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : const Icon(Icons.check_rounded, size: 18),
          label: const Text('Konfirmasi Selesai',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ),
    ]),
  );

  Widget _whatsappBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFF25D366),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.chat_rounded, size: 12, color: Colors.white),
      SizedBox(width: 4),
      Text('WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
    ]),
  );
}