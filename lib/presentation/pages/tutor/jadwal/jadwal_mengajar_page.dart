// lib/presentation/pages/tutor/jadwal/jadwal_mengajar_page.dart
// Jadwal Mengajar
// - Week picker dengan navigasi bulan
// - "Sesi Hari Ini" section
// - Kartu sesi per siswa:
//   * Offline: avatar, nama, mapel·tanggal, jam, WA, kotak alamat+Google Maps
//   * Online:  avatar, nama, mapel·tanggal, jam, WA, kotak Link Meeting (link teal)
// - Empty state: icon kalender + teks "Belum ada sesi mengajar hari ini"

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_buttom_nav.dart';
import 'package:url_launcher/url_launcher.dart';


class JadwalMengajarPage extends StatefulWidget {
  const JadwalMengajarPage({super.key});
  @override
  State<JadwalMengajarPage> createState() => _JadwalMengajarPageState();
}

class _JadwalMengajarPageState extends State<JadwalMengajarPage> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _weekStart;

  static const _hariSingkat = ['Sen','Sel','Rab','Kam','Jum','Sab','Min'];
  static const _bulanNama   = [
    '','Januari','Februari','Maret','April','Mei','Juni',
    'Juli','Agustus','September','Oktober','November','Desember',
  ];

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  @override
  void initState() {
    super.initState();
    // Hitung awal minggu (Senin) dari tanggal hari ini
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSchedules());
  }

  // ── API Call ─────────────────────────────────────────────────────
  void _loadSchedules() {
    context.read<ScheduleCubit>().loadSchedules(
          status: 'active',
          date: _formatQueryDate(_selectedDate),
        );
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    _loadSchedules();
  }

  void _prevWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
    });
    _loadSchedules();
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
      _selectedDate = _selectedDate.add(const Duration(days: 7));
    });
    _loadSchedules();
  }

  // ── Helpers ─────────────────────────────────────────────────────
  String _formatQueryDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatLongDate(DateTime d) {
    const weekdays = ['Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu'];
    return '${weekdays[d.weekday - 1]}, ${d.day} ${_bulanNama[d.month]} ${d.year}';
  }

  // ── Actions ─────────────────────────────────────────────────────
  Future<void> _openWA(String number) async {
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TutorBottomNav(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/tutor/beranda');
          if (i == 2) Navigator.pushReplacementNamed(context, '/tutor/konfirmasi-booking');
          if (i == 3) Navigator.pushReplacementNamed(context, '/tutor/profil');
        },
      ),
      body: Column(children: [
        // ── Teal Header ─────────────────────────────────────────
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Jadwal Mengajar',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),

        // ── Body ─────────────────────────────────────────────────
        Expanded(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            _buildWeekPicker(),
            const SizedBox(height: 24),
            const Text('Sesi Hari Ini',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            _buildScheduleSection(),
            const SizedBox(height: 32),
          ]),
        )),
      ]),
    );
  }

  // ── Schedule Section (BlocBuilder) ───────────────────────────────
  Widget _buildScheduleSection() {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading || state is ScheduleInitial) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is ScheduleError) {
          return _buildErrorState(state.message);
        }

        if (state is ScheduleLoaded) {
          final schedules = state.data.data;
          if (schedules.isEmpty) {
            return _buildEmptyState();
          }
          return Column(
            children: schedules.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _SesiCard(
                schedule: s,
                onWA: () {
                  final number = s.studentTelephoneNumber;
                  if (number != null && number.isNotEmpty) _openWA(number);
                },
                onOpenLink: (url) => _openUrl(url),
                formatTime: _formatTime,
                formatLongDate: _formatLongDate,
              ),
            )).toList(),
          );
        }

        return const SizedBox();
      },
    );
  }

  // ── Week Picker ───────────────────────────────────────────────
  Widget _buildWeekPicker() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _prevWeek,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left_rounded,
                  color: AppColors.textPrimary),
            ),
          ),
          Text('${_bulanNama[_selectedDate.month]} ${_selectedDate.year}',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          GestureDetector(
            onTap: _nextWeek,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _weekDays.asMap().entries.map((e) {
          final day = e.value;
          final isSelected = day.day == _selectedDate.day &&
              day.month == _selectedDate.month &&
              day.year == _selectedDate.year;
          return GestureDetector(
            onTap: () => _onDateSelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44, height: 62,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.4),
                  width: isSelected ? 1.5 : 1.2,
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_hariSingkat[e.key],
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary)),
                const SizedBox(height: 3),
                Text('${day.day}',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textPrimary)),
              ]),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  // ── Empty state ───────────────────────────────────────────────
  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Center(child: Column(
          mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.calendar_month_rounded,
            size: 56, color: Colors.grey.shade300),
        const SizedBox(height: 14),
        Text('Belum ada sesi mengajar hari ini',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
      ])),
    );
  }

  // ── Error state ───────────────────────────────────────────────
  Widget _buildErrorState(String message) {
    return SizedBox(
      height: 300,
      child: Center(child: Column(
          mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.error_outline_rounded,
            size: 56, color: Colors.grey.shade300),
        const SizedBox(height: 14),
        Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _loadSchedules,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Coba Lagi'),
        ),
      ])),
    );
  }
}

