// lib/presentation/pages/siswa/booking/pilih_tutor_page.dart
// List tutor diurutkan rating, badge Online/Offline

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import '../../../../domain/entities/tutor_entity.dart';
import '../../../state_management/student_booking/booking_flow_cubit.dart';
import '../../../state_management/student_booking/booking_flow_state.dart';


class PilihTutorPage extends StatefulWidget {
  const PilihTutorPage({super.key});

  @override
  State<PilihTutorPage> createState() => _PilihTutorPageState();
}

class _PilihTutorPageState extends State<PilihTutorPage> {
  Map? args;
  int? subjectId;
  String? mapel;
  String? jenjang;
  String? kategori;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && subjectId == null) {
      subjectId = args?['subject_id'] as int?;
      mapel = args?['mapel'] as String? ?? 'Mapel';
      jenjang = args?['jenjang'] as String?;
      kategori = args?['kategori'] as String? ?? 'akademik';

      // Fetch tutor by criteria
      context.read<BookingFlowCubit>().fetchTutorsByCriteria(
            subjectId: kategori == 'akademik' ? subjectId : null,
            subjectName: kategori == 'umum' ? mapel : null,
            level: jenjang,
          );
    }
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
            onPressed: () => Navigator.pop(context)),
        title: const Text('Pilih Tutor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              children: [
                const TextSpan(text: 'Menampilkan tutor untuk '),
                TextSpan(
                    text: '${mapel ?? "Mata Pelajaran"}, ',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const TextSpan(text: 'diurutkan rating tertinggi'),
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<BookingFlowCubit, BookingFlowState>(
            buildWhen: (prev, current) =>
                current is BookingFlowLoading ||
                current is TutorsLoaded ||
                current is BookingFlowError,
            builder: (context, state) {
              if (state is BookingFlowLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              } else if (state is BookingFlowError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<BookingFlowCubit>().fetchTutorsByCriteria(
                                  subjectId: kategori == 'akademik' ? subjectId : null,
                                  subjectName: kategori == 'umum' ? mapel : null,
                                  level: jenjang,
                                );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                );
              } else if (state is TutorsLoaded) {
                final tutors = state.tutors;

                if (tutors.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada tutor yang tersedia untuk kriteria ini',
                        style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: tutors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _TutorCard(
                    tutor: tutors[i],
                    mapel: mapel ?? 'Mapel',
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/siswa/booking/pilih-jadwal',
                      arguments: {
                        ...?args,
                        'tutor_id': int.parse(tutors[i].id),
                        'tutor_nama': tutors[i].name,
                        'tutor_mapel': mapel,
                        'tutor_rating': tutors[i].avgRate ?? 0.0,
                        'tutor_ulasan': 0, // Belum ada field ulasan
                        'tutor_inisial': tutors[i].name.isNotEmpty ? tutors[i].name[0].toUpperCase() : 'T',
                        'tutor_photo': tutors[i].profilePhotoUrl,
                      },
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ]),
    );
  }
}

class _TutorCard extends StatelessWidget {
  final TutorEntity tutor;
  final String mapel;
  final VoidCallback onTap;
  const _TutorCard({required this.tutor, required this.mapel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Check if learningMethods contains online/offline
    final hasOnline = tutor.learningMethods.any((element) => element.toLowerCase() == 'online');
    final hasOffline = tutor.learningMethods.any((element) => element.toLowerCase() == 'offline');
    final String inisial = tutor.name.isNotEmpty ? tutor.name[0].toUpperCase() : 'T';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(children: [
          // Avatar inisial
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                image: tutor.profilePhotoUrl != null && tutor.profilePhotoUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(tutor.profilePhotoUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
            ),
            alignment: Alignment.center,
            child: (tutor.profilePhotoUrl == null || tutor.profilePhotoUrl!.isEmpty)
              ? Text(inisial,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary))
              : null,
          ),
          const SizedBox(width: 14),

          // Nama + mapel + rating
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tutor.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(mapel,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.star_rounded, color: AppColors.warningYellow, size: 15),
                const SizedBox(width: 3),
                Text('${tutor.avgRate ?? 0.0}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                // const Text('  (0 ulasan)',
                //     style: TextStyle(
                //         fontSize: 12, color: AppColors.textSecondary)),
              ]),
            ]),
          ),

          // Badge Online / Offline
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasOnline) _badge('Online', AppColors.successGreen),
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
        border: Border.all(color: color.withOpacity(0.3))),
    child: Text(label,
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, color: color)));
}