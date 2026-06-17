// lib/presentation/pages/tutor/booking/form_link_meeting_page.dart
// Form Link Meeting
// - Kartu ringkasan sesi siswa (Online)
// - Input link meeting + icon videocam
// - State kosong → banner info kuning (Image 3)
// - State terisi+simpan berhasil → banner sukses hijau (Image 4)
// - Tombol sticky: Batal + Simpan & Kirim

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/booking_confirmation_cubit.dart';
import 'package:url_launcher/url_launcher.dart';


// ── Status banner ─────────────────────────────────────────────────
enum _BannerState { info, success }

class FormLinkMeetingPage extends StatefulWidget {
  const FormLinkMeetingPage({super.key});
  @override
  State<FormLinkMeetingPage> createState() => _FormLinkMeetingPageState();
}

class _FormLinkMeetingPageState extends State<FormLinkMeetingPage> {
  final _linkCtrl = TextEditingController();
  _BannerState _bannerState = _BannerState.info;
  ScheduleEntity? _booking;

  @override
  void dispose() {
    _linkCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_booking == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      _booking = args?['booking'] as ScheduleEntity?;
    }
  }

  // ── Validasi URL ──────────────────────────────────────────────
  bool _isValidUrl(String url) {
    return url.trim().startsWith('http://') ||
        url.trim().startsWith('https://');
  }

  // ── Simpan & Kirim ────────────────────────────────────────────
  void _onSimpan() {
    if (_booking == null) return;
    
    final link = _linkCtrl.text.trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Masukkan link meeting terlebih dahulu'),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ));
      return;
    }
    if (!_isValidUrl(link)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Link tidak valid, harus diawali http:// atau https://'),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ));
      return;
    }

    // Call Cubit
    context.read<BookingConfirmationCubit>().confirmBooking(
      scheduleId: _booking!.id, 
      decision: 'accept',
      urlMeeting: link,
    );
  }

  Future<void> _openWA(String number) async {
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
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
    if (_booking == null) {
      return const Scaffold(body: Center(child: Text('Data booking tidak ditemukan')));
    }

    final item = _booking!;
    final inisial = item.studentName.isNotEmpty ? item.studentName[0].toUpperCase() : '?';
    final tanggal = _formatLongDate(item.date);
    final jam = '${_formatTime(item.startTime)} - ${_formatTime(item.endTime)}';

    return BlocConsumer<BookingConfirmationCubit, BookingConfirmationState>(
      listener: (context, state) {
        if (state is BookingConfirmationSuccess) {
          setState(() {
            _bannerState = _BannerState.success;
          });
        } else if (state is BookingConfirmationError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ));
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingConfirmationLoading;

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
            title: const Text('Form Link Meeting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(children: [
              // Batal
              Expanded(child: SizedBox(height: 52, child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Batal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ))),
              const SizedBox(width: 12),
              // Simpan & Kirim / Kembali (jika sukses)
              Expanded(child: SizedBox(height: 52, child: ElevatedButton(
                onPressed: isLoading ? null : (_bannerState == _BannerState.success ? () => Navigator.pop(context) : _onSimpan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text(_bannerState == _BannerState.success ? 'Kembali' : 'Simpan & Kirim',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ))),
            ]),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 4),

              // ── Subjudul ─────────────────────────────────────────
              const Text(
                'Masukkan link meeting yang akan digunakan untuk sesi online dengan siswa',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 16),

              // ── Kartu ringkasan sesi ──────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                ),
                child: Column(children: [
                  Row(children: [
                    // Avatar
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
                      Text('${item.subjectName} · $tanggal',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ])),
                    // Badge Online
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.successGreen.withOpacity(0.3)),
                      ),
                      child: const Text('Online',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                              color: AppColors.successGreen)),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 5),
                    Text(jam, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                    const SizedBox(width: 10),
                    // WA badge
                    if (item.studentTelephoneNumber != null && item.studentTelephoneNumber!.isNotEmpty)
                      GestureDetector(
                        onTap: () => _openWA(item.studentTelephoneNumber!),
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
                ]),
              ),

              const SizedBox(height: 24),

              // ── Judul input ───────────────────────────────────────
              const Text('Masukan Link Meeting',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Link ini akan dikirim ke siswa untuk sesi online.\nGunakan Google Meet, Zoom, atau platform lainnya.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 12),

              // ── Input field ───────────────────────────────────────
              TextField(
                controller: _linkCtrl,
                enabled: _bannerState != _BannerState.success && !isLoading,
                onChanged: (_) {
                  // Kembali ke banner info saat user mengedit lagi
                  if (_bannerState == _BannerState.success) {
                    setState(() => _bannerState = _BannerState.info);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Masukkan link meeting untuk sesi online dengan siswa.',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.videocam_outlined,
                      color: AppColors.textSecondary, size: 20),
                  filled: true, fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Banner info / sukses (berubah setelah simpan) ─────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _bannerState == _BannerState.info
                    // Banner kuning — info (Image 3)
                    ? Container(
                        key: const ValueKey('info'),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFE082)),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.warningYellow, size: 18),
                          const SizedBox(width: 10),
                          const Expanded(child: Text(
                            'Pastikan link yang Anda masukkan valid dan dapat diakses oleh siswa pada waktu sesi berlangsung.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.4),
                          )),
                        ]),
                      )
                    // Banner hijau — sukses (Image 4)
                    : Container(
                        key: const ValueKey('success'),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.successGreen.withOpacity(0.3)),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: AppColors.successGreen, size: 18),
                          const SizedBox(width: 10),
                          const Expanded(child: Text(
                            'Link meeting berhasil dikirim ke siswa dan siap digunakan untuk sesi pembelajaran.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF1D6E3E), height: 1.4),
                          )),
                        ]),
                      ),
              ),

              const SizedBox(height: 80),
            ]),
          ),
        );
      },
    );
  }
}