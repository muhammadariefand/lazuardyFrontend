// lib/presentation/pages/siswa/jadwal_siswa_page.dart
// Halaman Jadwal — Week picker + kartu sesi hari ini

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/siswa_bottom_nav.dart';

const _teal = Color(0xFF3AAFA9);

class JadwalSiswaPage extends StatefulWidget {
  const JadwalSiswaPage({super.key});
  @override
  State<JadwalSiswaPage> createState() => _JadwalSiswaPageState();
}

class _JadwalSiswaPageState extends State<JadwalSiswaPage> {
  DateTime _selectedDate = DateTime(2026, 3, 29);
  DateTime _weekStart = DateTime(2026, 3, 23);

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  static const _hariSingkat = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  void _prevWeek() => setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));
  void _nextWeek() => setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));

  static const _bulanNama = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

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
        // Teal header
        Container(
          color: _teal,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(alignment: Alignment.centerLeft,
            child: Text('Jadwal Saya', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white))),
        ),

        Expanded(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),

              // Month + prev/next
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(onTap: _prevWeek,
                  child: Container(width: 40, height: 40, decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary))),
                Text(_bulanNama[_selectedDate.month],
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                GestureDetector(onTap: _nextWeek,
                  child: Container(width: 40, height: 40, decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary))),
              ]),

              const SizedBox(height: 16),

              // Week day selector
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _weekDays.asMap().entries.map((e) {
                  final day = e.value;
                  final isSelected = day.day == _selectedDate.day &&
                      day.month == _selectedDate.month;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = day),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 44, height: 62,
                      decoration: BoxDecoration(
                        color: isSelected ? _teal : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? _teal : Colors.grey.shade300, width: 1.2),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(_hariSingkat[e.key], style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('${day.day}', style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : AppColors.textPrimary)),
                      ]),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              const Text('Sesi Hari Ini',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 12),

              // Kartu sesi
              _buildSesiCard(),

              const SizedBox(height: 32),
            ]),
          ),
        )),
      ]),
    );
  }

  Widget _buildSesiCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/siswa/detail-sesi'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _teal.withOpacity(0.4), width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(children: [
          Row(children: [
            // Avatar
            Container(width: 56, height: 56, decoration: BoxDecoration(
              color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Text('S', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.grey.shade500))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Ibu Sarah', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _teal)),
              const Text('Matematika', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                _badge('Offline', const Color(0xFFFFEBEE), const Color(0xFFE53E3E)),
                const SizedBox(width: 8),
                _whatsappBadge(),
              ]),
            ])),
            // Status badge
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(20)),
              child: const Text('Terjadwal', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B)))),
          ]),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.access_time_rounded, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            const Text('14:00 - 15:00', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
            const SizedBox(width: 16),
            const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            const Text('Minggu, 29 Maret 2026', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
            const Spacer(),
            const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
          ]),
        ]),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color textColor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)));

  Widget _whatsappBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(20)),
    child: const Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.chat_rounded, size: 12, color: Colors.white),
      SizedBox(width: 4),
      Text('WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
    ]));
}