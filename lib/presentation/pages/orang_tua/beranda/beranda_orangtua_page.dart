// lib/presentation/pages/orangtua/beranda_orangtua_page.dart
// Image 1: Beranda Orang Tua
// - AppBar putih: hamburger + bell + greeting kanan
// - Card Bimbel Lazuardy (logo + nama + tagline + deskripsi)
// - Card Paket Tersisa (angka besar + "sesi")
// - Section Notifikasi (lihat semua) + 2 notif card
// - Section Riwayat Sesi + list card dengan badge status

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_bottom_nav.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_drawer.dart';

const _teal = Color(0xFF3AAFA9);

// ── Model Riwayat ─────────────────────────────────────────────────
class _RiwayatSesi {
  final String inisial;
  final String namatutor;
  final String mapel;
  final String tanggal;
  final String jam;
  final String noWa;
  final String status; // 'Menunggu Konfirmasi' | 'Selesai' | 'Terjadwal'

  const _RiwayatSesi({
    required this.inisial,
    required this.namatutor,
    required this.mapel,
    required this.tanggal,
    required this.jam,
    required this.noWa,
    required this.status,
  });
}

class _NotifData {
  final IconData icon;
  final String judul;
  final String subjudul;
  final String waktu;
  const _NotifData({
    required this.icon,
    required this.judul,
    required this.subjudul,
    required this.waktu,
  });
}

// ── Page ──────────────────────────────────────────────────────────
class BerandaOrangtuaPage extends StatefulWidget {
  const BerandaOrangtuaPage({super.key});

  @override
  State<BerandaOrangtuaPage> createState() => _BerandaOrangtuaPageState();
}

class _BerandaOrangtuaPageState extends State<BerandaOrangtuaPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _namaOrangTua = 'Orang Tua';
  static const _paketTersisa = 5;

  static const _notifList = [
    _NotifData(
      icon: Icons.schedule_rounded,
      judul: 'Sesi dimulai 1 jam lagi',
      subjudul: 'Matematika dengan Ibu Sarah pukul 14:00',
      waktu: '13:00',
    ),
    _NotifData(
      icon: Icons.calendar_month_rounded,
      judul: 'Booking diterima',
      subjudul: 'Pak Ahmad menerima booking fisika anda',
      waktu: 'Kemarin',
    ),
  ];

  static const _riwayatList = [
    _RiwayatSesi(
      inisial: 'S',
      namatutor: 'Ibu Sarah',
      mapel: 'Matematika',
      tanggal: '5 Mar 2026',
      jam: '13:00 - 14:00',
      noWa: '6281234567890',
      status: 'Menunggu Konfirmasi',
    ),
    _RiwayatSesi(
      inisial: 'S',
      namatutor: 'Ibu Sarah',
      mapel: 'Matematika',
      tanggal: '3 Mar 2026',
      jam: '13:00 - 14:00',
      noWa: '6281234567890',
      status: 'Selesai',
    ),
    _RiwayatSesi(
      inisial: 'A',
      namatutor: 'Pak Ahmad',
      mapel: 'Fisika',
      tanggal: '28 Feb 2026',
      jam: '10:00 - 11:00',
      noWa: '6289876543210',
      status: 'Selesai',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const OrangtuaDrawer(nama: _namaOrangTua, inisial: 'O'),
      backgroundColor: _teal,
      bottomNavigationBar: OrangTuaBottomNav(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pushReplacementNamed(context, '/orang-tua/jadwal-anak');
          if (i == 2) Navigator.pushReplacementNamed(context, '/orang-tua/laporan-anak');
          if (i == 3) Navigator.pushReplacementNamed(context, '/orang-tua/profil-anak');
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildBimbelCard(),
                    const SizedBox(height: 12),
                    _buildPaketCard(),
                    const SizedBox(height: 20),
                    _buildNotifikasiSection(),
                    const SizedBox(height: 24),
                    _buildRiwayatSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu_rounded,
                color: AppColors.textPrimary, size: 26),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/orang-tua/notifikasi'),
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textPrimary, size: 26),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Selamat datang ',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  Text('👋', style: TextStyle(fontSize: 13)),
                ],
              ),
              Text(
                _namaOrangTua,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Card Bimbel Lazuardy ──────────────────────────────────────
  Widget _buildBimbelCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Logo placeholder
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('LY',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: _teal,
                        )),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bimbel Lazuardy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _teal,
                      ),
                    ),
                    Text(
                      'Belajar Tanpa Batas',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Bimbel Lazuardy adalah platform bimbingan belajar inovatif yang dirancang untuk mewujudkan proses belajar tanpa batas dengan pengalaman yang nyaman dan terpersonalisasi',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card Paket Tersisa ────────────────────────────────────────
  Widget _buildPaketCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paket Tersisa',
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '$_paketTersisa',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: ' sesi',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Notifikasi ────────────────────────────────────────────────
  Widget _buildNotifikasiSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notifikasi',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/orang-tua/notifikasi'),
                child: const Row(children: [
                  Text('Lihat semua',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.white, size: 18),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(n.icon, color: _teal, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.judul,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(n.subjudul,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(n.waktu,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // ── Riwayat Sesi ─────────────────────────────────────────────
  Widget _buildRiwayatSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Sesi',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          const SizedBox(height: 12),
          ..._riwayatList.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRiwayatCard(r),
              )),
        ],
      ),
    );
  }

  Widget _buildRiwayatCard(_RiwayatSesi r) {
    // Status badge
    Color badgeBg;
    Color badgeText;
    if (r.status == 'Selesai') {
      badgeBg = const Color(0xFFE8F5E9);
      badgeText = const Color(0xFF2E7D32);
    } else if (r.status == 'Terjadwal') {
      badgeBg = const Color(0xFFFFF8E1);
      badgeText = const Color(0xFFF57C00);
    } else {
      badgeBg = const Color(0xFFE3F2FD);
      badgeText = const Color(0xFF1565C0);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                r.inisial,
                style: const TextStyle(
                  fontSize: 20,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${r.mapel} — ${r.namatutor}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        r.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: badgeText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${r.tanggal} · ${r.jam}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                // WhatsApp
                GestureDetector(
                  onTap: () {/* TODO: launch WA */},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_rounded,
                            color: Colors.white, size: 13),
                        SizedBox(width: 4),
                        Text('WhatsApp',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}