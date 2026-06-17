// lib/presentation/pages/siswa/booking/pilih_jadwal_page.dart
// Pilih Jadwal — deskripsi, metode toggle (Online/Offline),
// week picker, time chips, + field alamat & maps jika Offline

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import '../../../../domain/entities/tutor_entity.dart';
import '../../../../domain/entities/tutor_availability_entity.dart';
import '../../../state_management/student_booking/booking_flow_cubit.dart';
import '../../../state_management/student_booking/booking_flow_state.dart';


class PilihJadwalPage extends StatefulWidget {
  const PilihJadwalPage({super.key});
  @override
  State<PilihJadwalPage> createState() => _PilihJadwalPageState();
}

class _PilihJadwalPageState extends State<PilihJadwalPage> {
  // Metode: 'online' or 'offline'
  String _selectedMetode = 'online';

  // Tanggal dipilih
  late DateTime _selectedDate;
  late DateTime _weekStart;

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
  
  static const _englishDays = ['', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

  Map? args;
  int? tutorId;

  TutorEntity? tutorDetail;
  List<TutorAvailabilityEntity> tutorSchedules = [];

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  @override
  void initState() {
    super.initState();
    // Inisialisasi minggu ini
    final now = DateTime.now();
    _selectedDate = now;
    // Set weekStart ke hari Senin minggu ini
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (args == null) {
      args = ModalRoute.of(context)?.settings.arguments as Map?;
      tutorId = args?['tutor_id'] as int?;
      
      if (tutorId != null) {
        context.read<BookingFlowCubit>().fetchTutorDetail(tutorId!);
        _fetchSchedulesForDay(_selectedDate);
      }
    }
  }

  void _fetchSchedulesForDay(DateTime date) {
    if (tutorId != null) {
      context.read<BookingFlowCubit>().fetchTutorSchedules(tutorId!, _englishDays[date.weekday]);
    }
  }

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
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ));
      return;
    }
    
    // Format tanggal: YYYY-MM-DD
    final formattedDate = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    
    // Format jam: pastikan HH:MM:SS
    final selectedTimeParts = _selectedJam!.split(':');
    final formattedTime = '${selectedTimeParts[0]}:${selectedTimeParts[1]}:00';
    
    Navigator.pushNamed(context, '/siswa/booking/konfirmasi', arguments: {
      ...?args,
      'metode': _selectedMetode,
      'hari': _formatHariUI(_selectedDate),
      'date': formattedDate,
      'time': formattedTime,
      'jam': '$_selectedJam - ${_nextHour(_selectedJam!)}',
      'alamat': _alamatCtrl.text,
      'maps': _mapsCtrl.text,
      'tutor_nama': tutorDetail?.name ?? args?['tutor_nama'],
      'tutor_mapel': args?['tutor_mapel'],
      'tutor_rating': tutorDetail?.avgRate ?? args?['tutor_rating'] ?? 0.0,
      'tutor_photo': tutorDetail?.profilePhotoUrl ?? args?['tutor_photo'],
    });
  }

  String _formatHariUI(DateTime d) {
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
    final tutorNamaArg = args?['tutor_nama'] as String? ?? 'Loading...';
    final tutorMapelArg = args?['tutor_mapel'] as String? ?? 'Mapel';
    final tutorRatingArg = (args?['tutor_rating'] as num?)?.toDouble() ?? 0.0;
    final tutorUlasanArg = args?['tutor_ulasan'] as int? ?? 0;
    final tutorInisialArg = args?['tutor_inisial'] as String? ?? 'T';
    
    return BlocConsumer<BookingFlowCubit, BookingFlowState>(
      listener: (context, state) {
        if (state is BookingFlowError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ));
        } else if (state is TutorDetailLoaded) {
          setState(() { tutorDetail = state.tutor; });
        } else if (state is TutorSchedulesLoaded) {
          setState(() { tutorSchedules = state.schedules; });
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingFlowLoading;
        
        final displayNama = tutorDetail?.name ?? tutorNamaArg;
        final displayRating = tutorDetail?.avgRate ?? tutorRatingArg;
        final displayInisial = displayNama.isNotEmpty ? displayNama[0].toUpperCase() : 'T';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
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
                onPressed: isLoading ? null : _onLanjutKonfirmasi,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
              _buildTutorCard(
                displayNama, 
                tutorMapelArg, 
                displayRating, 
                tutorUlasanArg, 
                displayInisial,
                tutorDetail?.profilePhotoUrl ?? args?['tutor_photo']
              ),
              const SizedBox(height: 20),

              // ── Deskripsi Tutor ──────────────────────────────────
              const Text('Deskripsi Tutor',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              _buildDeskripsiBox(isLoading),
              const SizedBox(height: 20),

              // ── Metode Pembelajaran ──────────────────────────────
              const Text('Metode Pembelajaran',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              _buildMetodeToggle(isLoading),
              const SizedBox(height: 20),

              // ── Pilih Hari ───────────────────────────────────────
              const Text('Pilih Hari',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              _buildWeekPicker(),
              const SizedBox(height: 20),

              // ── Pilih Jam ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pilih Jam',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  if (isLoading) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                ],
              ),
              const SizedBox(height: 10),
              _buildTimeChips(isLoading),
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
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
  );

  Widget _buildTutorCard(String nama, String mapel, double rating, int ulasan, String inisial, String? photoUrl) =>
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(children: [
        Container(
          width: 56, height: 56, 
          decoration: BoxDecoration(
            color: Colors.grey.shade200, 
            borderRadius: BorderRadius.circular(10),
            image: photoUrl != null && photoUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(photoUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          alignment: Alignment.center, 
          child: (photoUrl == null || photoUrl.isEmpty) 
            ? Text(inisial, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.secondary))
            : null
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(mapel, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star_rounded, color: AppColors.warningYellow, size: 14),
            const SizedBox(width: 3),
            Text('$rating', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: AppColors.successGreen, borderRadius: BorderRadius.circular(20)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.chat_rounded, size: 13, color: Colors.white),
            SizedBox(width: 5),
            Text('WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ])),
      ]),
    );

  Widget _buildDeskripsiBox(bool isLoading) {
    if (isLoading && tutorDetail == null) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200)),
        child: const CircularProgressIndicator(color: AppColors.primary),
      );
    }
    
    final desc = tutorDetail?.description;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200)),
      child: Text(
        desc != null && desc.isNotEmpty ? desc : 'Belum ada deskripsi profil.',
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.6),
      ),
    );
  }

  Widget _buildMetodeToggle(bool isLoading) {
    bool hasOnline = true;
    bool hasOffline = true;
    
    if (tutorDetail != null) {
      hasOnline = tutorDetail!.learningMethods.any((element) => element.toLowerCase() == 'online');
      hasOffline = tutorDetail!.learningMethods.any((element) => element.toLowerCase() == 'offline');
      
      // Auto select available method if current one is not supported
      if (_selectedMetode == 'online' && !hasOnline && hasOffline) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedMetode = 'offline');
        });
      } else if (_selectedMetode == 'offline' && !hasOffline && hasOnline) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedMetode = 'online');
        });
      }
    }
    
    return Row(children: [
      if (hasOnline) Expanded(child: GestureDetector(
        onTap: () => setState(() { _selectedMetode = 'online'; }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          decoration: BoxDecoration(
            color: _selectedMetode == 'online' ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.videocam_outlined, color: _selectedMetode == 'online' ? Colors.white : AppColors.textSecondary, size: 18),
            const SizedBox(width: 6),
            Text('Online', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                color: _selectedMetode == 'online' ? Colors.white : AppColors.textSecondary)),
          ]),
        ),
      )),
      if (hasOnline && hasOffline) const SizedBox(width: 12),
      if (hasOffline) Expanded(child: GestureDetector(
        onTap: () => setState(() { _selectedMetode = 'offline'; }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          decoration: BoxDecoration(
            color: _selectedMetode == 'offline' ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
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
  }

  Widget _buildWeekPicker() => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
        onTap: () {
          setState(() {
            _weekStart = _weekStart.subtract(const Duration(days: 7));
          });
        },
        child: Container(width: 36, height: 36, decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary))),
      Text('${_bulanNama[_selectedDate.month]} ${_selectedDate.year}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      GestureDetector(
        onTap: () {
          setState(() {
            _weekStart = _weekStart.add(const Duration(days: 7));
          });
        },
        child: Container(width: 36, height: 36, decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary))),
    ]),
    const SizedBox(height: 12),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDays.asMap().entries.map((e) {
        final day = e.value;
        final isSelected = day.day == _selectedDate.day && day.month == _selectedDate.month && day.year == _selectedDate.year;
        
        // Cek apakah tanggal di masa lalu
        final isPast = day.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
        
        return GestureDetector(
          onTap: isPast ? null : () {
            setState(() { 
              _selectedDate = day; 
              _selectedJam = null; 
            });
            _fetchSchedulesForDay(day);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42, height: 60,
            decoration: BoxDecoration(
              color: isPast ? Colors.grey.shade100 : (isSelected ? AppColors.primary : Colors.white),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isPast ? Colors.grey.shade200 : (isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.4)), width: isSelected ? 1.5 : 1.2),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(_hariSingkat[e.key], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
                  color: isPast ? Colors.grey.shade400 : (isSelected ? Colors.white : AppColors.textSecondary))),
              const SizedBox(height: 3),
              Text('${day.day}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                  color: isPast ? Colors.grey.shade400 : (isSelected ? Colors.white : AppColors.textPrimary))),
            ]),
          ),
        );
      }).toList()),
  ]);

  Widget _buildTimeChips(bool isLoading) {
    if (tutorSchedules.isEmpty && !isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Tutor tidak memiliki jadwal tersedia pada hari ini.', style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
      );
    }
    
    // Sort schedules by time
    final sortedSchedules = List<TutorAvailabilityEntity>.from(tutorSchedules)
      ..sort((a, b) => a.time.compareTo(b.time));
      
    // Format time: "08:00:00" -> "08:00"
    return Wrap(
      spacing: 10, runSpacing: 10,
      children: sortedSchedules.map((schedule) {
        final timeParts = schedule.time.split(':');
        final formattedTime = '${timeParts[0]}:${timeParts[1]}';
        
        final isSelected = _selectedJam == formattedTime;
        
        return GestureDetector(
          onTap: () => setState(() => _selectedJam = formattedTime),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.4),
                width: isSelected ? 1.5 : 1.2,
              ),
            ),
            child: Text(formattedTime, style: TextStyle(
              fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : AppColors.textPrimary)),
          ),
        );
      }).toList(),
    );
  }
}