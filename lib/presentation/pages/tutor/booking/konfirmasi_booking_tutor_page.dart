// lib/presentation/pages/tutor/booking/konfirmasi_booking_tutor_page.dart
// - Tab Pending / Semua
// - Kartu booking: Online (tanpa alamat) & Offline (+ kotak alamat+maps)
// - Tombol Terima (teal) → push Form Link Meeting jika Online, langsung terima jika Offline
// - Tombol Tolak (merah muda) → dialog konfirmasi tolak (Image 5)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/booking_confirmation_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_buttom_nav.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';


class KonfirmasiBookingTutorPage extends StatefulWidget {
  const KonfirmasiBookingTutorPage({super.key});
  @override
  State<KonfirmasiBookingTutorPage> createState() =>
      _KonfirmasiBookingTutorPageState();
}

class _KonfirmasiBookingTutorPageState
    extends State<KonfirmasiBookingTutorPage> {
  bool _showPending = true; // true = tab Pending, false = tab Semua

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<ScheduleCubit>().loadSchedules(
      status: _showPending ? 'pending' : '',
      date: '',
    );
  }

  // ── Terima booking ────────────────────────────────────────────
  void _onTerima(ScheduleEntity item) {
    if (item.learningMethod.toLowerCase() == 'online') {
      // Online → push Form Link Meeting
      Navigator.pushNamed(
        context, 
        '/tutor/form-link-meeting',
        arguments: {'booking': item},
      ).then((_) {
        // Refresh data when returning from form
        _loadData();
      });
    } else {
      // Offline → langsung terima
      context.read<BookingConfirmationCubit>().confirmBooking(
        scheduleId: item.id, 
        decision: 'accept',
      );
    }
  }

  // ── Dialog tolak ──────────────────────────────────────────────
  void _showTolakDialog(ScheduleEntity item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Icon segitiga merah
            Container(
              width: 68, height: 68,
              decoration: const BoxDecoration(color: Color(0xFFFFEBEE), shape: BoxShape.circle),
              child: const Icon(Icons.warning_rounded, color: AppColors.errorRed, size: 38),
            ),
            const SizedBox(height: 20),
            const Text('Tolak Booking?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Text(
              'Booking dari ${item.studentName} akan ditolak dan kuota '
              'akan dikembalikan ke siswa. Tindakan ini tidak bisa dibatalkan',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13,
                  color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Batal',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<BookingConfirmationCubit>().confirmBooking(
                    scheduleId: item.id, 
                    decision: 'reject',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Ya, Tolak',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              )),
            ]),
          ]),
        ),
      ),
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
    return BlocListener<BookingConfirmationCubit, BookingConfirmationState>(
      listener: (context, state) {
        if (state is BookingConfirmationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.successGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadData();
        } else if (state is BookingConfirmationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: TutorBottomNav(
          currentIndex: 2,
          onTap: (i) {
            if (i == 0) Navigator.pushReplacementNamed(context, '/tutor/beranda');
            if (i == 1) Navigator.pushReplacementNamed(context, '/tutor/jadwal');
            if (i == 3) Navigator.pushReplacementNamed(context, '/tutor/profil');
          },
        ),
        body: Column(children: [
          // ── Teal Header ──────────────────────────────────────────
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Konfirmasi Booking',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────
          Expanded(child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => _loadData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 16),
                const Text('Terima atau tolak permintaan booking siswa',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 14),

                // ── Tab Pending / Semua ──────────────────────────────
                _buildTabSelector(),
                const SizedBox(height: 16),

                // ── List booking ─────────────────────────────────────
                BlocBuilder<ScheduleCubit, ScheduleState>(
                  builder: (context, state) {
                    if (state is ScheduleLoading || state is ScheduleInitial) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                      );
                    }

                    if (state is ScheduleError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: Column(
                            children: [
                              Text(state.message, style: const TextStyle(color: AppColors.errorRed)),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _loadData,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is ScheduleLoaded) {
                      final list = state.data.data;
                      if (list.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(child: Text('Tidak ada booking',
                              style: TextStyle(fontSize: 14,
                                  color: AppColors.textSecondary))),
                        );
                      }

                      return Column(
                        children: list.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _BookingCard(
                            item: item,
                            tanggalFormatted: _formatLongDate(item.date),
                            jamFormatted: '${_formatTime(item.startTime)} - ${_formatTime(item.endTime)}',
                            onTerima: () => _onTerima(item),
                            onTolak:  () => _showTolakDialog(item),
                            onOpenMaps: () => _openUrl('https://maps.google.com/?q=${Uri.encodeComponent(item.address)}'),
                            onWA: () {
                              final number = item.studentTelephoneNumber;
                              if (number != null && number.isNotEmpty) {
                                _openUrl('https://wa.me/$number');
                              }
                            },
                          ),
                        )).toList(),
                      );
                    }

                    return const SizedBox();
                  },
                ),

                const SizedBox(height: 24),
              ]),
            ),
          )),
        ]),
      ),
    );
  }

  // ── Tab selector ──────────────────────────────────────────────
  Widget _buildTabSelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(children: [
        Expanded(child: GestureDetector(
          onTap: () {
            setState(() => _showPending = true);
            _loadData();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: _showPending ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(26),
              boxShadow: _showPending
                  ? [BoxShadow(color: Colors.black.withOpacity(0.07),
                      blurRadius: 6)]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text('Pending',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: _showPending
                        ? FontWeight.w700 : FontWeight.w400,
                    color: _showPending
                        ? AppColors.textPrimary
                        : AppColors.textSecondary)),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () {
            setState(() => _showPending = false);
            _loadData();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: !_showPending ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(26),
              boxShadow: !_showPending
                  ? [BoxShadow(color: Colors.black.withOpacity(0.07),
                      blurRadius: 6)]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text('Semua',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: !_showPending
                        ? FontWeight.w700 : FontWeight.w400,
                    color: !_showPending
                        ? AppColors.textPrimary
                        : AppColors.textSecondary)),
          ),
        )),
      ]),
    );
  }
}

