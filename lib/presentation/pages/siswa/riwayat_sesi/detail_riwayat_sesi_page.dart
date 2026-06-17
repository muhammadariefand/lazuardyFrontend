// lib/presentation/pages/siswa/detail_riwayat_sesi_page.dart
// Detail Riwayat Sesi — fetch via RiwayatSesiCubit.fetchScheduleById
// Status:
//   reported  → tombol Konfirmasi Selesai
//   completed → tombol Beri Rating Tutor
//   cancelled → banner dibatalkan
//   lainnya   → tampilkan detail saja

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import '../../../../domain/entities/schedule_entity.dart';
import '../../../state_management/riwayat_sesi/riwayat_sesi_cubit.dart';
import '../../../state_management/riwayat_sesi/riwayat_sesi_state.dart';

const _purple = Color(0xFF8B5CF6);

class DetailRiwayatSesiPage extends StatefulWidget {
  const DetailRiwayatSesiPage({super.key});

  @override
  State<DetailRiwayatSesiPage> createState() => _DetailRiwayatSesiPageState();
}

class _DetailRiwayatSesiPageState extends State<DetailRiwayatSesiPage> {
  int? _scheduleId;
  ScheduleEntity? _schedule;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final id = args?['schedule_id'] as int?;
    if (id != null && id != _scheduleId) {
      _scheduleId = id;
      context.read<RiwayatSesiCubit>().fetchScheduleById(id);
    }
  }

  String _formatTanggal(DateTime dt) =>
      DateFormat('d MMMM yyyy', 'id').format(dt.toLocal());

  String _formatJam(DateTime start, DateTime end) {
    final f = DateFormat('HH:mm');
    return '${f.format(start.toLocal())} - ${f.format(end.toLocal())}';
  }

  String get _tutorInisial {
    if (_schedule == null) return '?';
    final parts = _schedule!.tutorName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _schedule!.tutorName.isNotEmpty
        ? _schedule!.tutorName[0].toUpperCase()
        : '?';
  }

  void _onKonfirmasiSelesai() {
    if (_scheduleId == null) return;
    context.read<RiwayatSesiCubit>().markComplete(_scheduleId!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiwayatSesiCubit, RiwayatSesiState>(
      listener: (context, state) {
        if (state is ScheduleDetailLoaded) {
          setState(() => _schedule = state.schedule);
        }
        if (state is RiwayatSesiError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ));
        }
        if (state is MarkCompleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Sesi berhasil dikonfirmasi selesai'),
            backgroundColor: AppColors.successGreen,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ));
          Navigator.pop(context, true); // kirim 'true' untuk refresh list
        }
      },
      builder: (context, state) {
        final isLoading = state is RiwayatSesiLoading;
        final isMarkCompleteLoading = state is MarkCompleteLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Detail Sesi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),

          // ── Sticky bottom button ───────────────────────────────────
          bottomNavigationBar:
              _schedule != null ? _buildBottomBar(context, _schedule!, isMarkCompleteLoading) : null,

          body: isLoading && _schedule == null
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _schedule == null
                  ? _buildErrorState(context)
                  : _buildBody(_schedule!),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.errorRed, size: 48),
            const SizedBox(height: 12),
            const Text('Gagal memuat detail sesi',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_scheduleId != null) {
                  context.read<RiwayatSesiCubit>().fetchScheduleById(_scheduleId!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );

  Widget _buildBody(ScheduleEntity sesi) {
    final status = sesi.status.toLowerCase();
    final isCancelled = status == 'cancelled';
    final isReported = status == 'reported';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const SizedBox(height: 4),

        // ── Kartu tutor + status ────────────────────────────
        _buildTutorCard(sesi),
        const SizedBox(height: 16),

        // ── Banner dibatalkan ────────────────────────────────
        if (isCancelled) ...[
          _buildDibatalkanBanner(),
          const SizedBox(height: 16),
        ],

        // ── Info tanggal/waktu/mode ──────────────────────────
        _buildInfoCard(sesi, isCancelled),
        const SizedBox(height: 16),

        // ── Banner Konfirmasi Penyelesaian (reported) ─────────
        if (isReported) _buildKonfirmasiBanner(),

        // ── Info meeting link (online & ada link) ─────────────
        if (!isCancelled && sesi.learningMethod.toLowerCase() == 'online' &&
            sesi.meetingLink != null &&
            sesi.meetingLink!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildMeetingLinkCard(sesi.meetingLink!),
        ],

        const SizedBox(height: 24),
      ]),
    );
  }

  // ── Bottom bar kondisional ─────────────────────────────────────
  Widget? _buildBottomBar(
      BuildContext context, ScheduleEntity sesi, bool isLoading) {
    final status = sesi.status.toLowerCase();

    if (status == 'completed') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(
              context,
              '/siswa/riwayat-sesi/rating',
              arguments: {
                'tutor_id': sesi.tutorId,
                'tutor_nama': sesi.tutorName,
                'tutor_inisial': _tutorInisial,
                'mapel': sesi.subjectName,
              },
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.star_rounded, size: 20),
            label: const Text('Beri Rating Tutor',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      );
    }
    return null;
  }

  // ── Kartu tutor ────────────────────────────────────────────────
  Widget _buildTutorCard(ScheduleEntity sesi) {
    final status = sesi.status.toLowerCase();
    Color badgeColor;
    String badgeLabel;

    switch (status) {
      case 'reported':
        badgeColor = _purple;
        badgeLabel = 'Menunggu Konfirmasi';
        break;
      case 'completed':
        badgeColor = AppColors.successGreen;
        badgeLabel = 'Selesai';
        break;
      case 'cancelled':
        badgeColor = AppColors.errorRed;
        badgeLabel = 'Dibatalkan';
        break;
      case 'ongoing':
        badgeColor = AppColors.primary;
        badgeLabel = 'Sedang Berlangsung';
        break;
      default:
        badgeColor = AppColors.warningYellow;
        badgeLabel = 'Menunggu';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Row(children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            _tutorInisial,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.secondary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sesi.tutorName,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              Text(sesi.subjectName,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              if (sesi.tutorTelephoneNumber != null &&
                  sesi.tutorTelephoneNumber!.isNotEmpty)
                _whatsappBadge(sesi.tutorTelephoneNumber!),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor.withOpacity(0.3)),
          ),
          child: Text(badgeLabel,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: badgeColor)),
        ),
      ]),
    );
  }

  // ── Banner dibatalkan ──────────────────────────────────────────
  Widget _buildDibatalkanBanner() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.errorRed.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.errorRed, width: 1.5)),
            child: const Icon(Icons.close_rounded, color: AppColors.errorRed, size: 16),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sesi Dibatalkan',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.errorRed)),
                SizedBox(height: 4),
                Text(
                    'Sesi ini telah dibatalkan. Hubungi admin jika ada pertanyaan.',
                    style: TextStyle(fontSize: 13, color: AppColors.errorRed, height: 1.4)),
              ],
            ),
          ),
        ]),
      );

  // ── Info card (tanggal/waktu/mode) ─────────────────────────────
  Widget _buildInfoCard(ScheduleEntity sesi, bool isDibatalkan) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
          ],
        ),
        child: Column(children: [
          _infoRow(Icons.access_time_outlined, 'Tanggal',
              _formatTanggal(sesi.date),
              strikethrough: isDibatalkan),
          const Divider(height: 20),
          _infoRow(Icons.calendar_today_outlined, 'Waktu',
              _formatJam(sesi.startTime, sesi.endTime),
              strikethrough: isDibatalkan),
          const Divider(height: 20),
          _infoRow(
            sesi.learningMethod.toLowerCase() == 'online'
                ? Icons.videocam_outlined
                : Icons.location_on_outlined,
            'Mode',
            sesi.learningMethod[0].toUpperCase() +
                sesi.learningMethod.substring(1),
            strikethrough: isDibatalkan,
          ),
          if (sesi.studentName.isNotEmpty) ...[
            const Divider(height: 20),
            _infoRow(Icons.person_outline, 'Siswa', sesi.studentName),
          ],
        ]),
      );

  Widget _infoRow(IconData icon, String label, String value,
          {bool strikethrough = false}) =>
      Row(children: [
        Icon(icon, size: 22, color: AppColors.textSecondary),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          Text(value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: strikethrough
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                decoration: strikethrough
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              )),
        ]),
      ]);

  // ── Meeting link card ──────────────────────────────────────────
  Widget _buildMeetingLinkCard(String link) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.link_rounded,
              color: Color(0xFF3B82F6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Link Meeting',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                Text(link,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ]),
      );

  // ── Banner Konfirmasi Penyelesaian (reported) ──────────────────
  Widget _buildKonfirmasiBanner() {
    return BlocBuilder<RiwayatSesiCubit, RiwayatSesiState>(
      builder: (context, state) {
        final isLoading = state is MarkCompleteLoading;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.info_outline_rounded, color: AppColors.warningYellow, size: 20),
              SizedBox(width: 8),
              Text('Konfirmasi Penyelesaian',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF92400E))),
            ]),
            const SizedBox(height: 6),
            const Text(
              'Tutor telah menandai sesi ini selesai. Konfirmasi jika sudah benar. Auto-konfirmasi dalam 24 jam',
              style: TextStyle(
                  fontSize: 12, color: Color(0xFF92400E), height: 1.5),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _onKonfirmasiSelesai,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Icon(Icons.check_rounded, size: 18),
                label: const Text('Konfirmasi Selesai',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _whatsappBadge(String phone) => GestureDetector(
        onTap: () {
          // Bisa dibuka di WhatsApp via url_launcher
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.successGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.chat_rounded, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(phone,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ]),
        ),
      );
}