// ── Kartu sesi (powered by ScheduleEntity) ────────────────────────
class _SesiCard extends StatelessWidget {
  final ScheduleEntity schedule;
  final VoidCallback? onWA;
  final void Function(String url) onOpenLink;
  final String Function(DateTime) formatTime;
  final String Function(DateTime) formatLongDate;

  const _SesiCard({
    required this.schedule,
    required this.onWA,
    required this.onOpenLink,
    required this.formatTime,
    required this.formatLongDate,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = schedule.learningMethod.toLowerCase() == 'online';
    final inisial = schedule.studentName.isNotEmpty
        ? schedule.studentName[0].toUpperCase()
        : '?';
    final jam = '${formatTime(schedule.startTime)} - ${formatTime(schedule.endTime)}';
    final tanggal = formatLongDate(schedule.date);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Row 1: Avatar + Info + Badge ────────────────────────
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(inisial,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.secondary)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(schedule.studentName,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text('${schedule.subjectName} · $tanggal',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ])),
          // Badge mode
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isOnline
                  ? AppColors.successGreen.withOpacity(0.1)
                  : AppColors.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOnline
                    ? AppColors.successGreen.withOpacity(0.3)
                    : AppColors.errorRed.withOpacity(0.3),
              ),
            ),
            child: Text(
              isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isOnline ? AppColors.successGreen : AppColors.errorRed),
            ),
          ),
        ]),

        const SizedBox(height: 12),

        // ── Row 2: Jam + WhatsApp ────────────────────────────────
        Row(children: [
          const Icon(Icons.access_time_rounded,
              size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(jam,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onWA,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.chat_rounded, size: 12, color: Colors.white),
                SizedBox(width: 4),
                Text('WhatsApp',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ]),
            ),
          ),
        ]),

        const SizedBox(height: 10),

        // ── Kotak Info (Alamat atau Link Meeting) ─────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: isOnline
              ? _buildOnlineInfo()
              : _buildOfflineInfo(),
        ),

        const SizedBox(height: 10),

        // ── Tombol Batalkan Sesi ──────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(
              context,
              '/tutor/jadwal/batalkan',
              arguments: {'schedule_id': schedule.id},
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.errorRed,
              side: BorderSide(color: AppColors.errorRed.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.cancel_outlined, size: 16),
            label: const Text('Batalkan Sesi',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }

  Widget _buildOnlineInfo() {
    final link = schedule.address; // "Google Meet" or actual link
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [
        Icon(Icons.videocam_outlined,
            size: 15, color: AppColors.textSecondary),
        SizedBox(width: 6),
        Text('Link Meeting',
            style: TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
      ]),
      const SizedBox(height: 4),
      GestureDetector(
        onTap: () {
          if (link.startsWith('http')) {
            onOpenLink(link);
          }
        },
        child: Text(link,
            style: const TextStyle(
                fontSize: 12, color: AppColors.primary,
                fontWeight: FontWeight.w500)),
      ),
    ]);
  }

  Widget _buildOfflineInfo() {
    final alamat = schedule.address;
    final mapsLink = 'https://maps.google.com/?q=${Uri.encodeComponent(alamat)}';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.location_on_outlined,
            size: 16, color: AppColors.textSecondary),
        SizedBox(width: 6),
        Text('Alamat Lokasi sesi',
            style: TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
      ]),
      const SizedBox(height: 4),
      Text(alamat,
          style: const TextStyle(
              fontSize: 12, color: AppColors.textPrimary,
              height: 1.4)),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: () => onOpenLink(mapsLink),
        child: const Row(children: [
          Icon(Icons.open_in_new_rounded,
              size: 13, color: AppColors.primary),
          SizedBox(width: 4),
          Text('Buka di Google Maps',
              style: TextStyle(
                  fontSize: 12, color: AppColors.primary,
                  fontWeight: FontWeight.w500)),
        ]),
      ),
    ]);
  }
}