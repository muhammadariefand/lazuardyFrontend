// lib/presentation/pages/tutor/beranda/tarik_saldo/tarik_saldo_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/domain/entities/payout_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tarik_saldo/tarik_saldo_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tarik_saldo/tarik_saldo_state.dart';
import 'package:intl/intl.dart';


class TarikSaldoPage extends StatefulWidget {
  const TarikSaldoPage({super.key});

  @override
  State<TarikSaldoPage> createState() => _TarikSaldoPageState();
}

class _TarikSaldoPageState extends State<TarikSaldoPage> {
  final _jumlahCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _jumlahCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TarikSaldoCubit>().fetchMoreHistory();
    }
  }

  String _rp(double v) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(v);
  }

  void _tarikSaldo(TutorEntity tutor) {
    final raw = double.tryParse(_jumlahCtrl.text.trim());
    if (raw == null || raw <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan jumlah penarikan yang valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Asumsi tutor.salary adalah saldo yang tersedia. Jika ada field lain, sesuaikan.
    final availableSaldo = tutor.salary ?? 0.0; 
    
    if (raw > availableSaldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah melebihi saldo tersedia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (tutor.accountNumber == null || tutor.accountNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor rekening tidak ditemukan di profil Anda.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Panggil cubit
    context.read<TarikSaldoCubit>().submitTakeMoney(
          amount: raw,
          bankAccountId: tutor.accountNumber!, // Pakai nomor rekening sebagai identifier
          note: 'Pencairan saldo melalui aplikasi',
        );
  }

  void _showSuksesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon centang hijau
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2E7D32), width: 3),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF2E7D32),
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Penarikan Diajukan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Admin akan memproses penarikan Anda.\nStatus akan diupdate melalui notifikasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Tombol kembali
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kembali Ke Tarik Saldo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<TarikSaldoCubit, TarikSaldoState>(
        listener: (context, state) {
          if (state is TarikSaldoLoaded) {
            if (state.submitErrorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.submitErrorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<TarikSaldoCubit>().clearSubmitMessages();
            } else if (state.submitSuccessMessage != null) {
              _jumlahCtrl.clear();
              _showSuksesDialog();
              context.read<TarikSaldoCubit>().clearSubmitMessages();
            }
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildBody(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(TarikSaldoState state) {
    if (state is TarikSaldoInitial || (state is TarikSaldoLoading && state.isFirstFetch)) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    } else if (state is TarikSaldoError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<TarikSaldoCubit>().initFetch(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    TutorEntity? tutorProfile;
    List<PayoutEntity> payouts = [];
    bool isSubmitting = false;

    if (state is TarikSaldoLoaded) {
      tutorProfile = state.tutorProfile;
      payouts = state.payouts;
      isSubmitting = state.isSubmitting;
    } else if (state is TarikSaldoLoading) {
      tutorProfile = state.tutorProfile;
      payouts = state.oldPayouts;
    }

    if (tutorProfile == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<TarikSaldoCubit>().initFetch();
      },
      color: AppColors.primary,
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 4),

          // ── Card Saldo ────────────────────────────────
          _buildSaldoCard(tutorProfile),
          const SizedBox(height: 14),

          // ── Card Ajukan Penarikan ─────────────────────
          _buildAjukanCard(tutorProfile, isSubmitting),
          const SizedBox(height: 14),

          // ── Banner Info ───────────────────────────────
          _buildInfoBanner(),
          const SizedBox(height: 24),

          // ── Riwayat Penarikan ─────────────────────────
          const Text(
            'Riwayat Penarikan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          if (payouts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'Belum ada riwayat penarikan',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...payouts.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRiwayatCard(p),
              ),
            ),
            
          if (state is TarikSaldoLoaded && !state.hasReachedMax && payouts.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            ),
            
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 4,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 24),
          ),
          const Text(
            'Tarik Saldo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Saldo ────────────────────────────────────────────────
  Widget _buildSaldoCard(TutorEntity tutor) {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + label
          const Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 22, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text(
                'Saldo Tersedia',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Nominal
          Text(
            _rp(tutor.salary ?? 0.0),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Info bank
          Text(
            tutor.bankCode ?? 'Bank Belum Diatur',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            tutor.accountNumber ?? '-',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Ajukan Penarikan ─────────────────────────────────────
  Widget _buildAjukanCard(TutorEntity tutor, bool isSubmitting) {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ajukan Penarikan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // Input jumlah
          TextField(
            controller: _jumlahCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
                fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Masukan jumlah (contoh: 500000)',
              hintStyle: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.attach_money_rounded,
                  color: AppColors.textSecondary, size: 20),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Tombol Tarik Saldo
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSubmitting ? null : () => _tarikSaldo(tutor),
              icon: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.attach_money_rounded,
                      size: 20, color: Colors.white),
              label: const Text(
                'Tarik Saldo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Banner Info ───────────────────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 20, color: Color(0xFFF57C00)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Admin akan memproses penarikan dalam 1-3 hari kerja. '
              'Status dapat dipantau di riwayat di bawah ini.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5D4037),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Riwayat ──────────────────────────────────────────────
  Widget _buildRiwayatCard(PayoutEntity p) {
    final statusStr = p.status.toLowerCase();
    final isApproved = statusStr == 'success' || statusStr == 'approved';
    final isPending  = statusStr == 'pending';

    final Color iconColor = isApproved
        ? const Color(0xFF2E7D32)
        : isPending
            ? const Color(0xFFF57C00)
            : const Color(0xFFC62828);

    final IconData iconData = isApproved
        ? Icons.check_circle_outline_rounded
        : isPending
            ? Icons.hourglass_top_rounded
            : Icons.cancel_outlined;

    final String statusLabel = isApproved
        ? 'Sukses'
        : isPending
            ? 'Pending'
            : 'Gagal';

    final Color badgeBg = isApproved
        ? const Color(0xFFE8F5E9)
        : isPending
            ? const Color(0xFFFFF8E1)
            : const Color(0xFFFFEBEE);

    final Color badgeText = isApproved
        ? const Color(0xFF2E7D32)
        : isPending
            ? const Color(0xFFF57C00)
            : const Color(0xFFC62828);
            
    final String tanggal = DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(p.createdAt);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(iconData, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _rp(p.amount),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Badge status
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: badgeText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared ────────────────────────────────────────────────────
  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}