// ── Kartu Booking ─────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final ScheduleEntity item;
  final String tanggalFormatted;
  final String jamFormatted;
  final VoidCallback onTerima, onTolak, onWA, onOpenMaps;

  const _BookingCard({
    required this.item,
    required this.tanggalFormatted,
    required this.jamFormatted,
    required this.onTerima,
    required this.onTolak,
    required this.onWA,
    required this.onOpenMaps,
  });

  bool get _isOffline => item.learningMethod.toLowerCase() == 'offline';

  @override
  Widget build(BuildContext context) {
    final inisial = item.studentName.isNotEmpty ? item.studentName[0].toUpperCase() : '?';

    // Badge status mapping
    Color statusColor = AppColors.warningYellow;
    String statusText = item.status;
    if (item.status == 'accepted') {
      statusColor = AppColors.successGreen;
      statusText = 'Diterima';
    } else if (item.status == 'rejected') {
      statusColor = AppColors.errorRed;
      statusText = 'Ditolak';
    } else if (item.status == 'pending') {
      statusColor = AppColors.warningYellow;
      statusText = 'Pending';
    } else {
      statusColor = AppColors.textSecondary;
      statusText = item.status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Row 1: Avatar + Info + Badge Status ─────────────────
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(inisial,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                    color: AppColors.secondary)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.studentName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text('${item.subjectName} · $tanggalFormatted',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ])),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(statusText,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
          ),
        ]),

        const SizedBox(height: 10),

        // ── Row 2: Jam + Mode + WA ─────────────────────────────
        Row(children: [
          const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(jamFormatted, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(width: 10),
          // Mode badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: _isOffline ? AppColors.errorRed.withOpacity(0.08) : AppColors.successGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isOffline ? AppColors.errorRed.withOpacity(0.3) : AppColors.successGreen.withOpacity(0.3)),
            ),
            child: Text(_isOffline ? 'Offline' : 'Online',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: _isOffline ? AppColors.errorRed : AppColors.successGreen)),
          ),
          const SizedBox(width: 8),
          // WA badge
          if (item.studentTelephoneNumber != null && item.studentTelephoneNumber!.isNotEmpty)
            GestureDetector(
              onTap: onWA,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.chat_rounded, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text('WhatsApp',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ]),
              ),
            ),
        ]),

        // ── Kotak alamat (hanya Offline) ──────────────────────────
        if (_isOffline && item.address.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.location_on_outlined, size: 15, color: AppColors.textSecondary),
                SizedBox(width: 5),
                Text('Alamat Lokasi sesi',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 5),
              Text(item.address,
                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onOpenMaps,
                child: const Row(children: [
                  Icon(Icons.open_in_new_rounded, size: 13, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text('Buka di Google Maps',
                      style: TextStyle(fontSize: 12, color: AppColors.primary,
                          fontWeight: FontWeight.w500)),
                ]),
              ),
            ]),
          ),
        ],

        // Tombol aksi hanya tampil jika status masih pending
        if (item.status == 'pending') ...[
          const SizedBox(height: 14),

          // ── Tombol Terima + Tolak ──────────────────────────────
          Row(children: [
            Expanded(child: SizedBox(
              height: 44,
              child: BlocBuilder<BookingConfirmationCubit, BookingConfirmationState>(
                builder: (context, state) {
                  return ElevatedButton.icon(
                    onPressed: state is BookingConfirmationLoading ? null : onTerima,
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                    label: const Text('Terima',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            )),
            const SizedBox(width: 10),
            Expanded(child: SizedBox(
              height: 44,
              child: BlocBuilder<BookingConfirmationCubit, BookingConfirmationState>(
                builder: (context, state) {
                  return ElevatedButton.icon(
                    onPressed: state is BookingConfirmationLoading ? null : onTolak,
                    icon: Icon(Icons.cancel_outlined, size: 18, color: AppColors.errorRed),
                    label: Text('Tolak',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                            color: AppColors.errorRed)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorRed.withOpacity(0.1),
                      foregroundColor: AppColors.errorRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            )),
          ]),
        ],
      ]),
    );
  }
}