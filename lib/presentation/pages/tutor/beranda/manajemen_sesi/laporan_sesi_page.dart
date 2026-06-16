// lib/presentation/pages/tutor/beranda/manajemen_sesi/laporan_sesi_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/laporan_sesi/laporan_sesi_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/laporan_sesi/laporan_sesi_state.dart';
import 'package:url_launcher/url_launcher.dart';

const _teal = Color(0xFF3AAFA9);

class LaporanSesiPage extends StatefulWidget {
  final ScheduleEntity sesi;

  const LaporanSesiPage({super.key, required this.sesi});

  @override
  State<LaporanSesiPage> createState() => _LaporanSesiPageState();
}

class _LaporanSesiPageState extends State<LaporanSesiPage> {
  final _topikController = TextEditingController();
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _topikController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _kirimLaporan() {
    if (_topikController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Topik yang dibahas tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<LaporanSesiCubit>().kirimLaporan(
          scheduleId: widget.sesi.id,
          topic: _topikController.text.trim(),
          notes: _catatanController.text.trim(),
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
    final sesi = widget.sesi;
    final isOnline = sesi.learningMethod.toLowerCase() == 'online';
    final tanggal = _formatLongDate(sesi.date);
    final jamMulai = _formatTime(sesi.startTime);
    final jamSelesai = _formatTime(sesi.endTime);

    return BlocConsumer<LaporanSesiCubit, LaporanSesiState>(
      listener: (context, state) {
        if (state is LaporanSesiSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: _teal,
            ),
          );
          Navigator.pop(context); // kembali ke ManajemenSesiPage
        } else if (state is LaporanSesiError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LaporanSesiLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      const Text(
                        'Isi perkembangan belajar siswa',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Kartu Info Sesi ────────────────────────────
                      _buildSesiCard(
                        sesi: sesi,
                        tanggal: tanggal,
                        jamMulai: jamMulai,
                        jamSelesai: jamSelesai,
                        isOnline: isOnline,
                      ),
                      const SizedBox(height: 24),

                      // ── Form Topik ────────────────────────────────
                      const Text(
                        'Topik yang Dibahas',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _topikController,
                        hint: 'Masukan topik yang dibahas',
                        minLines: 3,
                        maxLines: 5,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 20),

                      // ── Form Catatan ──────────────────────────────
                      const Text(
                        'Catatan Untuk Siswa',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _catatanController,
                        hint: 'Masukan catatan untuk siswa',
                        minLines: 5,
                        maxLines: 8,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Bottom Buttons ────────────────────────────────────
              _buildBottomButtons(isLoading),
            ],
          ),
        );
      },
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
            'Laporan Sesi',
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

  // ── Kartu Info Sesi ───────────────────────────────────────────
  Widget _buildSesiCard({
    required ScheduleEntity sesi,
    required String tanggal,
    required String jamMulai,
    required String jamSelesai,
    required bool isOnline,
  }) {
    final inisial = sesi.studentName.isNotEmpty ? sesi.studentName[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _teal.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: avatar + info + badge
          Row(
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
                    const SizedBox(height: 2),
                    Text(
                      '${sesi.subjectName} · $tanggal',
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
          ),
          const SizedBox(height: 12),

          // Jam + WhatsApp
          Row(
            children: [
              const Icon(Icons.schedule_rounded,
                  size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                '$jamMulai - $jamSelesai',
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 12),
              if (sesi.studentTelephoneNumber != null && sesi.studentTelephoneNumber!.isNotEmpty)
                _buildWhatsAppButton(sesi.studentTelephoneNumber!),
            ],
          ),
        ],
      ),
    );
  }

  // ── TextField ─────────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int minLines,
    required int maxLines,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      enabled: enabled,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _teal.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _teal, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  // ── Bottom Buttons ────────────────────────────────────────────
  Widget _buildBottomButtons(bool isLoading) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          // Batal
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: _teal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _teal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Kirim Laporan
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isLoading ? null : _kirimLaporan,
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Kirim Laporan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared Widgets ────────────────────────────────────────────
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