// lib/presentation/pages/siswa/ulasan_tutor/ulasan_tutor_page.dart
// Riwayat Ulasan Tutor — list kartu ulasan dengan bintang parsial

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/ulasan_tutor/ulasan_tutor_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/ulasan_tutor/ulasan_tutor_state.dart';
import 'package:intl/intl.dart';


class UlasanTutorPage extends StatefulWidget {
  const UlasanTutorPage({super.key});

  @override
  State<UlasanTutorPage> createState() => _UlasanTutorPageState();
}

class _UlasanTutorPageState extends State<UlasanTutorPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<UlasanTutorCubit>().state;
      if (state is UlasanTutorLoaded && !state.hasReachedMax) {
        context.read<UlasanTutorCubit>().fetchReviews();
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<UlasanTutorCubit>().refreshReviews();
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
        title: const Text('Ulasan Tutor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: BlocBuilder<UlasanTutorCubit, UlasanTutorState>(
        builder: (context, state) {
          if (state is UlasanTutorInitial || (state is UlasanTutorLoading && state.isFirstFetch)) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is UlasanTutorError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<UlasanTutorCubit>().fetchReviews(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          } else if (state is UlasanTutorLoaded || state is UlasanTutorLoading) {
            List<ReviewEntity> reviews = [];
            bool hasReachedMax = false;

            if (state is UlasanTutorLoaded) {
              reviews = state.reviews;
              hasReachedMax = state.hasReachedMax;
            } else if (state is UlasanTutorLoading) {
              reviews = state.oldReviews;
            }

            if (reviews.isEmpty) {
              return _buildEmpty();
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length + (hasReachedMax ? 0 : 1),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  if (i < reviews.length) {
                    return _UlasanCard(item: reviews[i]);
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    );
                  }
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmpty() => RefreshIndicator(
    onRefresh: _onRefresh,
    color: AppColors.primary,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('⭐', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text('Belum ada ulasan',
                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    ),
  );
}

// ── Kartu ulasan ──────────────────────────────────────────────────
class _UlasanCard extends StatelessWidget {
  final ReviewEntity item;
  const _UlasanCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(item.createdAt);
    final String tutorName = item.tutorName.isNotEmpty ? item.tutorName : 'Tutor';
    final String subjectName = item.subjectName.isNotEmpty ? item.subjectName : '-';

    return Container(
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header: nama tutor + bintang
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(tutorName,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            _StarRow(rating: item.rate),
          ],
        ),
        const SizedBox(height: 3),

        // Mapel + tanggal
        Text('$subjectName • $formattedDate',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 12),

        // Teks ulasan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            item.comment,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textPrimary, height: 1.5),
          ),
        ),
      ]),
    );
  }
}

// ── Bintang parsial ───────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final double rating; // 1.0 – 5.0, mendukung setengah bintang
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starVal = i + 1;
        IconData icon;
        if (rating >= starVal) {
          icon = Icons.star_rounded;           // penuh
        } else if (rating >= starVal - 0.5) {
          icon = Icons.star_half_rounded;      // setengah
        } else {
          icon = Icons.star_outline_rounded;   // kosong
        }
        return Icon(icon, color: AppColors.warningYellow, size: 16);
      }),
    );
  }
}
