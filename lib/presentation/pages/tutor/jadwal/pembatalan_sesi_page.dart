// lib/presentation/pages/tutor/jadwal/pembatalan_sesi_page.dart
// Formulir Pembatalan Sesi Tutor
// Flow:
//   1. Fetch GET /schedule/getById → tampilkan info singkat sesi
//   2. Tutor isi alasan pembatalan (textarea)
//   3. Tap "Batalkan Sesi" → dialog konfirmasi (Ya/Tidak)
//   4. Jika Ya → POST /schedule/cancel → dialog sukses → kembali ke Jadwal

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/pembatalan_sesi/pembatalan_sesi_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/pembatalan_sesi/pembatalan_sesi_state.dart';

const _teal = Color(0xFF3AAFA9);
const _navy = Color(0xFF1E2D7D);
const _red = Color(0xFFE53E3E);
const _orange = Color(0xFFF59E0B);

class PembatalanSesiPage extends StatefulWidget {
  const PembatalanSesiPage({super.key});

  @override
  State<PembatalanSesiPage> createState() => _PembatalanSesiPageState();
}

class _PembatalanSesiPageState extends State<PembatalanSesiPage> {
  final _alasanCtrl = TextEditingController();
  int? _scheduleId;
  ScheduleEntity? _schedule;

  static const _maxChar = 500;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final id = args?['schedule_id'] as int?;
    if (id != null && id != _scheduleId) {
      _scheduleId = id;
      context.read<PembatalanSesiCubit>().fetchScheduleDetail(id);
    }
  }

  @override
  void dispose() {
    _alasanCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────
  String _formatTanggal(DateTime dt) =>
      DateFormat('d MMMM yyyy', 'id').format(dt.toLocal());

  String _formatJam(DateTime start, DateTime end) {
    final f = DateFormat('HH:mm');
    return '${f.format(start.toLocal())} – ${f.format(end.toLocal())}';
  }

  String get _inisialSiswa {
    if (_schedule == null) return '?';
    final nama = _schedule!.studentName.trim();
    final parts = nama.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return nama.isNotEmpty ? nama[0].toUpperCase() : '?';
  }

  // ── Actions ───────────────────────────────────────────────────────
  void _onBatalkanTap() {
    final alasan = _alasanCtrl.text.trim();
    if (alasan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Isi alasan pembatalan terlebih dahulu'),
        backgroundColor: _orange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }
    _showKonfirmasiDialog(alasan);
  }

  void _showKonfirmasiDialog(String alasan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Pembatalan',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan sesi ini? '
          'Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tidak',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PembatalanSesiCubit>().cancelSchedule(
                    scheduleId: _scheduleId!,
                    reason: alasan,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  void _showSuksesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _teal, width: 2.5),
              ),
              child: const Icon(Icons.check_rounded, color: _teal, size: 38),
            ),
            const SizedBox(height: 20),
            const Text('Sesi Dibatalkan',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            const Text(
              'Sesi berhasil dibatalkan. Siswa akan mendapatkan notifikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // tutup dialog
                  Navigator.of(context).pop(true); // kembali ke jadwal, kirim true utk refresh
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Kembali ke Jadwal',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PembatalanSesiCubit, PembatalanSesiState>(
      listener: (context, state) {
        if (state is PembatalanSesiDetailLoaded) {
          setState(() => _schedule = state.schedule);
        }
        if (state is PembatalanSesiSuccess) {
          _showSuksesDialog();
        }
        if (state is PembatalanSesiError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: _red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ));
        }
      },
      builder: (context, state) {
        final isDetailLoading = state is PembatalanSesiDetailLoading;
        final isCancelLoading = state is PembatalanSesiCancelLoading;
        final charCount = _alasanCtrl.text.length;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: _red,
            foregroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Batalkan Sesi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),

          // ── Bottom CTA ─────────────────────────────────────────────
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: (isCancelLoading || _scheduleId == null)
                    ? null
                    : _onBatalkanTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: isCancelLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Icon(Icons.cancel_outlined, size: 20),
                label: const Text('Batalkan Sesi',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ),

          body: isDetailLoading && _schedule == null
              ? const Center(child: CircularProgressIndicator(color: _teal))
              : _schedule == null && state is PembatalanSesiError
                  ? _buildErrorState(context, state.message)
                  : _buildForm(charCount),
        );
      },
    );
  }

  // ── Error state ───────────────────────────────────────────────────
  Widget _buildErrorState(BuildContext context, String message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, color: _red, size: 48),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_scheduleId != null) {
                  context
                      .read<PembatalanSesiCubit>()
                      .fetchScheduleDetail(_scheduleId!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Coba Lagi'),
            ),
          ]),
        ),
      );

  // ── Form utama ────────────────────────────────────────────────────
  Widget _buildForm(int charCount) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 4),

        // ── Banner peringatan ──────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _red.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _red.withValues(alpha: 0.25)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.warning_amber_rounded, color: _red, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Pembatalan sesi akan memberikan dampak pada siswa. '
                'Pastikan Anda telah menghubungi siswa sebelum membatalkan.',
                style: TextStyle(fontSize: 13, color: _red, height: 1.5),
              ),
            ),
          ]),
        ),

        const SizedBox(height: 20),

        // ── Info singkat sesi ──────────────────────────────────────
        if (_schedule != null) _buildSesiInfoCard(_schedule!),

        const SizedBox(height: 24),

        // ── Label alasan ───────────────────────────────────────────
        const Text('Alasan Pembatalan',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Berikan alasan yang jelas agar siswa dapat memahami',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 12),

        // ── Textarea alasan ────────────────────────────────────────
        TextField(
          controller: _alasanCtrl,
          maxLines: 6,
          maxLength: _maxChar,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
              null,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Contoh: Saya ada keperluan mendadak pada waktu tersebut...',
            hintStyle: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _red, width: 1.5),
            ),
          ),
        ),

        // ── Character counter ──────────────────────────────────────
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '$charCount/$_maxChar',
              style: TextStyle(
                fontSize: 12,
                color: charCount >= _maxChar * 0.9
                    ? _red
                    : Colors.grey.shade500,
              ),
            ),
          ),
        ),

        const SizedBox(height: 80),
      ]),
    );
  }

  // ── Kartu info singkat sesi ────────────────────────────────────────
  Widget _buildSesiInfoCard(ScheduleEntity sesi) {
    final isOnline = sesi.learningMethod.toLowerCase() == 'online';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
        ],
      ),
      child: Row(children: [
        // Avatar inisial siswa
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            _inisialSiswa,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: _navy),
          ),
        ),
        const SizedBox(width: 12),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sesi.studentName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              Text(sesi.subjectName,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(_formatTanggal(sesi.date),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 10),
                const Icon(Icons.access_time_outlined,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(_formatJam(sesi.startTime, sesi.endTime),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ]),
            ],
          ),
        ),

        // Badge online/offline
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isOnline
                ? const Color(0xFF3B82F6).withValues(alpha: 0.1)
                : const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isOnline
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF10B981),
            ),
          ),
        ),
      ]),
    );
  }
}
