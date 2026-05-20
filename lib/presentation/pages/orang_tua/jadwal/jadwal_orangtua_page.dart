// lib/presentation/pages/orangtua/jadwal_orangtua_page.dart
// Image 2: Jadwal Saya
// - AppBar teal "Jadwal Saya"
// - Navigasi bulan (< April >)
// - Row 7 hari (Sen 30 … Min 5), satu aktif teal
// - Label "Sesi Hari Ini"
// - List card sesi: avatar + nama tutor (teal) + mapel + badge mode
//   + WhatsApp + jam + tanggal + icon edit (pensil)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_bottom_nav.dart';
import 'detail_sesi_orangtua_page.dart';

const _teal = Color(0xFF3AAFA9);

// ── Model ─────────────────────────────────────────────────────────
class SesiJadwalData {
  final String inisial;
  final String namaTutor;
  final String mapel;
  final bool isOnline;
  final String nomorWa;
  final String jamMulai;
  final String jamSelesai;
  final String tanggal;
  final String tanggalLengkap;
  final String? linkMeeting;
  final String? alamat;
  final String status;

  const SesiJadwalData({
    required this.inisial,
    required this.namaTutor,
    required this.mapel,
    required this.isOnline,
    required this.nomorWa,
    required this.jamMulai,
    required this.jamSelesai,
    required this.tanggal,
    required this.tanggalLengkap,
    this.linkMeeting,
    this.alamat,
    required this.status,
  });
}

// ── Page ──────────────────────────────────────────────────────────
class JadwalOrangtuaPage extends StatefulWidget {
  const JadwalOrangtuaPage({super.key});

  @override
  State<JadwalOrangtuaPage> createState() => _JadwalOrangtuaPageState();
}

class _JadwalOrangtuaPageState extends State<JadwalOrangtuaPage> {
  int _selectedDayIdx = 2; // Rabu default
  String _bulan = 'April';
  int _tahun = 2026;

  // Hari dalam minggu yang ditampilkan
  final List<Map<String, dynamic>> _hariList = [
    {'label': 'Sen', 'tanggal': 30},
    {'label': 'Sel', 'tanggal': 31},
    {'label': 'Rab', 'tanggal': 1},
    {'label': 'Kam', 'tanggal': 2},
    {'label': 'Jum', 'tanggal': 3},
    {'label': 'Sab', 'tanggal': 4},
    {'label': 'Min', 'tanggal': 5},
  ];

  static const _sesiList = [
    SesiJadwalData(
      inisial: 'S',
      namaTutor: 'Ibu Sarah',
      mapel: 'Matematika',
      isOnline: true,
      nomorWa: '6281234567890',
      jamMulai: '14:00',
      jamSelesai: '15:00',
      tanggal: 'Senin, 1 April 2026',
      tanggalLengkap: '1 April 2026',
      linkMeeting: 'https://meet.google.com/abc-defg-hij',
      status: 'Terjadwal',
    ),
    SesiJadwalData(
      inisial: 'S',
      namaTutor: 'Ibu Rina',
      mapel: 'B.Inggris',
      isOnline: false,
      nomorWa: '6285678901234',
      jamMulai: '14:00',
      jamSelesai: '15:00',
      tanggal: 'Senin, 1 April 2026',
      tanggalLengkap: '1 April 2026',
      alamat:
          'Jl. Melati Indah No. 24, RT 03/RW 05, Kel. Sumberrejo, Kec. Ngaglik, Kab. Sleman, DIY',
      status: 'Terjadwal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: OrangTuaBottomNav(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/orang-tua/beranda');
          if (i == 2) Navigator.pushReplacementNamed(context, '/orang-tua/laporan-anak');
          if (i == 3) Navigator.pushReplacementNamed(context, '/orang-tua/profil-anak');
        },
      ),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildBulanNavigator(),
                  const SizedBox(height: 16),
                  _buildDaySelector(),
                  const SizedBox(height: 20),
                  const Text(
                    'Sesi Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._sesiList.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildSesiCard(s),
                      )),
                ],
              ),
            ),
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
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Jadwal Saya',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── Navigasi Bulan ────────────────────────────────────────────
  Widget _buildBulanNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _navBtn(Icons.chevron_left_rounded, () {
          setState(() {/* TODO: prev month */});
        }),
        Text(
          _bulan,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        _navBtn(Icons.chevron_right_rounded, () {
          setState(() {/* TODO: next month */});
        }),
      ],
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }

  // ── Day Selector ──────────────────────────────────────────────
  Widget _buildDaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_hariList.length, (i) {
        final hari = _hariList[i];
        final isSelected = _selectedDayIdx == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedDayIdx = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: (MediaQuery.of(context).size.width - 32 - 42) / 7,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _teal : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _teal : const Color(0xFFCCCCCC),
              ),
            ),
            child: Column(
              children: [
                Text(
                  hari['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${hari['tanggal']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Card Sesi ─────────────────────────────────────────────────
  Widget _buildSesiCard(SesiJadwalData s) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailSesiOrangtuaPage(sesi: s),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                _buildAvatar(s.inisial),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.namaTutor,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _teal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(s.mapel,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildModeBadge(s.isOnline),
                          const SizedBox(width: 8),
                          _buildWhatsAppButton(s.nomorWa),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(s.status),
              ],
            ),
            const SizedBox(height: 12),
            // Jam + Tanggal + Edit
            Row(
              children: [
                const Icon(Icons.schedule_rounded,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${s.jamMulai} - ${s.jamSelesai}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(width: 12),
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(s.tanggal,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textPrimary)),
                const Spacer(),
                const Icon(Icons.edit_outlined,
                    size: 18, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared Widgets ────────────────────────────────────────────
  Widget _buildAvatar(String inisial) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          inisial,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3949AB),
          ),
        ),
      ),
    );
  }

  Widget _buildModeBadge(bool isOnline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOnline
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOnline ? 'Online' : 'Offline',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isOnline
              ? const Color(0xFF2E7D32)
              : const Color(0xFFC62828),
        ),
      ),
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