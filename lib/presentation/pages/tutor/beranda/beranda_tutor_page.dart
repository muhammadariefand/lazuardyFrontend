// lib/presentation/pages/tutor/beranda_tutor_page.dart
// Beranda Tutor
// - 3 stat cards: Rating / Sesi Bulan Ini / Total Siswa
// - 2 pendapatan cards: Total Pendapatan + Saldo Escrow
// - 4 menu grid: Manajemen Sesi / Profil Mengajar / Ulasan Siswa / Tarik Saldo
// - Notifikasi section

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_dashboard_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_dashboard/tutor_dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_dashboard/tutor_dashboard_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_buttom_nav.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_drawer.dart';

const _teal = Color(0xFF3AAFA9);

class BerandaTutorPage extends StatefulWidget {
  const BerandaTutorPage({super.key});
  @override
  State<BerandaTutorPage> createState() => _BerandaTutorPageState();
}

class _BerandaTutorPageState extends State<BerandaTutorPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TutorDashboardCubit>().loadDashboard();
    });
  }

  // ── Format Rupiah ─────────────────────────────────────────────
  String _rp(num v) {
    final s = v.toInt().toString();
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
      drawer: BlocBuilder<TutorDashboardCubit, TutorDashboardState>(
        builder: (context, state) {
          if (state is TutorDashboardLoaded) {
            final tutor = state.dashboardData.tutor;
            return TutorDrawer(
              nama: tutor.name.isNotEmpty ? tutor.name : 'Tutor',
              inisial: tutor.name.isNotEmpty ? tutor.name[0].toUpperCase() : 'T',
            );
          }
          return const TutorDrawer(nama: 'Tutor', inisial: 'T');
        },
      ),
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
        child: BlocBuilder<TutorDashboardCubit, TutorDashboardState>(
          builder: (context, state) {
            if (state is TutorDashboardInitial || state is TutorDashboardLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (state is TutorDashboardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<TutorDashboardCubit>().loadDashboard(),
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                ),
              );
            }

            if (state is TutorDashboardLoaded) {
              final data = state.dashboardData;
              return Column(children: [
                _buildAppBar(data.tutor.name),
                Expanded(child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: 16),

                    // ── Warning banner (kondisional) ─────────────────
                    if (data.warning > 0) ...[
                      _buildWarningBanner(data.warning),
                      const SizedBox(height: 12),
                    ],

                    // ── 3 stat cards ─────────────────────────────────
                    _buildStatCards(
                      rating: data.tutor.avgRate?.toStringAsFixed(1) ?? '0.0',
                      sesiBulanIni: data.schedulesTotal.toString(),
                      totalSiswa: data.studentTotal.toString(),
                    ),
                    const SizedBox(height: 12),

                    // ── 2 pendapatan cards ────────────────────────────
                    _buildPendapatanRow(
                      totalPendapatan: data.salaryStats,
                      saldoEscrow: data.salary,
                    ),
                    const SizedBox(height: 20),

                    // ── 4 menu grid ───────────────────────────────────
                    _buildMenuGrid(),
                    const SizedBox(height: 24),

                    // ── Notifikasi ────────────────────────────────────
                    _buildNotifikasiSection(data),
                    const SizedBox(height: 32),
                  ]),
                )),
              ]);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar(String nama) {
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
          Text(nama, style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ]),
      ]),
    );
  }

  // ── Warning Banner ────────────────────────────────────────────
  Widget _buildWarningBanner(int warningCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('⚠️', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.5),
              children: [
                TextSpan(
                  text: 'Peringatan ($warningCount/3)\n',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: 'Anda telah menerima peringatan dari admin.\nJika mencapai 3 peringatan, akun akan '),
                const TextSpan(
                  text: 'disuspend selama 7 hari',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: '.\n Mohon gunakan platform sesuai ketentuan.'),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // ── 3 Stat Cards ─────────────────────────────────────────────
  Widget _buildStatCards({
    required String rating,
    required String sesiBulanIni,
    required String totalSiswa,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        _statCard('⭐', rating, 'Rating'),
        const SizedBox(width: 10),
        _statCard('📅', sesiBulanIni, 'Sesi Bulan Ini'),
        const SizedBox(width: 10),
        _statCard('👤', totalSiswa, 'Total Siswa'),
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
  Widget _buildPendapatanRow({required double totalPendapatan, required double saldoEscrow}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Expanded(child: _pendapatanCard(
          icon: '📈',
          title: 'Total Pendapatan',
          amount: totalPendapatan,
          sub: 'Total seluruh penghasilan',
        )),
        const SizedBox(width: 12),
        Expanded(child: _pendapatanCard(
          icon: '💳',
          title: 'Saldo Tersedia',
          amount: saldoEscrow,
          sub: 'Siap ditarik',
        )),
      ]),
    );
  }

  Widget _pendapatanCard({
    required String icon,
    required String title,
    required double amount,
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
          return Builder(
            builder: (context) {
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
            }
          );
        }).toList(),
      ),
    );
  }

  // ── Notifikasi ────────────────────────────────────────────────
  Widget _buildNotifikasiSection(TutorDashboardEntity data) {
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
        if (data.notifications.data.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Belum ada notifikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          )
        else
          ...data.notifications.data.map((n) => Padding(
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
                  child: const Icon(Icons.notifications_active, color: _teal, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(n.title, style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(n.body, style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                ])),
              ]),
            ),
          )),
      ]),
    );
  }
}