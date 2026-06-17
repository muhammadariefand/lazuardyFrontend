// lib/presentation/pages/siswa/booking/pilih_kategori_page.dart
// Pilih Kategori → tap Akademik → expand jenjang & mapel

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import '../../../../domain/entities/subject_entity.dart';
import '../../../state_management/student_booking/booking_flow_cubit.dart';
import '../../../state_management/student_booking/booking_flow_state.dart';


class PilihKategoriPage extends StatefulWidget {
  const PilihKategoriPage({super.key});
  @override
  State<PilihKategoriPage> createState() => _PilihKategoriPageState();
}

class _PilihKategoriPageState extends State<PilihKategoriPage> {
  // State expand per kategori
  String? _expandedKategori; // 'akademik' or 'umum'

  // State pilihan
  String? _selectedJenjang;
  SubjectEntity? _selectedSubject;
  
  // Data dinamis dari API
  List<String> _jenjangList = [];
  List<SubjectEntity> _mapelList = [];

  // Data statis untuk Umum
  final List<SubjectEntity> _mapelUmum = [
    SubjectEntity(id: -1, name: 'Mengaji', level: 'Umum'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<BookingFlowCubit>().fetchJenjang();
  }

  void _onKategoriTap(String kategori) {
    setState(() {
      if (_expandedKategori == kategori) {
        // Toggle off
        _expandedKategori = null;
        _selectedJenjang = null;
        _selectedSubject = null;
        _mapelList = [];
      } else {
        _expandedKategori = kategori;
        if (kategori == 'akademik') {
          // Default jenjang pertama jika tersedia
          _selectedJenjang = _jenjangList.isNotEmpty ? _jenjangList.first : null;
          _selectedSubject = null;
          _mapelList = [];
          if (_selectedJenjang != null) {
            context.read<BookingFlowCubit>().fetchClasses(_selectedJenjang!);
          }
        } else {
          // Kategori Umum
          _selectedJenjang = null;
          _selectedSubject = null;
          _mapelList = _mapelUmum;
        }
      }
    });
  }

  void _onJenjangTap(String jenjang) {
    if (_selectedJenjang != jenjang) {
      setState(() {
        _selectedJenjang = jenjang;
        _selectedSubject = null;
        _mapelList = [];
      });
      context.read<BookingFlowCubit>().fetchClasses(jenjang);
    }
  }

  void _onLanjutkan() {
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih mata pelajaran terlebih dahulu'),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ));
      return;
    }
    
    Navigator.pushNamed(context, '/siswa/booking/pilih-tutor',
        arguments: {
          'kategori': _expandedKategori,
          'jenjang': _selectedJenjang, // bisa null untuk umum
          'class_id': _selectedSubject!.id,   // id kelas dari API /getClassByLevel
          'mapel': _selectedSubject!.name,
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingFlowCubit, BookingFlowState>(
      listener: (context, state) {
        if (state is BookingFlowError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ));
        } else if (state is JenjangLoaded) {
          setState(() {
            _jenjangList = state.jenjangList;
          });
        } else if (state is ClassesLoaded) {
          setState(() {
            _mapelList = state.classes;
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingFlowLoading;

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
            title: const Text('Pilih Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          bottomNavigationBar: _selectedSubject != null
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onLanjutkan,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text('Lanjutkan',
                          style:
                              TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 4),
              const Text('Pilih Kategori Pembelajaran',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 16),

              // ── Kartu Akademik ────────────────────────────────────
              _buildKategoriCard(
                icon: '📚',
                title: 'Akademik',
                subtitle: 'Matematika, Fisika, Kimia, dll.',
                isExpanded: _expandedKategori == 'akademik',
                onTap: () => _onKategoriTap('akademik'),
              ),

              // ── Expand: Jenjang + Mapel Akademik ─────────────────
              if (_expandedKategori == 'akademik') ...[
                const SizedBox(height: 20),
                _buildJenjangSection(isLoading),
                const SizedBox(height: 20),
                _buildMapelSection(isLoading),
              ],

              const SizedBox(height: 16),

              // ── Kartu Umum ────────────────────────────────────────
              _buildKategoriCard(
                icon: '📖',
                title: 'Umum',
                subtitle: 'Mengaji',
                isExpanded: _expandedKategori == 'umum',
                onTap: () => _onKategoriTap('umum'),
              ),

              // ── Expand: Mapel Umum ────────────────────────────────
              if (_expandedKategori == 'umum') ...[
                const SizedBox(height: 20),
                _buildMapelSection(false), // Umum tidak hit API (statis)
              ],

              const SizedBox(height: 32),
            ]),
          ),
        );
      },
    );
  }

  // ── Kartu kategori ─────────────────────────────────────────────
  Widget _buildKategoriCard({
    required String icon,
    required String title,
    required String subtitle,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExpanded ? AppColors.primary : AppColors.primary.withOpacity(0.4),
            width: isExpanded ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
                color: isExpanded
                    ? AppColors.primary.withOpacity(0.1)
                     : Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ]),
          ),
          Icon(Icons.chevron_right_rounded,
              color: Colors.grey.shade400, size: 22),
        ]),
      ),
    );
  }

  // ── Chip jenjang SD/SMP/SMA ─────────────────────────────────────
  Widget _buildJenjangSection(bool isLoading) {
    if (_jenjangList.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    } else if (_jenjangList.isEmpty) {
      return const Text('Tidak ada jenjang tersedia', style: TextStyle(color: AppColors.textSecondary));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Pilih Jenjang',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 10),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _jenjangList.map((j) {
        final isSelected = _selectedJenjang == j;
        return GestureDetector(
          onTap: () => _onJenjangTap(j),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.5),
                  width: isSelected ? 1.5 : 1.2),
            ),
            child: Text(j,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary)),
          ),
        );
      }).toList()),
    ]);
  }

  // ── Chip mapel ──────────────────────────────────────────────────
  Widget _buildMapelSection(bool isLoading) {
    if (_expandedKategori == 'akademik' && isLoading && _mapelList.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    } else if (_mapelList.isEmpty) {
      return const Text('Tidak ada mata pelajaran tersedia', style: TextStyle(color: AppColors.textSecondary));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Pilih Kelas',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 10),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _mapelList.map((mapel) {
          final isSelected = _selectedSubject?.id == mapel.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedSubject = mapel),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.5),
                    width: isSelected ? 1.5 : 1.2),
              ),
              child: Text(mapel.name,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : AppColors.textPrimary)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}