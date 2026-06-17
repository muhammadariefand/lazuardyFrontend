// lib/presentation/pages/orangtua/jadwal_orangtua_page.dart
// Image 2: Jadwal Saya
// - AppBar teal "Jadwal Saya"
// - Navigasi bulan (< April >)
// - Row 7 hari (Sen 30 … Min 5), satu aktif teal
// - Label "Sesi Hari Ini"
// - List card sesi: avatar + nama tutor (teal) + mapel + badge mode
//   + WhatsApp + jam + tanggal + icon edit (pensil)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_bottom_nav.dart';
import 'detail_sesi_orangtua_page.dart';


// ── Model ─────────────────────────────────────────────────────────
class SesiJadwalData {
  final String inisial;
  final String namaTutor;
  final String mapel;
  final bool isOnline;
  final String nomorWa;
  final String jamMulai;
  final String jamSelesai;
  final String tanggal;
  final String tanggalLengkap;
  final String? linkMeeting;
  final String? alamat;
  final String status;

  const SesiJadwalData({
    required this.inisial,
    required this.namaTutor,
    required this.mapel,
    required this.isOnline,
    required this.nomorWa,
    required this.jamMulai,
    required this.jamSelesai,
    required this.tanggal,
    required this.tanggalLengkap,
    this.linkMeeting,
    this.alamat,
    required this.status,
  });

  factory SesiJadwalData.fromEntity(ScheduleEntity entity) {
    final isOnline = entity.learningMethod.toLowerCase() == 'online';
    return SesiJadwalData(
      inisial: entity.tutorName.isNotEmpty ? entity.tutorName[0].toUpperCase() : '?',
      namaTutor: entity.tutorName,
      mapel: entity.subjectName,
      isOnline: isOnline,
      nomorWa: entity.studentTelephoneNumber?.isNotEmpty == true
          ? entity.studentTelephoneNumber!
          : (entity.tutorTelephoneNumber ?? '-'),
      jamMulai: _formatTime(entity.startTime),
      jamSelesai: _formatTime(entity.endTime),
      tanggal: _formatLongDate(entity.date),
      tanggalLengkap: _formatShortDate(entity.date),
      linkMeeting: isOnline ? entity.address : null,
      alamat: isOnline ? null : entity.address,
      status: entity.status.isNotEmpty ? entity.status : 'Terjadwal',
    );
  }
}

String _formatQueryDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

String _formatLongDate(DateTime date) {
  const weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  return '${weekdays[date.weekday - 1]}, ${date.day} ${_monthName(date.month)} ${date.year}';
}

String _formatShortDate(DateTime date) {
  return '${date.day} ${_monthName(date.month)} ${date.year}';
}

String _monthName(int month) {
  const names = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return names[month - 1];
}

// ── Page ──────────────────────────────────────────────────────────
class JadwalOrangtuaPage extends StatefulWidget {
  const JadwalOrangtuaPage({super.key});

  @override
  State<JadwalOrangtuaPage> createState() => _JadwalOrangtuaPageState();
}

class _JadwalOrangtuaPageState extends State<JadwalOrangtuaPage> {
  late DateTime _currentWeekStart;
  int _selectedDayIdx = 0;
  late List<DateTime> _hariList;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Cari hari Senin dari minggu ini (weekday 1 = Senin)
    int daysFromMonday = now.weekday - 1;
    _currentWeekStart = now.subtract(Duration(days: daysFromMonday));
    _selectedDayIdx = daysFromMonday; // Hari ini yang terpilih by default
    _generateHariList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSchedule();
    });
  }

  void _generateHariList() {
    _hariList = List.generate(7, (index) => _currentWeekStart.add(Duration(days: index)));
  }

  void _fetchSchedule() {
    context.read<ScheduleCubit>().loadSchedules(
          status: 'active',
          date: _formatQueryDate(_selectedDate),
        );
  }

  DateTime get _selectedDate => _hariList[_selectedDayIdx];
  String get _bulan => _monthName(_selectedDate.month);
  String get _tahun => _selectedDate.year.toString();

  void _onSelectedDay(int index) {
    setState(() {
      _selectedDayIdx = index;
    });
    _fetchSchedule();
  }

  Widget _buildScheduleSection() {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading || state is ScheduleInitial) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ScheduleError) {
          return Column(
            children: [
              Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => context.read<ScheduleCubit>().loadSchedules(
                      status: 'active',
                      date: _formatQueryDate(_selectedDate),
                    ),
                child: const Text('Coba Lagi'),
              ),
            ],
          );
        }

        if (state is ScheduleLoaded) {
          final schedules = state.data.data
              .map((entity) => SesiJadwalData.fromEntity(entity))
              .toList();

          if (schedules.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      size: 80,
                      color: Color(0xFFE0E0E0),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada jadwal hari ini',
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

          return Column(
            children: schedules
                .map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildSesiCard(s),
                    ))
                .toList(),
          );
        }

        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: OrangTuaBottomNav(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/orang-tua/beranda');
          if (i == 2) Navigator.pushReplacementNamed(context, '/orang-tua/laporan-anak');
          if (i == 3) Navigator.pushReplacementNamed(context, '/orang-tua/profil-anak');
        },
      ),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildBulanNavigator(),
                  const SizedBox(height: 16),
                  _buildDaySelector(),
                  const SizedBox(height: 20),
                  const Text(
                    'Sesi Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildScheduleSection(),
                ],
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
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Jadwal Saya',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── Navigasi Bulan ────────────────────────────────────────────
  Widget _buildBulanNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _navBtn(Icons.chevron_left_rounded, () {
          setState(() {
            _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
            _generateHariList();
          });
          _fetchSchedule();
        }),
        Text(
          '$_bulan $_tahun',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        _navBtn(Icons.chevron_right_rounded, () {
          setState(() {
            _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
            _generateHariList();
          });
          _fetchSchedule();
        }),
      ],
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }

  // ── Day Selector ──────────────────────────────────────────────
  Widget _buildDaySelector() {
    const labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_hariList.length, (i) {
        final date = _hariList[i];
        final isSelected = _selectedDayIdx == i;
        return GestureDetector(
          onTap: () => _onSelectedDay(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: (MediaQuery.of(context).size.width - 32 - 42) / 7,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFCCCCCC),
              ),
            ),
            child: Column(
              children: [
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Card Sesi ─────────────────────────────────────────────────
  Widget _buildSesiCard(SesiJadwalData s) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailSesiOrangtuaPage(sesi: s),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                _buildAvatar(s.inisial),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.namaTutor,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(s.mapel,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildModeBadge(s.isOnline),
                          const SizedBox(width: 8),
                          _buildWhatsAppButton(s.nomorWa),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(s.status),
              ],
            ),
            const SizedBox(height: 12),
            // Jam + Tanggal + Edit
            Row(
              children: [
                const Icon(Icons.schedule_rounded,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${s.jamMulai} - ${s.jamSelesai}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(width: 12),
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(s.tanggal,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textPrimary)),
                const Spacer(),
                const Icon(Icons.edit_outlined,
                    size: 18, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared Widgets ────────────────────────────────────────────
  Widget _buildAvatar(String inisial) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          inisial,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3949AB),
          ),
        ),
      ),
    );
  }

  Widget _buildModeBadge(bool isOnline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOnline
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOnline ? 'Online' : 'Offline',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isOnline
              ? const Color(0xFF2E7D32)
              : const Color(0xFFC62828),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF57C00),
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(String nomor) {
    return GestureDetector(
      onTap: () {/* TODO: launch WA */},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.successGreen,
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
    );
  }
}