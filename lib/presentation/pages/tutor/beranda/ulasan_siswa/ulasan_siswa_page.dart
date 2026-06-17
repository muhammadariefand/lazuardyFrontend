// lib/presentation/pages/tutor/beranda/ulasan_siswa/ulasan_siswa_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/ulasan_siswa/ulasan_siswa_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/ulasan_siswa/ulasan_siswa_state.dart';
import 'package:intl/intl.dart';


class UlasanSiswaPage extends StatefulWidget {
  const UlasanSiswaPage({super.key});

  @override
  State<UlasanSiswaPage> createState() => _UlasanSiswaPageState();
}

class _UlasanSiswaPageState extends State<UlasanSiswaPage> {
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
      final state = context.read<UlasanSiswaCubit>().state;
      if (state is UlasanSiswaLoaded && !state.hasReachedMax) {
        context.read<UlasanSiswaCubit>().fetchReviews();
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<UlasanSiswaCubit>().refreshReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ulasan Siswa',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<UlasanSiswaCubit, UlasanSiswaState>(
        builder: (context, state) {
          if (state is UlasanSiswaInitial || (state is UlasanSiswaLoading && state.isFirstFetch)) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is UlasanSiswaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<UlasanSiswaCubit>().refreshReviews(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          } else if (state is UlasanSiswaLoaded || state is UlasanSiswaLoading) {
            List<ReviewEntity> reviews = [];
            double avgRating = 0.0;
            bool hasReachedMax = false;
            int totalReview = 0;

            if (state is UlasanSiswaLoaded) {
              reviews = state.reviews;
              avgRating = state.avgRating;
              hasReachedMax = state.hasReachedMax;
              totalReview = reviews.length;
            } else if (state is UlasanSiswaLoading) {
              reviews = state.oldReviews;
              avgRating = state.avgRating;
              totalReview = reviews.length;
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ── Rating Header ─────────────────────────────
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            avgRating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.1),
                          ),
                          const SizedBox(height: 8),
                          _StarRow(rating: avgRating, size: 24),
                          const SizedBox(height: 8),
                          Text(
                            'Dari rating rata-rata ulasan',
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Empty State ─────────────────────────────
                  if (reviews.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            const Text(
                              'Belum ada ulasan dari siswa',
                              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                          ],
                        ),
                      ),
                    )
                  else
                    // ── List Ulasan ─────────────────────────────
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index < reviews.length) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildUlasanCard(reviews[index]),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                              );
                            }
                          },
                          childCount: reviews.length + (hasReachedMax ? 0 : 1),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ── Kartu Ulasan ──────────────────────────────────────────────
  Widget _buildUlasanCard(ReviewEntity u) {
    final String studentName = 'Siswa';
    final String formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(u.createdAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  studentName[0].toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              // Nama & tgl
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // Bintang pojok
              _StarRow(rating: u.rate, size: 14),
            ],
          ),
          const SizedBox(height: 12),
          // Komentar
          Text(
            u.comment,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Bintang ───────────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRow({required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starVal = i + 1;
        IconData icon;
        if (rating >= starVal) {
          icon = Icons.star_rounded;
        } else if (rating >= starVal - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, color: AppColors.warningYellow, size: size);
      }),
    );
  }
}