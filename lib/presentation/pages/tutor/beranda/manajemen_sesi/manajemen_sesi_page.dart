// lib/presentation/pages/tutor/manajemen_sesi_page.dart
// (Tab Mendatang) & (Tab Riwayat)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/manajemen_sesi/riwayat_sesi_detail_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/manajemen_sesi/laporan_sesi_page.dart';

const _teal = Color(0xFF3AAFA9);

// ── Models ────────────────────────────────────────────────────────
class SesiData {
  final String nama;
  final String mapel;
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;
  final bool isOnline;
  final String? linkMeeting;
  final String? alamat;
  final String nomorWa;

  const SesiData({
    required this.nama,
    required this.mapel,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.isOnline,
    this.linkMeeting,
    this.alamat,
    required this.nomorWa,
  });
}

class RiwayatSesiData {
  final String nama;
  final String mapel;
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;
  final bool isOnline;
  final String? alamat;
  final String? linkMeeting;
  final String nomorWa;
  final bool laporanDiisi;
  final bool dikonfirmasiSiswa;
  final bool danaMasuk;
  final String? topikLaporan;
  final String? catatanLaporan;

  const RiwayatSesiData({
    required this.nama,
    required this.mapel,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.isOnline,
    this.alamat,
    this.linkMeeting,
    required this.nomorWa,
    this.laporanDiisi = false,
    this.dikonfirmasiSiswa = false,
    this.danaMasuk = false,
    this.topikLaporan,
    this.catatanLaporan,
  });
}

// ── Page ──────────────────────────────────────────────────────────
class ManajemenSesiPage extends StatefulWidget {
  const ManajemenSesiPage({super.key});

  @override
  State<ManajemenSesiPage> createState() => _ManajemenSesiPageState();
}

class _ManajemenSesiPageState extends State<ManajemenSesiPage> {
  int _selectedTab = 0;

  // ── Dummy Data ────────────────────────────────────────────────
  static const _mendatangList = [
    SesiData(
      nama: 'Ahmad',
      mapel: 'Matematika',
      tanggal: '1 April 2026',
      jamMulai: '10:00',
      jamSelesai: '11:00',
      isOnline: true,
      linkMeeting: 'https://meet.google.com/abc-defg-hij',
      nomorWa: '6281234567890',
    ),
    SesiData(
      nama: 'Rizky',
      mapel: 'Matematika',
      tanggal: '31 Maret 2026',
      jamMulai: '14:00',
      jamSelesai: '15:00',
      isOnline: false,
      alamat:
          'Jl. Melati Indah No. 24, RT 03/RW 05, Kel. Sumberrejo, Kec. Ngaglik, Kab. Sleman, DIY',
      nomorWa: '6289876543210',
    ),
  ];

