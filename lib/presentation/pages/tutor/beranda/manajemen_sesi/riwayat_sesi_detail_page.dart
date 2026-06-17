// lib/presentation/pages/tutor/beranda/manajemen_sesi/riwayat_sesi_detail_page.dart

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:url_launcher/url_launcher.dart';


class RiwayatSesiDetailPage extends StatelessWidget {
  final ScheduleEntity sesi;

  const RiwayatSesiDetailPage({super.key, required this.sesi});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatLongDate(DateTime d) {
    const bulanNama = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${d.day} ${bulanNama[d.month]} ${d.year}';
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isOnline = sesi.learningMethod.toLowerCase() == 'online';
    final tanggal = _formatLongDate(sesi.date);
    final jamMulai = _formatTime(sesi.startTime);
    final jamSelesai = _formatTime(sesi.endTime);

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
                  _buildSiswaCard(isOnline),
                  const SizedBox(height: 14),

                  // Card 2: Detail Waktu
                  _buildWaktuCard(tanggal, jamMulai, jamSelesai, isOnline),
                  const SizedBox(height: 14),

                  // Card 3: Lokasi / Link (kondisional)
                  if (!isOnline && sesi.address.isNotEmpty)
                    _buildAlamatCard(),
                  if (isOnline && sesi.meetingLink != null && sesi.meetingLink!.isNotEmpty)
                    _buildLinkMeetingCard(),
                  const SizedBox(height: 14),
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
      color: AppColors.primary,
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
  Widget _buildSiswaCard(bool isOnline) {
    final inisial = sesi.studentName.isNotEmpty ? sesi.studentName[0].toUpperCase() : '?';

    return _cardWrapper(
      child: Row(
        children: [
          _buildAvatar(inisial),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sesi.studentName,
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
                      sesi.subjectName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (sesi.studentTelephoneNumber != null && sesi.studentTelephoneNumber!.isNotEmpty)
                      _buildWhatsAppButton(sesi.studentTelephoneNumber!),
                  ],
                ),
              ],
            ),
          ),
          _buildModeBadge(isOnline),
        ],
      ),
    );
  }

  // ── Card 2: Waktu ─────────────────────────────────────────────
  Widget _buildWaktuCard(String tanggal, String jamMulai, String jamSelesai, bool isOnline) {
    return _cardWrapper(
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.schedule_outlined,
            label: 'Tanggal',
            value: tanggal,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Waktu',
            value: '$jamMulai - $jamSelesai',
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.location_on_outlined,
            label: 'Mode',
            value: isOnline ? 'Online' : 'Offline',
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
            sesi.address,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              _openUrl('https://maps.google.com/?q=${Uri.encodeComponent(sesi.address)}');
            },
            child: const Row(
              children: [
                Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.primary),
                SizedBox(width: 4),
                Text(
                  'Buka di Google Maps',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
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
          GestureDetector(
            onTap: () {
              if (sesi.meetingLink != null) {
                _openUrl(sesi.meetingLink!);
              }
            },
            child: Text(
              sesi.meetingLink ?? '-',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
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
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
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

  Widget _buildAvatar(String inisial) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          inisial,
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
        _openUrl('https://wa.me/$nomor');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.successGreen,
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