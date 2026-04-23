// lib/presentation/pages/siswa/booking/pilih_jadwal_page.dart
// \Pilih Jadwal — deskripsi, metode toggle (Online/Offline),
// week picker, time chips, + field alamat & maps jika Offline

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _starYellow = Color(0xFFFFB800);

class PilihJadwalPage extends StatefulWidget {
  const PilihJadwalPage({super.key});
  @override
  State<PilihJadwalPage> createState() => _PilihJadwalPageState();
}

class _PilihJadwalPageState extends State<PilihJadwalPage> {
  // Metode: 'online' or 'offline'
  String _selectedMetode = 'online';

  // Tanggal dipilih
  DateTime _selectedDate = DateTime(2026, 4, 1);
  DateTime _weekStart = DateTime(2026, 3, 30);

  // Jam dipilih
  String? _selectedJam;

  // Controllers untuk Offline
  final _alamatCtrl = TextEditingController();
  final _mapsCtrl = TextEditingController();

  static const _hariSingkat = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const _bulanNama = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  // Jam tersedia tutor — slot abu = tidak tersedia
  static const _jamList = [
    ('08:00', true),  ('09:00', false), ('10:00', true),
    ('11:00', true),  ('12:00', true),  ('13:00', true),
    ('14:00', true),  ('15:00', true),  ('16:00', false),
    ('17:00', true),  ('18:00', true),  ('19:00', true),
    ('20:00', true),  ('21:00', false),
  ];

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  @override
  void dispose() {
    _alamatCtrl.dispose();
    _mapsCtrl.dispose();
    super.dispose();
  }

  bool get _isValid {
    if (_selectedJam == null) return false;
    if (_selectedMetode == 'offline' &&
        (_alamatCtrl.text.trim().isEmpty || _mapsCtrl.text.trim().isEmpty)) {
      return false;
    }
    return true;
  }