  static const _riwayatList = [
    RiwayatSesiData(
      nama: 'Ahmad',
      mapel: 'Matematika',
      tanggal: '1 April 2026',
      jamMulai: '14:00',
      jamSelesai: '15:00',
      isOnline: false,
      alamat:
          'Jl. Melati Indah No. 24, RT 03/RW 05, Kel. Sumberrejo, Kec. Ngaglik, Kab. Sleman, DIY',
      nomorWa: '6281234567890',
      laporanDiisi: true,
      dikonfirmasiSiswa: true,
      danaMasuk: true,
      topikLaporan: 'Aljabar, Persamaan Linear',
      catatanLaporan:
          'Siswa memahami konsep aljabar dengan cepat.\nPerlu latihan soal cerita lebih banyak.',
    ),
    RiwayatSesiData(
      nama: 'Dewi',
      mapel: 'Matematika',
      tanggal: '31 Maret 2026',
      jamMulai: '17:00',
      jamSelesai: '18:00',
      isOnline: true,
      linkMeeting: 'https://meet.google.com/xyz-uvwx-yz',
      nomorWa: '6285678901234',
      laporanDiisi: true,
      dikonfirmasiSiswa: true,
      danaMasuk: true,
      topikLaporan: 'Geometri, Luas Bangun Datar',
      catatanLaporan: 'Siswa perlu lebih banyak latihan soal geometri.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(),
          const SizedBox(height: 20),
          _buildTabToggle(),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedTab == 0
                ? _buildMendatangList()
                : _buildRiwayatList(),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar() {
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
            'Manajemen Sesi',
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

  // ── Tab Toggle ────────────────────────────────────────────────
  Widget _buildTabToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _tabButton('Mendatang', 0),
            _tabButton('Riwayat', 1),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ── Tab Mendatang ─────────────────────────────────────────────
  Widget _buildMendatangList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _mendatangList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => _buildMendatangCard(_mendatangList[i]),
    );
  }

  Widget _buildMendatangCard(SesiData sesi) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _teal.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSesiHeader(
              nama: sesi.nama,
              mapel: sesi.mapel,
              tanggal: sesi.tanggal,
              isOnline: sesi.isOnline,
            ),
            const SizedBox(height: 12),
            _buildJamRow(
              jamMulai: sesi.jamMulai,
              jamSelesai: sesi.jamSelesai,
              nomorWa: sesi.nomorWa,
            ),
            const SizedBox(height: 10),
            if (sesi.isOnline && sesi.linkMeeting != null)
              _buildInfoBox(
                icon: Icons.videocam_outlined,
                title: 'Link Meeting',
                content: sesi.linkMeeting!,
                isLink: true,
              )
            else if (!sesi.isOnline && sesi.alamat != null)
              _buildAlamatBox(sesi.alamat!),
            const SizedBox(height: 14),
            _buildTandaiButton(sesi),
          ],
        ),
      ),
    );
  }

  Widget _buildTandaiButton(SesiData sesi) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LaporanSesiPage(sesi: sesi),
            ),
          );
        },
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          size: 20,
          color: Colors.white,
        ),
        label: const Text(
          'Tandai Sesi Selesai',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _teal,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // ── Tab Riwayat ───────────────────────────────────────────────
  Widget _buildRiwayatList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _riwayatList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => _buildRiwayatCard(_riwayatList[i]),
    );
  }

  Widget _buildRiwayatCard(RiwayatSesiData sesi) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RiwayatSesiDetailPage(sesi: sesi),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _teal.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSesiHeader(
                nama: sesi.nama,
                mapel: sesi.mapel,
                tanggal: sesi.tanggal,
                isOnline: sesi.isOnline,
              ),
              const SizedBox(height: 12),
              _buildJamRow(
                jamMulai: sesi.jamMulai,
                jamSelesai: sesi.jamSelesai,
                nomorWa: sesi.nomorWa,
              ),
              const SizedBox(height: 8),
              if (sesi.laporanDiisi)
                _buildStatusRow(
                    Icons.description_outlined, 'Laporan sudah diisi'),
              if (sesi.dikonfirmasiSiswa)
                _buildStatusRow(
                    Icons.check_circle_outline_rounded, 'Dikonfirmasi siswa'),
              if (sesi.danaMasuk)
                _buildStatusRow(
                    Icons.attach_money_rounded, 'Dana sudah masuk saldo'),
            ],
          ),
        ),
      ),
    );
  }

  // ── Shared Widgets ────────────────────────────────────────────
  Widget _buildSesiHeader({
    required String nama,
    required String mapel,
    required String tanggal,
    required bool isOnline,
  }) {
    return Row(
      children: [
        _buildAvatar(nama),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$mapel · $tanggal',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildModeBadge(isOnline),
      ],
    );
  }

  Widget _buildJamRow({
    required String jamMulai,
    required String jamSelesai,
    required String nomorWa,
  }) {
    return Row(
      children: [
        const Icon(Icons.schedule_rounded,
            size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          '$jamMulai - $jamSelesai',
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        ),
        const SizedBox(width: 12),
        _buildWhatsAppButton(nomorWa),
      ],
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String content,
    bool isLink = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: isLink ? _teal : AppColors.textPrimary,
                    decoration:
                        isLink ? TextDecoration.underline : TextDecoration.none,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlamatBox(String alamat) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 18, color: AppColors.textSecondary),
              SizedBox(width: 6),
              Text(
                'Alamat Lokasi sesi',
                style:
                    TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            alamat,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
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

  Widget _buildStatusRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF2E7D32)),
          ),
        ],
      ),
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