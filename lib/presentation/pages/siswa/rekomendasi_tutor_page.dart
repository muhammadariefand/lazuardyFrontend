// lib/presentation/pages/siswa/rekomendasi_tutor_page.dart
// Rekomendasi Tutor "Lihat semua" — list diurutkan rating,
// tap kartu → langsung ke pilih jadwal (skip kategori karena dari rekomendasi)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import '../../../../domain/entities/tutor_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_booking/booking_flow_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_booking/booking_flow_state.dart';


class RekomendasiTutorPage extends StatefulWidget {
  const RekomendasiTutorPage({super.key});

  @override
  State<RekomendasiTutorPage> createState() => _RekomendasiTutorPageState();
}

class _RekomendasiTutorPageState extends State<RekomendasiTutorPage> {

  @override
  void initState() {
    super.initState();
    context.read<BookingFlowCubit>().fetchTutorsByCriteria(page: 1);
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Rekomendasi Tutor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subjudul
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                children: [
                  TextSpan(text: 'Menampilkan tutor untuk '),
                  TextSpan(
                    text: 'Terbaik, ',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  TextSpan(
                      text: 'diurutkan berdasarkan rating tertinggi'),
                ],
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<BookingFlowCubit, BookingFlowState>(
              builder: (context, state) {
                if (state is BookingFlowLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingFlowError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (state is TutorsLoaded) {
                  final tutorList = state.tutors;
                  if (tutorList.isEmpty) {
                    return const Center(
                      child: Text('Belum ada tutor yang tersedia.'),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: tutorList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final t = tutorList[i];
                      return _TutorCard(
                        tutor: t,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/siswa/booking/pilih-jadwal',
                          arguments: {
                            'tutor_id': int.tryParse(t.id),
                          },
                        ),
                      );
                    },
                  );
                }
                
                // Fallback state
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Kartu tutor ───────────────────────────────────────────────────
class _TutorCard extends StatelessWidget {
  final TutorEntity tutor;
  final VoidCallback onTap;
  
  const _TutorCard({required this.tutor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine the subject to display (using the first available subject if any)
    String subjectName = 'Umum';
    if (tutor.subjects != null && tutor.subjects!.isNotEmpty) {
      subjectName = tutor.subjects!.first['subject_name']?.toString() ?? 'Umum';
    }

    // Prepare Initials
    String inisial = tutor.name.isNotEmpty ? tutor.name.substring(0, 1).toUpperCase() : '?';

    // Methods
    bool hasOnline = tutor.learningMethods.any((m) => m.toLowerCase() == 'online');
    bool hasOffline = tutor.learningMethods.any((m) => m.toLowerCase() == 'offline');

    // Rating (fallback to 0.0)
    double rating = tutor.avgRate ?? 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          // Avatar inisial
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(inisial,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.secondary)),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tutor.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subjectName,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.star_rounded, color: AppColors.warningYellow, size: 15),
                const SizedBox(width: 3),
                Text('$rating',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ]),
            ]),
          ),

          // Badge Online / Offline
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasOnline)  _badge('Online',  AppColors.successGreen),
              if (hasOnline && hasOffline) const SizedBox(height: 4),
              if (hasOffline) _badge('Offline', AppColors.errorRed),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _badge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)));
}