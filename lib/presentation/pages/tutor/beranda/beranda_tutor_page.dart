// lib/presentation/pages/tutor/beranda_tutor_page.dart
// Beranda Tutor
// - 3 stat cards: Rating / Sesi Bulan Ini / Total Siswa
// - 2 pendapatan cards: Total Pendapatan + Saldo Escrow
// - 4 menu grid: Manajemen Sesi / Profil Mengajar / Ulasan Siswa / Tarik Saldo
// - Notifikasi section
// - Optional warning banner (Image 2)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_buttom_nav.dart';

const _teal = Color(0xFF3AAFA9);

class BerandaTutorPage extends StatefulWidget {
  const BerandaTutorPage({super.key});
  @override
  State<BerandaTutorPage> createState() => _BerandaTutorPageState();
}

class _BerandaTutorPageState extends State<BerandaTutorPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ── Data dummy — ganti dengan Cubit state ─────────────────────
  static const _nama            = 'Ibu Sarah';
  static const _rating          = 4.8;
  static const _sesiBulanIni    = 18;
  static const _totalSiswa      = 12;
  static const _totalPendapatan = 4800000;
  static const _saldoEscrow     = 1200000;
  static const _bergabungSejak  = 'Bergabung Sejak Maret 2026';
  static const _escrowInfo      = 'Dari 3 sesi dikonfirmasi';
  static const _hasWarning      = true;   // toggle untuk state warning
  static const _warningCount    = 1;

  static const _notifList = [
    _NotifData(
      icon: Icons.attach_money_rounded,
      judul: 'Penarikan Disetujui',
      subjudul: 'Penarikan Rp 500.000 telah diproses ke rekening Anda.',
      waktu: 'Hari ini,  14:00',
    ),
    _NotifData(
      icon: Icons.check_circle_outline_rounded,
      judul: 'Sesi Dikonfirmasi Otomatis',
      subjudul: 'sesi dengan Budi telah dikonfirmsi otomatis. Dana masuk ke saldo.',
      waktu: 'Kemarin,  12:00',
    ),
  ];

  // ── Format Rupiah ─────────────────────────────────────────────
  String _rp(int v) {
    final s = v.toString();
    final b = StringBuffer('Rp ');
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _teal,
      bottomNavigationBar: TutorBottomNav(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pushReplacementNamed(context, '/tutor/jadwal');
          if (i == 2) Navigator.pushReplacementNamed(context, '/tutor/konfirmasi-booking');
          if (i == 3) Navigator.pushReplacementNamed(context, '/tutor/profil');
        },
      ),
      body: SafeArea(
        child: Column(children: [
          _buildAppBar(),
          Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 16),

              // ── Warning banner (kondisional) ─────────────────
              // if (_hasWarning) ...[
              //   _buildWarningBanner(),
              //   const SizedBox(height: 12),
              // ],

              // ── 3 stat cards ─────────────────────────────────
              _buildStatCards(),
              const SizedBox(height: 12),

              // ── 2 pendapatan cards ────────────────────────────
              _buildPendapatanRow(),
              const SizedBox(height: 20),

              // ── 4 menu grid ───────────────────────────────────
              _buildMenuGrid(),
              const SizedBox(height: 24),

              // ── Notifikasi ────────────────────────────────────
              _buildNotifikasiSection(),
              const SizedBox(height: 32),
            ]),
          )),
        ]),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(children: [
        // Hamburger → drawer
        IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 26),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
        // Bell → notifikasi
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/tutor/notifikasi'),
          icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 26),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Selamat datang ', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            Text('👋', style: TextStyle(fontSize: 13)),
          ]),
          const Text(_nama, style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ]),
      ]),
    );
  }

  // ── Warning Banner ────────────────────────────────────────────
  // Widget _buildWarningBanner() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFFFF8E1),
  //       borderRadius: BorderRadius.circular(14),
  //       border: Border.all(color: const Color(0xFFFFE082)),
  //     ),
  //     child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       const Text('⚠️', style: TextStyle(fontSize: 18)),
  //       const SizedBox(width: 10),
  //       Expanded(
  //         child: RichText(
  //           text: TextSpan(
  //             style: const TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.5),
  //             children: [
  //               TextSpan(
  //                 text: 'Peringatan ($_warningCount/3)\n',
  //                 style: const TextStyle(fontWeight: FontWeight.w700),
  //               ),
  //               const TextSpan(text: 'Anda telah menerima 1 peringatan.\nJika mencapai 3 peringatan, akun akan '),
  //               const TextSpan(
  //                 text: 'disuspend selama 7 hari',
  //                 style: TextStyle(fontWeight: FontWeight.w700),
  //               ),
  //               const TextSpan(text: '.\n Mohon gunakan platform sesuai ketentuan.'),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  // ── 3 Stat Cards ─────────────────────────────────────────────
  Widget _buildStatCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        _statCard('⭐', '$_rating', 'Rating'),
        const SizedBox(width: 10),
        _statCard('📅', '$_sesiBulanIni', 'Sesi Bulan Ini'),
        const SizedBox(width: 10),
        _statCard('👤', '$_totalSiswa', 'Total Siswa'),
      ]),
    );
  }

  Widget _statCard(String icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(children: [
          Text(icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
        ]),
      ),
    );
  }

  // ── Pendapatan + Escrow ───────────────────────────────────────
  Widget _buildPendapatanRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Expanded(child: _pendapatanCard(
          icon: '📈',
          title: 'Total Pendapatan',
          amount: _totalPendapatan,
          sub: _bergabungSejak,
        )),
        const SizedBox(width: 12),
        Expanded(child: _pendapatanCard(
          icon: '💳',
          title: 'Saldo Escrow',
          amount: _saldoEscrow,
          sub: _escrowInfo,
        )),
      ]),
    );
  }

  Widget _pendapatanCard({
    required String icon,
    required String title,
    required int amount,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Expanded(child: Text(title,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
        ]),
        const SizedBox(height: 8),
        Text(_rp(amount),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(sub,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary, height: 1.3)),
      ]),
    );
  }

  // ── 4 Menu Grid ───────────────────────────────────────────────
  Widget _buildMenuGrid() {
    const menus = [
      ('👥', 'Manajemen\nSesi',    '/tutor/manajemen-sesi'),
      ('✏️', 'Profil\nMengajar',  '/tutor/profil-mengajar'),
      ('⭐', 'Ulasan\nSiswa',     '/tutor/ulasan-siswa'),
      ('💵', 'Tarik\nSaldo',      '/tutor/tarik-saldo'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: menus.map((m) {
          final w = (MediaQuery.of(context).size.width - 32 - 24) / 4;
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, m.$3),
            child: Container(
              width: w,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.06), blurRadius: 6)],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(m.$1, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text(m.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary, height: 1.3)),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Notifikasi ────────────────────────────────────────────────
  Widget _buildNotifikasiSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Notifikasi',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/tutor/notifikasi'),
              child: const Row(children: [
                Text('Lihat semua',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._notifList.map((n) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: _teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(n.icon, color: _teal, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.judul, style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(n.subjudul, style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              ])),
              const SizedBox(width: 8),
              Text(n.waktu, style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
            ]),
          ),
        )),
      ]),
    );
  }
}

// ── Model notif ───────────────────────────────────────────────────
class _NotifData {
  final IconData icon;
  final String judul, subjudul, waktu;
  const _NotifData({
    required this.icon,
    required this.judul,
    required this.subjudul,
    required this.waktu,
  });
}