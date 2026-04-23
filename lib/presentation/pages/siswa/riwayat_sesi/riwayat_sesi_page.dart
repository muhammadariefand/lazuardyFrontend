// lib/presentation/pages/siswa/riwayat_sesi_page.dart
// List riwayat sesi — 3 status: Menunggu Konfirmasi, Selesai, Dibatalkan

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _navy = Color(0xFF1E2D7D);
const _starYellow = Color(0xFFFFB800);

// ── Status sesi ────────────────────────────────────────────────────
enum SesiStatus { menungguKonfirmasi, selesai, dibatalkan }

// ── Model ──────────────────────────────────────────────────────────
class _SesiItem {
  final String mapel, tutorNama, tutorInisial, tanggal, jam;
  final SesiStatus status;
  final double? rating;
  final bool sudahRating;

  const _SesiItem({
    required this.mapel,
    required this.tutorNama,
    required this.tutorInisial,
    required this.tanggal,
    required this.jam,
    required this.status,
    this.rating,
    this.sudahRating = false,
  });
}

class RiwayatSesiPage extends StatelessWidget {
  const RiwayatSesiPage({super.key});

  // Data dummy — ganti dengan data dari Cubit/API
  static const _sesiList = [
    _SesiItem(
      mapel: 'Matematika',
      tutorNama: 'Ibu Sarah',
      tutorInisial: 'S',
      tanggal: '5 Mar 2026',
      jam: '13:00 - 14:00',
      status: SesiStatus.menungguKonfirmasi,
    ),
    _SesiItem(
      mapel: 'Matematika',
      tutorNama: 'Ibu Sarah',
      tutorInisial: 'S',
      tanggal: '5 Mar 2026',
      jam: '13:00 - 14:00',
      status: SesiStatus.selesai,
      rating: 5,
      sudahRating: true,
    ),
    _SesiItem(
      mapel: 'Matematika',
      tutorNama: 'Ibu Sarah',
      tutorInisial: 'S',
      tanggal: '5 Mar 2026',
      jam: '13:00 - 14:00',
      status: SesiStatus.dibatalkan,
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
        title: const Text(
          'Riwayat Sesi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: _sesiList.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _sesiList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _SesiCard(
                sesi: _sesiList[i],
                onTap: () => Navigator.pushNamed(
                  context,
                  '/siswa/riwayat-sesi/detail',
                  arguments: {'sesi_index': i},
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('📋', style: TextStyle(fontSize: 48)),
        SizedBox(height: 12),
        Text('Belum ada riwayat sesi',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
      ],
    ),
  );
}

// ── Kartu sesi ────────────────────────────────────────────────────
class _SesiCard extends StatelessWidget {
  final _SesiItem sesi;
  final VoidCallback onTap;

  const _SesiCard({required this.sesi, required this.onTap});

  Color get _statusBorderColor {
    switch (sesi.status) {
      case SesiStatus.menungguKonfirmasi:
        return const Color(0xFF8B5CF6);
      case SesiStatus.selesai:
        return const Color(0xFF4CAF50);
      case SesiStatus.dibatalkan:
        return const Color(0xFFE53E3E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _statusBorderColor.withOpacity(0.5), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                sesi.tutorInisial,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama + status badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${sesi.mapel} — ${sesi.tutorNama}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(status: sesi.status),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Tanggal & jam
                  Text(
                    '${sesi.tanggal} · ${sesi.jam}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // WhatsApp badge + rating (jika selesai & sudah rating)
                  Row(
                    children: [
                      _whatsappBadge(),
                      if (sesi.status == SesiStatus.selesai &&
                          sesi.sudahRating &&
                          sesi.rating != null) ...[
                        const Spacer(),
                        const Icon(Icons.star_rounded,
                            color: _starYellow, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${sesi.rating!.toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _whatsappBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFF25D366),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.chat_rounded, size: 12, color: Colors.white),
        SizedBox(width: 4),
        Text('WhatsApp',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    ),
  );
}

// ── Status badge ──────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final SesiStatus status;
  const _StatusBadge({required this.status});

  String get _label {
    switch (status) {
      case SesiStatus.menungguKonfirmasi: return 'Menunggu Konfirmasi';
      case SesiStatus.selesai: return 'Selesai';
      case SesiStatus.dibatalkan: return 'Dibatalkan';
    }
  }

  Color get _color {
    switch (status) {
      case SesiStatus.menungguKonfirmasi: return const Color(0xFF8B5CF6);
      case SesiStatus.selesai: return const Color(0xFF4CAF50);
      case SesiStatus.dibatalkan: return const Color(0xFFE53E3E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}