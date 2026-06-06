// lib/presentation/pages/siswa/jadwal_siswa_page.dart
// Halaman Jadwal — Week picker + kartu sesi hari ini

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/schedule_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/siswa_bottom_nav.dart';

const _teal = Color(0xFF3AAFA9);

class JadwalSiswaPage extends StatefulWidget {
  const JadwalSiswaPage({super.key});

  @override
  State<JadwalSiswaPage> createState() => _JadwalSiswaPageState();
}

class _JadwalSiswaPageState extends State<JadwalSiswaPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _weekStart = DateTime.now().subtract(const Duration(days: 3));

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  static const _hariSingkat = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

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

  static const _bulanNama = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSchedules());
  }

  void _loadSchedules() {
    context.read<ScheduleCubit>().loadSchedules(
          status: '',
          date: _formatQueryDate(_selectedDate),
        );
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SiswaBottomNav(currentIndex: 1, onTap: (i) {
        if (i == 0) Navigator.pushReplacementNamed(context, '/siswa/beranda');
        if (i == 2) Navigator.pushReplacementNamed(context, '/siswa/laporan');
        if (i == 3) Navigator.pushReplacementNamed(context, '/siswa/profil');
      }),
      body: Column(children: [
        Container(
          color: _teal,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Jadwal Saya', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _prevWeek,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary),
                        ),
                      ),
                      Text(
                        '${_bulanNama[_selectedDate.month]} ${_selectedDate.year}',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      GestureDetector(
                        onTap: _nextWeek,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                          width: 44,
                          height: 62,
                          decoration: BoxDecoration(
                            color: isSelected ? _teal : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? _teal : Colors.grey.shade300, width: 1.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _hariSingkat[e.key],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sesi Hari Ini',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  _buildScheduleSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
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
                onPressed: _loadSchedules,
                child: const Text('Coba Lagi'),
              ),
            ],
          );
        }

        if (state is ScheduleLoaded) {
          final schedules = state.data.data;
          if (schedules.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('Tidak ada jadwal aktif untuk tanggal ini.', style: TextStyle(color: AppColors.textSecondary)),
            );
          }

          return Column(
            children: schedules.map(_buildSesiCard).toList(),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildSesiCard(ScheduleEntity schedule) {
    final isOnline = schedule.learningMethod.toLowerCase() == 'online';
    final contact = schedule.studentTelephoneNumber?.isNotEmpty == true
        ? schedule.studentTelephoneNumber!
        : (schedule.tutorTelephoneNumber ?? '-');
    final displayName = schedule.tutorName.isNotEmpty ? schedule.tutorName : 'Tutor';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/siswa/detail-sesi'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _teal.withOpacity(0.4), width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    displayName[0].toUpperCase(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.grey.shade500),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _teal)),
                      Text(schedule.subjectName, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _badge(
                            isOnline ? 'Online' : 'Offline',
                            isOnline ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                            isOnline ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                          ),
                          const SizedBox(width: 8),
                          _whatsappBadge(contact),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(20)),
                  child: Text(schedule.status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B))),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(_formatLongDate(schedule.date), style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                const Spacer(),
                const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color textColor) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
      );

  Widget _whatsappBadge(String nomor) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.chat_rounded, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(nomor.isNotEmpty ? 'WhatsApp' : '-', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
        ]),
      );

  String _formatQueryDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatLongDate(DateTime date) {
    const weekdays = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${_bulanNama[date.month]} ${date.year}';
  }
}