  void _onLanjutKonfirmasi() {
    if (!_isValid) {
      String msg = _selectedJam == null
          ? 'Pilih jam terlebih dahulu'
          : 'Lengkapi alamat dan link maps untuk sesi offline';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ));
      return;
    }
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    Navigator.pushNamed(context, '/siswa/booking/konfirmasi', arguments: {
      ...args,
      'metode': _selectedMetode,
      'hari': _formatHari(_selectedDate),
      'jam': '$_selectedJam - ${_nextHour(_selectedJam!)}',
      'alamat': _alamatCtrl.text,
      'maps': _mapsCtrl.text,
    });
  }

  String _formatHari(DateTime d) {
    const hari = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return '${hari[d.weekday]}, ${d.day} ${_bulanNama[d.month]}';
  }

  String _nextHour(String jam) {
    final parts = jam.split(':');
    final h = int.parse(parts[0]) + 1;
    return '${h.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    final tutorNama = args['tutor_nama'] as String? ?? 'Ibu Sarah';
    final tutorMapel = args['tutor_mapel'] as String? ?? 'Matematika';
    final tutorRating = (args['tutor_rating'] as num?)?.toDouble() ?? 4.9;
    final tutorUlasan = args['tutor_ulasan'] as int? ?? 127;
    final tutorInisial = args['tutor_inisial'] as String? ?? 'S';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Pilih Jadwal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _onLanjutKonfirmasi,
            style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text('Lanjut Konfirmasi',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),

          // ── Kartu tutor ─────────────────────────────────────
          _buildTutorCard(tutorNama, tutorMapel, tutorRating, tutorUlasan, tutorInisial),
          const SizedBox(height: 20),

          // ── Deskripsi Tutor ──────────────────────────────────
          const Text('Deskripsi Tutor',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          _buildDeskripsiBox(),
          const SizedBox(height: 20),

          // ── Metode Pembelajaran ──────────────────────────────
          const Text('Metode Pembelajaran',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          _buildMetodeToggle(),
          const SizedBox(height: 20),

          // ── Pilih Hari ───────────────────────────────────────
          const Text('Pilih Hari',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          _buildWeekPicker(),
          const SizedBox(height: 20),

          // ── Pilih Jam ────────────────────────────────────────
          const Text('Pilih Jam',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          _buildTimeChips(),
          const SizedBox(height: 20),

          // ── Alamat & Maps (hanya Offline) ────────────────────
          if (_selectedMetode == 'offline') ...[
            const Text('Alamat Lokasi Sesi',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _alamatCtrl,
              maxLines: 3,
              onChanged: (_) => setState(() {}),
              decoration: _inputDeco('Masukkan Alamat Lengkap untuk sesi offline...'),
            ),
            const SizedBox(height: 16),
            const Text('Link Maps',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _mapsCtrl,
              onChanged: (_) => setState(() {}),
              decoration: _inputDeco('Masukkan link maps alamat lokasi sesi offline.'),
            ),
            const SizedBox(height: 20),
          ],
        ]),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
    filled: true, fillColor: Colors.white,
    contentPadding: const EdgeInsets.all(14),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _teal, width: 1.5)),
  );

  Widget _buildTutorCard(String nama, String mapel, double rating, int ulasan, String inisial) =>
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(children: [
        Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center, child: Text(inisial, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1E2D7D)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(mapel, style: const TextStyle(fontSize: 12, color: _teal, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star_rounded, color: _starYellow, size: 14),
            const SizedBox(width: 3),
            Text('$rating  ($ulasan ulasan)', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(20)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.chat_rounded, size: 13, color: Colors.white),
            SizedBox(width: 5),
            Text('WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ])),
      ]),
    );

  Widget _buildDeskripsiBox() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200)),
    child: const Text(
      'Tutor matematika berpengalaman yang siap membantu siswa memahami materi dengan cara yang lebih mudah, jelas, dan menyenangkan. Memiliki pengalaman mengajar berbagai tingkat (SD, SMP, hingga SMA) dengan pendekatan yang sabar dan interaktif, sehingga siswa tidak hanya menghafal rumus, tetapi benar-benar memahami konsepnya.\n\n'
      'Dalam setiap sesi, pembelajaran disesuaikan dengan kebutuhan dan kemampuan siswa. Materi dijelaskan secara bertahap, dilengkapi dengan latihan soal, pembahasan yang detail, serta tips dan trik agar lebih cepat mengerjakan soal. Tutor juga fokus membantu meningkatkan kepercayaan diri siswa dalam menghadapi ujian.\n\n'
      'Banyak siswa yang mengalami peningkatan nilai setelah belajar secara rutin. Cocok untuk kamu yang ingin memperbaiki nilai, mengejar ketertinggalan, atau mempersiapkan diri menghadapi ujian dengan lebih siap dan percaya diri.',
      style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.6),
    ),
  );

  Widget _buildMetodeToggle() => Row(children: [
    Expanded(child: GestureDetector(
      onTap: () => setState(() { _selectedMetode = 'online'; }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        decoration: BoxDecoration(
          color: _selectedMetode == 'online' ? _teal : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _teal.withOpacity(0.4)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.videocam_outlined, color: _selectedMetode == 'online' ? Colors.white : AppColors.textSecondary, size: 18),
          const SizedBox(width: 6),
          Text('Online', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
              color: _selectedMetode == 'online' ? Colors.white : AppColors.textSecondary)),
        ]),
      ),
    )),
    const SizedBox(width: 12),
    Expanded(child: GestureDetector(
      onTap: () => setState(() { _selectedMetode = 'offline'; }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        decoration: BoxDecoration(
          color: _selectedMetode == 'offline' ? _teal : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _teal.withOpacity(0.4)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.location_on_outlined, color: _selectedMetode == 'offline' ? Colors.white : AppColors.textSecondary, size: 18),
          const SizedBox(width: 6),
          Text('Offline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
              color: _selectedMetode == 'offline' ? Colors.white : AppColors.textSecondary)),
        ]),
      ),
    )),
  ]);

  Widget _buildWeekPicker() => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
        onTap: () => setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7))),
        child: Container(width: 36, height: 36, decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary))),
      Text(_bulanNama[_selectedDate.month],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      GestureDetector(
        onTap: () => setState(() => _weekStart = _weekStart.add(const Duration(days: 7))),
        child: Container(width: 36, height: 36, decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary))),
    ]),
    const SizedBox(height: 12),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDays.asMap().entries.map((e) {
        final day = e.value;
        final isSelected = day.day == _selectedDate.day && day.month == _selectedDate.month;
        return GestureDetector(
          onTap: () => setState(() { _selectedDate = day; _selectedJam = null; }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42, height: 60,
            decoration: BoxDecoration(
              color: isSelected ? _teal : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSelected ? _teal : _teal.withOpacity(0.4), width: isSelected ? 1.5 : 1.2),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(_hariSingkat[e.key], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary)),
              const SizedBox(height: 3),
              Text('${day.day}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary)),
            ]),
          ),
        );
      }).toList()),
  ]);

  Widget _buildTimeChips() => Wrap(
    spacing: 10, runSpacing: 10,
    children: _jamList.map((jam) {
      final isAvailable = jam.$2;
      final isSelected = _selectedJam == jam.$1;
      return GestureDetector(
        onTap: isAvailable ? () => setState(() => _selectedJam = jam.$1) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? _teal : (isAvailable ? Colors.white : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? _teal : (isAvailable ? _teal.withOpacity(0.4) : Colors.grey.shade300),
              width: isSelected ? 1.5 : 1.2,
            ),
          ),
          child: Text(jam.$1, style: TextStyle(
            fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : (isAvailable ? AppColors.textPrimary : Colors.grey.shade400))),
        ),
      );
    }).toList(),
  );
}