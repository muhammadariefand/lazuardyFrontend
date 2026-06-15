import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/notification_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_bottom_nav.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_drawer.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/parent_dashboard/parent_dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/parent_dashboard/parent_dashboard_state.dart';

const _teal = Color(0xFF3AAFA9);

class BerandaOrangtuaPage extends StatefulWidget {
  const BerandaOrangtuaPage({super.key});

  @override
  State<BerandaOrangtuaPage> createState() => _BerandaOrangtuaPageState();
}

class _BerandaOrangtuaPageState extends State<BerandaOrangtuaPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      if (!mounted) return;
      context.read<ParentDashboardCubit>().fetchDashboard();
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: BlocBuilder<ParentDashboardCubit, ParentDashboardState>(
        builder: (context, state) {
          String nama = 'Orang Tua';
          String inisial = 'O';
          if (state is ParentDashboardLoaded) {
            nama = state.dashboard.userName;
            inisial = nama.isNotEmpty ? nama[0].toUpperCase() : 'O';
          }
          return OrangtuaDrawer(nama: nama, inisial: inisial);
        },
      ),
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
              child: BlocBuilder<ParentDashboardCubit, ParentDashboardState>(
                builder: (context, state) {
                  if (state is ParentDashboardLoading || state is ParentDashboardInitial) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  } else if (state is ParentDashboardError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ParentDashboardCubit>().fetchDashboard();
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ParentDashboardLoaded) {
                    final dashboard = state.dashboard;
                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<ParentDashboardCubit>().fetchDashboard();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildBimbelCard(),
                            const SizedBox(height: 12),
                            _buildPaketCard(dashboard.session),
                            const SizedBox(height: 20),
                            _buildNotifikasiSection(dashboard.notifications.data),
                            const SizedBox(height: 24),
                            _buildRiwayatSection(dashboard.schedulesHistory.data),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return BlocBuilder<ParentDashboardCubit, ParentDashboardState>(
      builder: (context, state) {
        String nama = 'Orang Tua';
        if (state is ParentDashboardLoaded) {
          nama = state.dashboard.userName;
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 26),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/orang-tua/notifikasi'),
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 26),
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
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      Text('👋', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  Text(
                    nama,
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
      },
    );
  }

  Widget _buildBimbelCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
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

  Widget _buildPaketCard(int paketTersisa) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paket Tersisa',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$paketTersisa',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const TextSpan(
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

  Widget _buildNotifikasiSection(List<NotificationEntity> notifikasiData) {
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
                onTap: () => Navigator.pushNamed(context, '/orang-tua/notifikasi'),
                child: const Row(children: [
                  Text('Lihat semua',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (notifikasiData.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Belum ada notifikasi', style: TextStyle(color: Colors.white70)),
              ),
            )
          else
            ...notifikasiData.map((n) => Padding(
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
                          child: const Icon(Icons.notifications_rounded, color: _teal, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.title,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(n.body,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildRiwayatSection(List<ScheduleEntity> riwayatSesi) {
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
          if (riwayatSesi.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Belum ada riwayat sesi', style: TextStyle(color: Colors.white70)),
              ),
            )
          else
            ...riwayatSesi.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildRiwayatCard(r),
                )),
        ],
      ),
    );
  }

  Widget _buildRiwayatCard(ScheduleEntity r) {
    String statusStr = 'Menunggu Konfirmasi';
    if (r.status == 'completed') {
      statusStr = 'Selesai';
    } else if (r.status == 'active') {
      statusStr = 'Terjadwal';
    } else if (r.status == 'canceled') {
      statusStr = 'Dibatalkan';
    } else {
      statusStr = r.status.toUpperCase();
    }

    Color badgeBg;
    Color badgeText;
    if (statusStr == 'Selesai') {
      badgeBg = const Color(0xFFE8F5E9);
      badgeText = const Color(0xFF2E7D32);
    } else if (statusStr == 'Terjadwal') {
      badgeBg = const Color(0xFFFFF8E1);
      badgeText = const Color(0xFFF57C00);
    } else if (statusStr == 'Dibatalkan') {
      badgeBg = const Color(0xFFFFEBEE);
      badgeText = const Color(0xFFC62828);
    } else {
      badgeBg = const Color(0xFFE3F2FD);
      badgeText = const Color(0xFF1565C0);
    }

    final String inisial = r.tutorName.isNotEmpty ? r.tutorName[0].toUpperCase() : '?';
    final String tanggal = _formatDate(r.date);
    final String jam = '${_formatTime(r.startTime)} - ${_formatTime(r.endTime)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                        '${r.subjectName} — ${r.tutorName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusStr,
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
                  '$tanggal · $jam',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                if (r.tutorTelephoneNumber != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}