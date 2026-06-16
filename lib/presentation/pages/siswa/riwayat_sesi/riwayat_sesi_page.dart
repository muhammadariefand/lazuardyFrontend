// lib/presentation/pages/siswa/riwayat_sesi_page.dart
// List riwayat sesi — data dari API via RiwayatSesiCubit

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import '../../../../domain/entities/schedule_entity.dart';
import '../../../state_management/riwayat_sesi/riwayat_sesi_cubit.dart';
import '../../../state_management/riwayat_sesi/riwayat_sesi_state.dart';

const _teal = Color(0xFF3AAFA9);
const _navy = Color(0xFF1E2D7D);

class RiwayatSesiPage extends StatefulWidget {
  const RiwayatSesiPage({super.key});

  @override
  State<RiwayatSesiPage> createState() => _RiwayatSesiPageState();
}

class _RiwayatSesiPageState extends State<RiwayatSesiPage> {
  @override
  void initState() {
    super.initState();
    context.read<RiwayatSesiCubit>().fetchRiwayatSesi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Sesi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<RiwayatSesiCubit, RiwayatSesiState>(
        builder: (context, state) {
          if (state is RiwayatSesiLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _teal),
            );
          }

          if (state is RiwayatSesiError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFE53E3E), size: 48),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<RiwayatSesiCubit>().fetchRiwayatSesi(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is RiwayatSesiListLoaded) {
            if (state.schedules.isEmpty) {
              return _buildEmptyState();
            }
            return RefreshIndicator(
              color: _teal,
              onRefresh: () =>
                  context.read<RiwayatSesiCubit>().fetchRiwayatSesi(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.schedules.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final sesi = state.schedules[i];
                  return _SesiCard(
                    sesi: sesi,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/siswa/riwayat-sesi/detail',
                      arguments: {'schedule_id': sesi.id},
                    ),
                  );
                },
              ),
            );
          }

          // Initial state — tampilkan kosong sementara
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📋', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text(
              'Belum ada riwayat sesi',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
}

// ── Kartu sesi ────────────────────────────────────────────────────
class _SesiCard extends StatelessWidget {
  final ScheduleEntity sesi;
  final VoidCallback onTap;

  const _SesiCard({required this.sesi, required this.onTap});

  /// Mapping status backend → label & warna
  _StatusInfo get _statusInfo {
    switch (sesi.status.toLowerCase()) {
      case 'completed':
        return _StatusInfo('Selesai', const Color(0xFF4CAF50));
      case 'cancelled':
        return _StatusInfo('Dibatalkan', const Color(0xFFE53E3E));
      case 'reported':
        return _StatusInfo('Menunggu Konfirmasi', const Color(0xFF8B5CF6));
      case 'ongoing':
        return _StatusInfo('Sedang Berlangsung', const Color(0xFF3AAFA9));
      default:
        return _StatusInfo('Menunggu', const Color(0xFFF59E0B));
    }
  }

  String get _tutorInisial {
    final parts = sesi.tutorName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return sesi.tutorName.isNotEmpty
        ? sesi.tutorName[0].toUpperCase()
        : '?';
  }

  String _formatTanggal(DateTime dt) {
    return DateFormat('d MMM yyyy', 'id').format(dt.toLocal());
  }

  String _formatJam(DateTime start, DateTime end) {
    final f = DateFormat('HH:mm');
    return '${f.format(start.toLocal())} - ${f.format(end.toLocal())}';
  }

  @override
  Widget build(BuildContext context) {
    final info = _statusInfo;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: info.color.withOpacity(0.5), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar inisial tutor
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                _tutorInisial,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama mapel + tutor + badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${sesi.subjectName} — ${sesi.tutorName}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(info: info),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Tanggal & jam
                  Text(
                    '${_formatTanggal(sesi.date)} · ${_formatJam(sesi.startTime, sesi.endTime)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Metode pembelajaran
                  Row(
                    children: [
                      _MethodBadge(method: sesi.learningMethod),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Method badge ──────────────────────────────────────────────────
class _MethodBadge extends StatelessWidget {
  final String method;
  const _MethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    final isOnline = method.toLowerCase() == 'online';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline
            ? const Color(0xFF3B82F6).withOpacity(0.1)
            : const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline
              ? const Color(0xFF3B82F6).withOpacity(0.4)
              : const Color(0xFF10B981).withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.videocam_outlined : Icons.location_on_outlined,
            size: 12,
            color: isOnline
                ? const Color(0xFF3B82F6)
                : const Color(0xFF10B981),
          ),
          const SizedBox(width: 4),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isOnline
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────
class _StatusInfo {
  final String label;
  final Color color;
  const _StatusInfo(this.label, this.color);
}

class _StatusBadge extends StatelessWidget {
  final _StatusInfo info;
  const _StatusBadge({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: info.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: info.color.withOpacity(0.3)),
      ),
      child: Text(
        info.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: info.color,
        ),
      ),
    );
  }
}