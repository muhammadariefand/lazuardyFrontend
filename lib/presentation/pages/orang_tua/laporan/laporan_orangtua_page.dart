// lib/presentation/pages/orangtua/laporan_orangtua_page.dart
// Image 5: Laporan Pembelajaran
// - AppBar teal "Laporan Pembelajaran"
// - List card per mata pelajaran:
//   nama mapel (teal bold) + tutor • tanggal
//   sub-card abu: Topik (bold) + catatan

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_bottom_nav.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/report/report_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/report/report_state.dart';

const _teal = Color(0xFF3AAFA9);


// ── Page ──────────────────────────────────────────────────────────
class LaporanOrangtuaPage extends StatefulWidget {
  const LaporanOrangtuaPage({super.key});

  @override
  State<LaporanOrangtuaPage> createState() => _LaporanOrangtuaPageState();
}

class _LaporanOrangtuaPageState extends State<LaporanOrangtuaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportCubit>().loadReports(page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: OrangTuaBottomNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/orang-tua/beranda');
          if (i == 1) Navigator.pushReplacementNamed(context, '/orang-tua/jadwal-anak');
          if (i == 3) Navigator.pushReplacementNamed(context, '/orang-tua/profil-anak');
        },
      ),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: BlocBuilder<ReportCubit, ReportState>(
              builder: (context, state) {
                if (state is ReportLoading || state is ReportInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ReportError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: () => context.read<ReportCubit>().loadReports(page: 1),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ReportLoaded) {
                  final reports = state.data.data;
                  
                  if (reports.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.assignment_outlined,
                              size: 80,
                              color: Color(0xFFE0E0E0),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada laporan pembelajaran',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _buildLaporanCard(reports[i]),
                  );
                }

                return const SizedBox();
              },
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
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Laporan Pembelajaran',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  // ── Card Laporan ──────────────────────────────────────────────
  Widget _buildLaporanCard(dynamic report) { // Menggunakan dynamic atau ReportEntity (jika di-import)
    final tanggalStr = _formatDate(report.createdAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _teal.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topik sebagai header utama (teal) - Karena tidak ada mapel di API
          Text(
            report.topic.isEmpty ? 'Sesi Pembelajaran' : report.topic,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _teal,
            ),
          ),
          const SizedBox(height: 2),
          // Tutor + tanggal
          Text(
            '${report.tutorName} · $tanggalStr',
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Sub-card abu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan Tutor:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  report.notes.isEmpty ? '-' : report.notes,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.5,
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