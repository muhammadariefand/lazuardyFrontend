// lib/presentation/pages/tutor/menunggu_verifikasi_page.dart
// Halaman ini muncul SETELAH tutor menyelesaikan semua langkah pendaftaran:
// Register → Detail Pribadi → Formulir Pendaftaran → Formulir Profil → OTP

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal   = Color(0xFF3AAFA9);
const _navy   = Color(0xFF1E2D7D);
const _orange = Color(0xFFF59E0B);
const _green  = Color(0xFF4CAF50);

class MenungguVerifikasiPage extends StatelessWidget {
  const MenungguVerifikasiPage({super.key});

  // ── Status pendaftaran — ganti dengan data dari Cubit ─────────
  static const _namaTutor = 'Ibu Sarah';

  static const _statusList = [
    _StatusItem(label: 'Data diri lengkap',                  isDone: true),
    _StatusItem(label: 'Dokumen sudah diunggah (CV, KTP, Ijazah)', isDone: true),
    _StatusItem(label: 'Data profil mengajar',               isDone: true),
    _StatusItem(label: 'Menunggu verifikasi admin',          isDone: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          // ── AppBar custom ──────────────────────────────────────
          _buildAppBar(context),

          // ── Body ───────────────────────────────────────────────
          Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const SizedBox(height: 24),
              _buildMainCard(),
              const SizedBox(height: 32),
            ]),
          )),
        ]),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: _teal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        // Hamburger (drawer — opsional)
        GestureDetector(
          onTap: () {}, // buka drawer jika diperlukan
          child: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
        ),
        const Spacer(),
        // Status Akun + nama
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text('Status Akun',
              style: TextStyle(fontSize: 13, color: Colors.white70)),
          const Text(_namaTutor,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ]),
      ]),
    );
  }

  // ── Kartu utama ───────────────────────────────────────────────
  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _teal.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06),
              blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: [
        // ── Icon gembok oranye ─────────────────────────────────
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: _orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock_rounded, color: _orange, size: 44),
        ),

        const SizedBox(height: 20),

        // ── Judul ─────────────────────────────────────────────
        const Text('Menunggu Verifikasi Admin',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: _teal)),

        const SizedBox(height: 12),

        // ── Deskripsi ─────────────────────────────────────────
        const Text(
          'Data pendaftaran Anda sedang ditinjau oleh admin. '
          'Anda belum dapat mengakses fitur tutor hingga akun diverifikasi',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary,
              height: 1.6),
        ),

        const SizedBox(height: 24),

        // ── Status Pendaftaran ─────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Status Pendaftaran:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            ..._statusList.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                // Icon: ✅ hijau jika done, ⏰ oranye jika pending
                item.isDone
                    ? const Icon(Icons.check_circle_rounded,
                        color: _green, size: 20)
                    : const Icon(Icons.access_time_rounded,
                        color: _orange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: item.isDone
                          ? AppColors.textPrimary
                          : _orange,
                      fontWeight: item.isDone
                          ? FontWeight.w400
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ]),
            )),
          ]),
        ),

        const SizedBox(height: 16),

        // ── Info banner (navy/abu) ─────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.warning_rounded,
                color: _navy.withOpacity(0.7), size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Akun Anda sedang dalam proses verifikasi. '
                'Semua fitur akan tersedia setelah verifikasi selesai.',
                style: TextStyle(fontSize: 13,
                    color: AppColors.textSecondary, height: 1.5),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Model status item ─────────────────────────────────────────────
class _StatusItem {
  final String label;
  final bool isDone;
  const _StatusItem({required this.label, required this.isDone});
}