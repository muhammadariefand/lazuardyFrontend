// lib/presentation/pages/tutor/riwayat_sesi_detail_page.dart
// Riwayat Sesi (Detail)
// - AppBar teal "Riwayat Sesi"
// - Card 1: nama siswa + mapel + WhatsApp badge + mode badge
// - Card 2: Tanggal / Waktu / Mode (dengan icon)
// - Card 3 (kondisional): Alamat Lokasi (offline) ATAU Link Meeting (online)
// - Card 4: Laporan Pembelajaran (Topik + Catatan)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/manajemen_sesi/manajemen_sesi_page.dart';

const _teal = Color(0xFF3AAFA9);

class RiwayatSesiDetailPage extends StatelessWidget {
  final RiwayatSesiData sesi;

  const RiwayatSesiDetailPage({super.key, required this.sesi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Card 1: Info Siswa
                  _buildSiswaCard(),
                  const SizedBox(height: 14),

                  // Card 2: Detail Waktu
                  _buildWaktuCard(),
                  const SizedBox(height: 14),

                  // Card 3: Lokasi / Link (kondisional)
                  if (!sesi.isOnline && sesi.alamat != null)
                    _buildAlamatCard(),
                  if (sesi.isOnline && sesi.linkMeeting != null)
                    _buildLinkMeetingCard(),
                  const SizedBox(height: 14),

                  // Card 4: Laporan Pembelajaran
                  if (sesi.topikLaporan != null || sesi.catatanLaporan != null)
                    _buildLaporanCard(),
                  const SizedBox(height: 24),
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
            'Riwayat Sesi',
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

  // ── Card 1: Info Siswa ────────────────────────────────────────
  Widget _buildSiswaCard() {
    return _cardWrapper(
      child: Row(
        children: [
          _buildAvatar(sesi.nama),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sesi.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      sesi.mapel,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildWhatsAppButton(sesi.nomorWa),
                  ],
                ),
              ],
            ),
          ),
          _buildModeBadge(sesi.isOnline),
        ],
      ),
    );
  }

  // ── Card 2: Waktu ─────────────────────────────────────────────
  Widget _buildWaktuCard() {
    return _cardWrapper(
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.schedule_outlined,
            label: 'Tanggal',
            value: sesi.tanggal,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Waktu',
            value: '${sesi.jamMulai} - ${sesi.jamSelesai}',
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.location_on_outlined,
            label: 'Mode',
            value: sesi.isOnline ? 'Online' : 'Offline',
          ),
        ],
      ),
    );
  }

  // ── Card 3a: Alamat Offline ───────────────────────────────────
  Widget _buildAlamatCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 18, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text(
                'Alamat Lokasi sesi',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sesi.alamat!,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // TODO: launch Google Maps
            },
            child: const Row(
              children: [
                Icon(Icons.open_in_new_rounded, size: 14, color: _teal),
                SizedBox(width: 4),
                Text(
                  'Buka di Google Maps',
                  style: TextStyle(
                    fontSize: 13,
                    color: _teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Card 3b: Link Meeting Online ──────────────────────────────
  Widget _buildLinkMeetingCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.videocam_outlined,
                  size: 18, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text(
                'Link Meeting',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            sesi.linkMeeting!,
            style: const TextStyle(
              fontSize: 13,
              color: _teal,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card 4: Laporan Pembelajaran ─────────────────────────────
  Widget _buildLaporanCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Pembelajaran',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (sesi.topikLaporan != null) ...[
            const SizedBox(height: 4),
            Text(
              'Topik: ${sesi.topikLaporan}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
          if (sesi.catatanLaporan != null) ...[
            const SizedBox(height: 10),
            Text(
              sesi.catatanLaporan!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _teal.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar(String nama) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          nama[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3949AB),
          ),
        ),
      ),
    );
  }

  Widget _buildModeBadge(bool isOnline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOnline ? 'Online' : 'Offline',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isOnline
              ? const Color(0xFF2E7D32)
              : const Color(0xFFC62828),
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(String nomor) {
    return GestureDetector(
      onTap: () {
        // TODO: launch WhatsApp
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_rounded, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text(
              'WhatsApp',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}