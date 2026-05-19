// lib/presentation/pages/orangtua/detail_sesi_orangtua_page.dart
// Image 3: Detail Sesi (Mode Online → tampilkan alamat)
// Image 4: Detail Sesi (Mode Offline → tampilkan link meeting)
// - AppBar teal "Detail Sesi"
// - Card 1: avatar + nama tutor (teal) + mapel + WhatsApp + badge status
// - Card 2: Tanggal / Waktu / Mode
// - Card 3 kondisional: alamat (offline) atau link meeting (online)
// - Banner info pengingat otomatis

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'jadwal_orangtua_page.dart';

const _teal = Color(0xFF3AAFA9);

class DetailSesiOrangtuaPage extends StatelessWidget {
  final SesiJadwalData sesi;

  const DetailSesiOrangtuaPage({super.key, required this.sesi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Card 1: Info Tutor
                  _buildTutorCard(),
                  const SizedBox(height: 14),

                  // Card 2: Waktu
                  _buildWaktuCard(),
                  const SizedBox(height: 14),

                  // Card 3: Lokasi kondisional
                  if (!sesi.isOnline && sesi.alamat != null)
                    _buildAlamatCard(),
                  if (sesi.isOnline && sesi.linkMeeting != null)
                    _buildLinkMeetingCard(),
                  const SizedBox(height: 14),

                  // Banner pengingat
                  _buildPengingatBanner(),
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
            'Detail Sesi',
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

  // ── Card 1: Tutor ─────────────────────────────────────────────
  Widget _buildTutorCard() {
    return _cardWrapper(
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                sesi.inisial,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3949AB),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sesi.namaTutor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _teal,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      sesi.mapel,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    _buildWhatsAppButton(sesi.nomorWa),
                  ],
                ),
              ],
            ),
          ),
          _buildStatusBadge(sesi.status),
        ],
      ),
    );
  }

  // ── Card 2: Waktu ─────────────────────────────────────────────
  Widget _buildWaktuCard() {
    return _cardWrapper(
      child: Column(
        children: [
          _detailRow(
              Icons.schedule_outlined, 'Tanggal', sesi.tanggalLengkap),
          const SizedBox(height: 16),
          _detailRow(Icons.calendar_today_outlined, 'Waktu',
              '${sesi.jamMulai} - ${sesi.jamSelesai}'),
          const SizedBox(height: 16),
          _detailRow(Icons.videocam_outlined, 'Mode',
              sesi.isOnline ? 'Online' : 'Offline'),
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
                    fontSize: 13, color: AppColors.textSecondary),
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
            onTap: () {/* TODO: Google Maps */},
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
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {/* TODO: launch URL */},
            child: Text(
              sesi.linkMeeting!,
              style: const TextStyle(
                fontSize: 13,
                color: _teal,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Banner Pengingat ──────────────────────────────────────────
  Widget _buildPengingatBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 18, color: Color(0xFFF57C00)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pengingat otomatis akan dikirim 1 jam sebelum sesi dimulai.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5D4037),
                height: 1.5,
              ),
            ),
          ),
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

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF57C00),
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(String nomor) {
    return GestureDetector(
      onTap: () {/* TODO: launch WA */},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_rounded, color: Colors.white, size: 13),
            SizedBox(width: 4),
            Text('WhatsApp',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}