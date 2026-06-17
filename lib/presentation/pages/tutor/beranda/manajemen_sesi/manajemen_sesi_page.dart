// lib/presentation/pages/tutor/beranda/manajemen_sesi/manajemen_sesi_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/manajemen_sesi/riwayat_sesi_detail_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/manajemen_sesi/laporan_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_state.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/laporan_sesi/laporan_sesi_cubit.dart';
import 'package:lazuadry_mobile_fe/dependency_injection.dart';
import 'package:url_launcher/url_launcher.dart';


class ManajemenSesiPage extends StatefulWidget {
  const ManajemenSesiPage({super.key});

  @override
  State<ManajemenSesiPage> createState() => _ManajemenSesiPageState();
}

class _ManajemenSesiPageState extends State<ManajemenSesiPage> {
  int _selectedTab = 0; // 0: Mendatang, 1: Riwayat

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<ScheduleCubit>().loadSchedules(
          status: _selectedTab == 0 ? 'active' : 'completed',
          date: '',
        );
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(),
          const SizedBox(height: 20),
          _buildTabToggle(),
          const SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => _loadData(),
              child: BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoading || state is ScheduleInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state is ScheduleError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message, style: const TextStyle(color: AppColors.errorRed)),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _loadData,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ScheduleLoaded) {
                    final list = state.data.data;
                    if (list.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tidak ada data sesi',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (_, i) {
                        final item = list[i];
                        if (_selectedTab == 0) {
                          return _buildMendatangCard(item);
                        } else {
                          return _buildRiwayatCard(item);
                        }
                      },
                    );
                  }

                  return const SizedBox();
                },
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
        onTap: () {
          setState(() => _selectedTab = index);
          _loadData();
        },
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
  Widget _buildMendatangCard(ScheduleEntity sesi) {
    final isOnline = sesi.learningMethod.toLowerCase() == 'online';
    final tanggal = _formatLongDate(sesi.date);
    final jamMulai = _formatTime(sesi.startTime);
    final jamSelesai = _formatTime(sesi.endTime);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
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
              nama: sesi.studentName,
              mapel: sesi.subjectName,
              tanggal: tanggal,
              isOnline: isOnline,
            ),
            const SizedBox(height: 12),
            _buildJamRow(
              jamMulai: jamMulai,
              jamSelesai: jamSelesai,
              nomorWa: sesi.studentTelephoneNumber,
            ),
            const SizedBox(height: 10),
            if (isOnline && sesi.meetingLink != null && sesi.meetingLink!.isNotEmpty)
              _buildInfoBox(
                icon: Icons.videocam_outlined,
                title: 'Link Meeting',
                content: sesi.meetingLink!,
                isLink: true,
                onTap: () => _openUrl(sesi.meetingLink!),
              )
            else if (!isOnline && sesi.address.isNotEmpty)
              _buildAlamatBox(sesi.address),
            const SizedBox(height: 14),
            _buildTandaiButton(sesi),
          ],
        ),
      ),
    );
  }

  Widget _buildTandaiButton(ScheduleEntity sesi) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<LaporanSesiCubit>(
                create: (_) => sl<LaporanSesiCubit>(),
                child: LaporanSesiPage(sesi: sesi),
              ),
            ),
          ).then((_) {
            _loadData();
          });
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
          backgroundColor: AppColors.primary,
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
  Widget _buildRiwayatCard(ScheduleEntity sesi) {
    final isOnline = sesi.learningMethod.toLowerCase() == 'online';
    final tanggal = _formatLongDate(sesi.date);
    final jamMulai = _formatTime(sesi.startTime);
    final jamSelesai = _formatTime(sesi.endTime);

    // Dummy status logic, assuming if it's completed, it's finished.
    // the backend will probably return more details if report is filled etc.
    // We'll just display "Selesai" badge.
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
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
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
                nama: sesi.studentName,
                mapel: sesi.subjectName,
                tanggal: tanggal,
                isOnline: isOnline,
              ),
              const SizedBox(height: 12),
              _buildJamRow(
                jamMulai: jamMulai,
                jamSelesai: jamSelesai,
                nomorWa: sesi.studentTelephoneNumber,
              ),
              const SizedBox(height: 8),
              if (sesi.status == 'completed' || sesi.status == 'reported')
                _buildStatusRow(
                    Icons.check_circle_outline_rounded, 'Sesi Selesai'),
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
    final inisial = nama.isNotEmpty ? nama[0].toUpperCase() : '?';
    return Row(
      children: [
        _buildAvatar(inisial),
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
    required String? nomorWa,
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
        if (nomorWa != null && nomorWa.isNotEmpty)
          _buildWhatsAppButton(nomorWa),
      ],
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String content,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                      color: isLink ? AppColors.primary : AppColors.textPrimary,
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
              _openUrl('https://maps.google.com/?q=${Uri.encodeComponent(alamat)}');
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